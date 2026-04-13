package com.mhmp.config;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.entity.RepairAcceptance;
import com.mhmp.entity.RepairLog;
import com.mhmp.entity.RepairPlan;
import com.mhmp.entity.RepairTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundDetail;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.entity.RelicOutboundDetail;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairPlanMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Component
@ConditionalOnProperty(prefix = "mhmp.startup", name = "init-enabled", havingValue = "true")
@Order(0)
public class LegacyBusinessNoInitializer implements ApplicationRunner {

    private static final Pattern DATE_SERIAL_PATTERN = Pattern.compile("^([A-Z]+)-(\\d{8})-(\\d{3,})$");
    private static final Pattern YEAR_SERIAL_PATTERN = Pattern.compile("^([A-Z]+)-(\\d{4})-(\\d{3,})$");
    private static final Pattern YEAR_PATTERN = Pattern.compile("(20\\d{2})");
    private static final DateTimeFormatter DATE_SEGMENT_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");

    private final RelicMapper relicMapper;
    private final RelicInboundOrderMapper relicInboundOrderMapper;
    private final RelicInboundDetailMapper relicInboundDetailMapper;
    private final RelicOutboundOrderMapper relicOutboundOrderMapper;
    private final RelicOutboundDetailMapper relicOutboundDetailMapper;
    private final InventoryTaskMapper inventoryTaskMapper;
    private final InventoryTaskDetailMapper inventoryTaskDetailMapper;
    private final RepairTaskMapper repairTaskMapper;
    private final RepairPlanMapper repairPlanMapper;
    private final RepairLogMapper repairLogMapper;
    private final RepairAcceptanceMapper repairAcceptanceMapper;

    public LegacyBusinessNoInitializer(RelicMapper relicMapper,
                                       RelicInboundOrderMapper relicInboundOrderMapper,
                                       RelicInboundDetailMapper relicInboundDetailMapper,
                                       RelicOutboundOrderMapper relicOutboundOrderMapper,
                                       RelicOutboundDetailMapper relicOutboundDetailMapper,
                                       InventoryTaskMapper inventoryTaskMapper,
                                       InventoryTaskDetailMapper inventoryTaskDetailMapper,
                                       RepairTaskMapper repairTaskMapper,
                                       RepairPlanMapper repairPlanMapper,
                                       RepairLogMapper repairLogMapper,
                                       RepairAcceptanceMapper repairAcceptanceMapper) {
        this.relicMapper = relicMapper;
        this.relicInboundOrderMapper = relicInboundOrderMapper;
        this.relicInboundDetailMapper = relicInboundDetailMapper;
        this.relicOutboundOrderMapper = relicOutboundOrderMapper;
        this.relicOutboundDetailMapper = relicOutboundDetailMapper;
        this.inventoryTaskMapper = inventoryTaskMapper;
        this.inventoryTaskDetailMapper = inventoryTaskDetailMapper;
        this.repairTaskMapper = repairTaskMapper;
        this.repairPlanMapper = repairPlanMapper;
        this.repairLogMapper = repairLogMapper;
        this.repairAcceptanceMapper = repairAcceptanceMapper;
    }

    @Override
    public void run(ApplicationArguments args) {
        normalizeRelics();
        normalizeInboundOrders();
        normalizeOutboundOrders();
        normalizeInventoryTasks();
        normalizeRepairTasks();
        normalizeRepairPlans();
        normalizeRepairLogs();
        normalizeRepairAcceptances();
        syncRelicSnapshots();
    }

    private void normalizeRelics() {
        List<Relic> relics = relicMapper.selectList(
            Wrappers.<Relic>lambdaQuery()
                .orderByAsc(Relic::getId)
        );
        normalizeYearSerial(
            relics,
            "REL",
            Relic::getRelicNo,
            Relic::setRelicNo,
            Relic::getCreateTime,
            relicMapper::updateById
        );
    }

    private void normalizeInboundOrders() {
        List<RelicInboundOrder> orders = relicInboundOrderMapper.selectList(
            Wrappers.<RelicInboundOrder>lambdaQuery()
                .orderByAsc(RelicInboundOrder::getId)
        );
        normalizeYearSerial(
            orders,
            "IN",
            RelicInboundOrder::getOrderNo,
            RelicInboundOrder::setOrderNo,
            RelicInboundOrder::getInboundTime,
            relicInboundOrderMapper::updateById
        );
        normalizeYearSerial(
            orders,
            "BATCH",
            RelicInboundOrder::getBatchNo,
            RelicInboundOrder::setBatchNo,
            RelicInboundOrder::getInboundTime,
            relicInboundOrderMapper::updateById
        );
    }

    private void normalizeOutboundOrders() {
        List<RelicOutboundOrder> orders = relicOutboundOrderMapper.selectList(
            Wrappers.<RelicOutboundOrder>lambdaQuery()
                .orderByAsc(RelicOutboundOrder::getId)
        );
        normalizeYearSerial(
            orders,
            "OUT",
            RelicOutboundOrder::getOrderNo,
            RelicOutboundOrder::setOrderNo,
            RelicOutboundOrder::getOutboundTime,
            relicOutboundOrderMapper::updateById
        );
    }

    private void normalizeInventoryTasks() {
        List<InventoryTask> tasks = inventoryTaskMapper.selectList(
            Wrappers.<InventoryTask>lambdaQuery()
                .orderByAsc(InventoryTask::getId)
        );
        normalizeYearSerial(
            tasks,
            "INV",
            InventoryTask::getTaskNo,
            InventoryTask::setTaskNo,
            InventoryTask::getStartTime,
            inventoryTaskMapper::updateById
        );
    }

    private void normalizeRepairTasks() {
        List<RepairTask> tasks = repairTaskMapper.selectList(
            Wrappers.<RepairTask>lambdaQuery()
                .orderByAsc(RepairTask::getId)
        );
        normalizeYearSerial(
            tasks,
            "REP",
            RepairTask::getTaskNo,
            RepairTask::setTaskNo,
            RepairTask::getApplyTime,
            repairTaskMapper::updateById
        );
    }

    private void normalizeRepairPlans() {
        List<RepairPlan> plans = repairPlanMapper.selectList(
            Wrappers.<RepairPlan>lambdaQuery()
                .orderByAsc(RepairPlan::getId)
        );
        normalizeYearSerial(
            plans,
            "PLAN",
            RepairPlan::getPlanNo,
            RepairPlan::setPlanNo,
            RepairPlan::getReviewTime,
            repairPlanMapper::updateById
        );
    }

    private void normalizeRepairLogs() {
        List<RepairLog> logs = repairLogMapper.selectList(
            Wrappers.<RepairLog>lambdaQuery()
                .orderByAsc(RepairLog::getId)
        );
        normalizeYearSerial(
            logs,
            "LOG",
            RepairLog::getLogNo,
            RepairLog::setLogNo,
            RepairLog::getLogTime,
            repairLogMapper::updateById
        );
    }

    private void normalizeRepairAcceptances() {
        List<RepairAcceptance> acceptances = repairAcceptanceMapper.selectList(
            Wrappers.<RepairAcceptance>lambdaQuery()
                .orderByAsc(RepairAcceptance::getId)
        );
        normalizeYearSerial(
            acceptances,
            "ACC",
            RepairAcceptance::getAcceptanceNo,
            RepairAcceptance::setAcceptanceNo,
            RepairAcceptance::getAcceptanceTime,
            repairAcceptanceMapper::updateById
        );
    }

    private <T> void normalizeYearSerial(List<T> entities,
                                         String prefix,
                                         java.util.function.Function<T, String> codeGetter,
                                         java.util.function.BiConsumer<T, String> codeSetter,
                                         java.util.function.Function<T, LocalDateTime> timeResolver,
                                         java.util.function.Consumer<T> updater) {
        Map<LocalDate, Integer> dateMaxMap = new HashMap<>();
        for (T entity : entities) {
            BusinessNoParts businessNo = parseBusinessNo(prefix, codeGetter.apply(entity));
            if (businessNo == null || businessNo.businessDate() == null) {
                continue;
            }
            dateMaxMap.merge(businessNo.businessDate(), businessNo.seq(), Math::max);
        }

        List<T> legacyEntities = entities.stream()
            .filter(entity -> !matchesDateSerial(prefix, codeGetter.apply(entity)))
            .toList();

        for (T entity : legacyEntities) {
            BusinessNoParts businessNo = parseBusinessNo(prefix, codeGetter.apply(entity));
            LocalDate businessDate = resolveDate(codeGetter.apply(entity), timeResolver.apply(entity));
            int currentMax = dateMaxMap.getOrDefault(businessDate, 0);
            int nextSeq = businessNo == null ? currentMax + 1 : businessNo.seq();
            if (nextSeq <= currentMax) {
                nextSeq = currentMax + 1;
            }
            dateMaxMap.put(businessDate, nextSeq);
            codeSetter.accept(entity, formatBusinessNo(prefix, businessDate, nextSeq));
            updater.accept(entity);
        }
    }

    private boolean matchesDateSerial(String prefix, String code) {
        BusinessNoParts businessNo = parseBusinessNo(prefix, code);
        return businessNo != null && businessNo.businessDate() != null;
    }

    private LocalDate resolveDate(String code, LocalDateTime fallbackTime) {
        if (StringUtils.hasText(code)) {
            Matcher dateMatcher = DATE_SERIAL_PATTERN.matcher(code);
            if (dateMatcher.matches()) {
                return LocalDate.parse(dateMatcher.group(2), DATE_SEGMENT_FORMATTER);
            }
            Matcher matcher = YEAR_PATTERN.matcher(code);
            if (matcher.find()) {
                int year = Integer.parseInt(matcher.group(1));
                if (fallbackTime != null && fallbackTime.getYear() == year) {
                    return fallbackTime.toLocalDate();
                }
                return LocalDate.of(year, 1, 1);
            }
        }
        if (fallbackTime != null) {
            return fallbackTime.toLocalDate();
        }
        return LocalDate.now();
    }

    private String formatBusinessNo(String prefix, LocalDate businessDate, int seq) {
        return String.format("%s-%s-%03d", prefix, businessDate.format(DATE_SEGMENT_FORMATTER), seq);
    }

    private BusinessNoParts parseBusinessNo(String prefix, String code) {
        if (!StringUtils.hasText(code)) {
            return null;
        }

        Matcher dateMatcher = DATE_SERIAL_PATTERN.matcher(code);
        if (dateMatcher.matches() && prefix.equals(dateMatcher.group(1))) {
            return new BusinessNoParts(
                LocalDate.parse(dateMatcher.group(2), DATE_SEGMENT_FORMATTER),
                Integer.parseInt(dateMatcher.group(3))
            );
        }

        Matcher yearMatcher = YEAR_SERIAL_PATTERN.matcher(code);
        if (yearMatcher.matches() && prefix.equals(yearMatcher.group(1))) {
            return new BusinessNoParts(
                null,
                Integer.parseInt(yearMatcher.group(3))
            );
        }
        return null;
    }

    private record BusinessNoParts(LocalDate businessDate, int seq) {
    }

    private void syncRelicSnapshots() {
        Map<Long, Relic> relicMap = relicMapper.selectList(null).stream()
            .collect(Collectors.toMap(Relic::getId, relic -> relic));

        for (RelicInboundDetail detail : relicInboundDetailMapper.selectList(null)) {
            Relic relic = relicMap.get(detail.getRelicId());
            if (relic == null) {
                continue;
            }
            if (!java.util.Objects.equals(detail.getRelicNo(), relic.getRelicNo())
                || !java.util.Objects.equals(detail.getRelicName(), relic.getName())) {
                detail.setRelicNo(relic.getRelicNo());
                detail.setRelicName(relic.getName());
                relicInboundDetailMapper.updateById(detail);
            }
        }

        for (RelicOutboundDetail detail : relicOutboundDetailMapper.selectList(null)) {
            Relic relic = relicMap.get(detail.getRelicId());
            if (relic == null) {
                continue;
            }
            if (!java.util.Objects.equals(detail.getRelicNo(), relic.getRelicNo())
                || !java.util.Objects.equals(detail.getRelicName(), relic.getName())) {
                detail.setRelicNo(relic.getRelicNo());
                detail.setRelicName(relic.getName());
                relicOutboundDetailMapper.updateById(detail);
            }
        }

        for (InventoryTaskDetail detail : inventoryTaskDetailMapper.selectList(null)) {
            Relic relic = relicMap.get(detail.getRelicId());
            if (relic == null) {
                continue;
            }
            if (!java.util.Objects.equals(detail.getRelicNo(), relic.getRelicNo())
                || !java.util.Objects.equals(detail.getRelicName(), relic.getName())) {
                detail.setRelicNo(relic.getRelicNo());
                detail.setRelicName(relic.getName());
                inventoryTaskDetailMapper.updateById(detail);
            }
        }

        for (RepairTask task : repairTaskMapper.selectList(null)) {
            Relic relic = relicMap.get(task.getRelicId());
            if (relic == null) {
                continue;
            }
            if (!java.util.Objects.equals(task.getRelicNo(), relic.getRelicNo())
                || !java.util.Objects.equals(task.getRelicName(), relic.getName())) {
                task.setRelicNo(relic.getRelicNo());
                task.setRelicName(relic.getName());
                repairTaskMapper.updateById(task);
            }
        }
    }
}

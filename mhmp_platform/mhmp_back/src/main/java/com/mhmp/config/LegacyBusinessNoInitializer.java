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
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Component
@Order(0)
public class LegacyBusinessNoInitializer implements ApplicationRunner {

    private static final Pattern YEAR_SERIAL_PATTERN = Pattern.compile("^([A-Z]+)-(\\d{4})-(\\d{3,})$");
    private static final Pattern YEAR_PATTERN = Pattern.compile("(20\\d{2})");

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
            relic -> resolveYear(relic.getRelicNo(), relic.getCreateTime()),
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
            order -> resolveYear(order.getOrderNo(), order.getInboundTime()),
            relicInboundOrderMapper::updateById
        );
        normalizeYearSerial(
            orders,
            "BATCH",
            RelicInboundOrder::getBatchNo,
            RelicInboundOrder::setBatchNo,
            order -> resolveYear(order.getBatchNo(), order.getInboundTime()),
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
            order -> resolveYear(order.getOrderNo(), order.getOutboundTime()),
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
            task -> resolveYear(task.getTaskNo(), task.getStartTime()),
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
            task -> resolveYear(task.getTaskNo(), task.getApplyTime()),
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
            plan -> resolveYear(plan.getPlanNo(), plan.getReviewTime()),
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
            log -> resolveYear(log.getLogNo(), log.getLogTime()),
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
            acceptance -> resolveYear(acceptance.getAcceptanceNo(), acceptance.getAcceptanceTime()),
            repairAcceptanceMapper::updateById
        );
    }

    private <T> void normalizeYearSerial(List<T> entities,
                                         String prefix,
                                         java.util.function.Function<T, String> codeGetter,
                                         java.util.function.BiConsumer<T, String> codeSetter,
                                         java.util.function.ToIntFunction<T> yearResolver,
                                         java.util.function.Consumer<T> updater) {
        Map<Integer, Integer> yearMaxMap = new HashMap<>();
        for (T entity : entities) {
            String code = codeGetter.apply(entity);
            Matcher matcher = YEAR_SERIAL_PATTERN.matcher(code == null ? "" : code);
            if (!matcher.matches() || !prefix.equals(matcher.group(1))) {
                continue;
            }
            int year = Integer.parseInt(matcher.group(2));
            int seq = Integer.parseInt(matcher.group(3));
            yearMaxMap.merge(year, seq, Math::max);
        }

        List<T> legacyEntities = entities.stream()
            .filter(entity -> !matchesYearSerial(prefix, codeGetter.apply(entity)))
            .sorted(Comparator.comparing(
                entity -> legacySortKey(codeGetter.apply(entity)),
                Comparator.nullsLast(String::compareTo)
            ))
            .toList();

        for (T entity : legacyEntities) {
            int year = yearResolver.applyAsInt(entity);
            int nextSeq = yearMaxMap.getOrDefault(year, 0) + 1;
            yearMaxMap.put(year, nextSeq);
            codeSetter.accept(entity, String.format("%s-%d-%03d", prefix, year, nextSeq));
            updater.accept(entity);
        }
    }

    private boolean matchesYearSerial(String prefix, String code) {
        if (!StringUtils.hasText(code)) {
            return false;
        }
        Matcher matcher = YEAR_SERIAL_PATTERN.matcher(code);
        return matcher.matches() && prefix.equals(matcher.group(1));
    }

    private int resolveYear(String code, LocalDateTime fallbackTime) {
        if (StringUtils.hasText(code)) {
            Matcher matcher = YEAR_PATTERN.matcher(code);
            if (matcher.find()) {
                return Integer.parseInt(matcher.group(1));
            }
        }
        if (fallbackTime != null) {
            return fallbackTime.getYear();
        }
        return LocalDateTime.now().getYear();
    }

    private String legacySortKey(String code) {
        return StringUtils.hasText(code) ? code : "ZZZ";
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

package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.RepairAcceptance;
import com.mhmp.entity.RepairLog;
import com.mhmp.entity.RepairPlan;
import com.mhmp.entity.RepairTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.entity.SysDictItem;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairPlanMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.SysDictItemMapper;
import com.mhmp.service.BusinessNoService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class BusinessNoServiceImpl implements BusinessNoService {

    private static final Pattern DATE_SERIAL_PATTERN = Pattern.compile("^([A-Z]+)-(\\d{8})-(\\d{3,})$");
    private static final Pattern CATEGORY_PATTERN = Pattern.compile("^CATEGORY_(\\d{3,})$");
    private static final Pattern MATERIAL_PATTERN = Pattern.compile("^MATERIAL_(\\d{3,})$");
    private static final DateTimeFormatter DATE_SEGMENT_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");

    private final RelicMapper relicMapper;
    private final RelicInboundOrderMapper relicInboundOrderMapper;
    private final RelicOutboundOrderMapper relicOutboundOrderMapper;
    private final InventoryTaskMapper inventoryTaskMapper;
    private final RepairTaskMapper repairTaskMapper;
    private final RepairPlanMapper repairPlanMapper;
    private final RepairLogMapper repairLogMapper;
    private final RepairAcceptanceMapper repairAcceptanceMapper;
    private final SysDictItemMapper sysDictItemMapper;

    public BusinessNoServiceImpl(RelicMapper relicMapper,
                                 RelicInboundOrderMapper relicInboundOrderMapper,
                                 RelicOutboundOrderMapper relicOutboundOrderMapper,
                                 InventoryTaskMapper inventoryTaskMapper,
                                 RepairTaskMapper repairTaskMapper,
                                 RepairPlanMapper repairPlanMapper,
                                 RepairLogMapper repairLogMapper,
                                 RepairAcceptanceMapper repairAcceptanceMapper,
                                 SysDictItemMapper sysDictItemMapper) {
        this.relicMapper = relicMapper;
        this.relicInboundOrderMapper = relicInboundOrderMapper;
        this.relicOutboundOrderMapper = relicOutboundOrderMapper;
        this.inventoryTaskMapper = inventoryTaskMapper;
        this.repairTaskMapper = repairTaskMapper;
        this.repairPlanMapper = repairPlanMapper;
        this.repairLogMapper = repairLogMapper;
        this.repairAcceptanceMapper = repairAcceptanceMapper;
        this.sysDictItemMapper = sysDictItemMapper;
    }

    @Override
    public synchronized String nextRelicNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("REL", currentDate, relicMapper.selectList(
            Wrappers.<Relic>lambdaQuery()
                .select(Relic::getRelicNo)
                .likeRight(Relic::getRelicNo, datePrefix("REL", currentDate))
        ).stream().map(Relic::getRelicNo).toList());
    }

    @Override
    public synchronized String nextInboundOrderNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("IN", currentDate, relicInboundOrderMapper.selectList(
            Wrappers.<RelicInboundOrder>lambdaQuery()
                .select(RelicInboundOrder::getOrderNo)
                .likeRight(RelicInboundOrder::getOrderNo, datePrefix("IN", currentDate))
        ).stream().map(RelicInboundOrder::getOrderNo).toList());
    }

    @Override
    public synchronized String nextInboundBatchNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("BATCH", currentDate, relicInboundOrderMapper.selectList(
            Wrappers.<RelicInboundOrder>lambdaQuery()
                .select(RelicInboundOrder::getBatchNo)
                .likeRight(RelicInboundOrder::getBatchNo, datePrefix("BATCH", currentDate))
        ).stream().map(RelicInboundOrder::getBatchNo).toList());
    }

    @Override
    public synchronized String nextOutboundOrderNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("OUT", currentDate, relicOutboundOrderMapper.selectList(
            Wrappers.<RelicOutboundOrder>lambdaQuery()
                .select(RelicOutboundOrder::getOrderNo)
                .likeRight(RelicOutboundOrder::getOrderNo, datePrefix("OUT", currentDate))
        ).stream().map(RelicOutboundOrder::getOrderNo).toList());
    }

    @Override
    public synchronized String nextInventoryTaskNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("INV", currentDate, inventoryTaskMapper.selectList(
            Wrappers.<InventoryTask>lambdaQuery()
                .select(InventoryTask::getTaskNo)
                .likeRight(InventoryTask::getTaskNo, datePrefix("INV", currentDate))
        ).stream().map(InventoryTask::getTaskNo).toList());
    }

    @Override
    public synchronized String nextRepairTaskNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("REP", currentDate, repairTaskMapper.selectList(
            Wrappers.<RepairTask>lambdaQuery()
                .select(RepairTask::getTaskNo)
                .likeRight(RepairTask::getTaskNo, datePrefix("REP", currentDate))
        ).stream().map(RepairTask::getTaskNo).toList());
    }

    @Override
    public synchronized String nextRepairPlanNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("PLAN", currentDate, repairPlanMapper.selectList(
            Wrappers.<RepairPlan>lambdaQuery()
                .select(RepairPlan::getPlanNo)
                .likeRight(RepairPlan::getPlanNo, datePrefix("PLAN", currentDate))
        ).stream().map(RepairPlan::getPlanNo).toList());
    }

    @Override
    public synchronized String nextRepairLogNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("LOG", currentDate, repairLogMapper.selectList(
            Wrappers.<RepairLog>lambdaQuery()
                .select(RepairLog::getLogNo)
                .likeRight(RepairLog::getLogNo, datePrefix("LOG", currentDate))
        ).stream().map(RepairLog::getLogNo).toList());
    }

    @Override
    public synchronized String nextRepairAcceptanceNo() {
        LocalDate currentDate = currentDate();
        return buildDateSerialNo("ACC", currentDate, repairAcceptanceMapper.selectList(
            Wrappers.<RepairAcceptance>lambdaQuery()
                .select(RepairAcceptance::getAcceptanceNo)
                .likeRight(RepairAcceptance::getAcceptanceNo, datePrefix("ACC", currentDate))
        ).stream().map(RepairAcceptance::getAcceptanceNo).toList());
    }

    @Override
    public synchronized String nextRelicCategoryValue() {
        int max = sysDictItemMapper.selectList(
                Wrappers.<SysDictItem>lambdaQuery()
                    .eq(SysDictItem::getDictTypeCode, "relic_category")
                    .likeRight(SysDictItem::getItemValue, "CATEGORY_")
            ).stream()
            .map(SysDictItem::getItemValue)
            .mapToInt(this::parseCategorySeq)
            .max()
            .orElse(0);
        return String.format("CATEGORY_%03d", max + 1);
    }

    @Override
    public synchronized String nextRelicMaterialValue() {
        int max = sysDictItemMapper.selectList(
                Wrappers.<SysDictItem>lambdaQuery()
                    .eq(SysDictItem::getDictTypeCode, "relic_material")
                    .likeRight(SysDictItem::getItemValue, "MATERIAL_")
            ).stream()
            .map(SysDictItem::getItemValue)
            .mapToInt(this::parseMaterialSeq)
            .max()
            .orElse(0);
        return String.format("MATERIAL_%03d", max + 1);
    }

    private LocalDate currentDate() {
        return LocalDate.now();
    }

    private String datePrefix(String prefix, LocalDate currentDate) {
        return prefix + "-" + currentDate.format(DATE_SEGMENT_FORMATTER);
    }

    private String buildDateSerialNo(String prefix, LocalDate currentDate, List<String> existingNos) {
        int max = existingNos.stream()
            .mapToInt(code -> parseSerial(prefix, currentDate, code))
            .max()
            .orElse(0);
        return String.format("%s-%s-%03d", prefix, currentDate.format(DATE_SEGMENT_FORMATTER), max + 1);
    }

    private int parseSerial(String prefix, LocalDate currentDate, String code) {
        if (code == null) {
            return 0;
        }
        Matcher dateMatcher = DATE_SERIAL_PATTERN.matcher(code);
        if (dateMatcher.matches()) {
            String dateSegment = currentDate.format(DATE_SEGMENT_FORMATTER);
            if (prefix.equals(dateMatcher.group(1)) && dateSegment.equals(dateMatcher.group(2))) {
                return Integer.parseInt(dateMatcher.group(3));
            }
        }
        return 0;
    }

    private int parseCategorySeq(String code) {
        if (code == null) {
            return 0;
        }
        Matcher matcher = CATEGORY_PATTERN.matcher(code);
        if (!matcher.matches()) {
            return 0;
        }
        return Integer.parseInt(matcher.group(1));
    }

    private int parseMaterialSeq(String code) {
        if (code == null) {
            return 0;
        }
        Matcher matcher = MATERIAL_PATTERN.matcher(code);
        if (!matcher.matches()) {
            return 0;
        }
        return Integer.parseInt(matcher.group(1));
    }
}

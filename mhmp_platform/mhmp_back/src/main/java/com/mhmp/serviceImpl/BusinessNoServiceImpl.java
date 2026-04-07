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
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class BusinessNoServiceImpl implements BusinessNoService {

    private static final Pattern YEAR_SERIAL_PATTERN = Pattern.compile("^([A-Z]+)-(\\d{4})-(\\d{3,})$");
    private static final Pattern CATEGORY_PATTERN = Pattern.compile("^CATEGORY_(\\d{3,})$");
    private static final Pattern MATERIAL_PATTERN = Pattern.compile("^MATERIAL_(\\d{3,})$");

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
        int year = currentYear();
        return buildYearSerialNo("REL", year, relicMapper.selectList(
            Wrappers.<Relic>lambdaQuery()
                .select(Relic::getRelicNo)
                .likeRight(Relic::getRelicNo, yearPrefix("REL", year))
        ).stream().map(Relic::getRelicNo).toList());
    }

    @Override
    public synchronized String nextInboundOrderNo() {
        int year = currentYear();
        return buildYearSerialNo("IN", year, relicInboundOrderMapper.selectList(
            Wrappers.<RelicInboundOrder>lambdaQuery()
                .select(RelicInboundOrder::getOrderNo)
                .likeRight(RelicInboundOrder::getOrderNo, yearPrefix("IN", year))
        ).stream().map(RelicInboundOrder::getOrderNo).toList());
    }

    @Override
    public synchronized String nextInboundBatchNo() {
        int year = currentYear();
        return buildYearSerialNo("BATCH", year, relicInboundOrderMapper.selectList(
            Wrappers.<RelicInboundOrder>lambdaQuery()
                .select(RelicInboundOrder::getBatchNo)
                .likeRight(RelicInboundOrder::getBatchNo, yearPrefix("BATCH", year))
        ).stream().map(RelicInboundOrder::getBatchNo).toList());
    }

    @Override
    public synchronized String nextOutboundOrderNo() {
        int year = currentYear();
        return buildYearSerialNo("OUT", year, relicOutboundOrderMapper.selectList(
            Wrappers.<RelicOutboundOrder>lambdaQuery()
                .select(RelicOutboundOrder::getOrderNo)
                .likeRight(RelicOutboundOrder::getOrderNo, yearPrefix("OUT", year))
        ).stream().map(RelicOutboundOrder::getOrderNo).toList());
    }

    @Override
    public synchronized String nextInventoryTaskNo() {
        int year = currentYear();
        return buildYearSerialNo("INV", year, inventoryTaskMapper.selectList(
            Wrappers.<InventoryTask>lambdaQuery()
                .select(InventoryTask::getTaskNo)
                .likeRight(InventoryTask::getTaskNo, yearPrefix("INV", year))
        ).stream().map(InventoryTask::getTaskNo).toList());
    }

    @Override
    public synchronized String nextRepairTaskNo() {
        int year = currentYear();
        return buildYearSerialNo("REP", year, repairTaskMapper.selectList(
            Wrappers.<RepairTask>lambdaQuery()
                .select(RepairTask::getTaskNo)
                .likeRight(RepairTask::getTaskNo, yearPrefix("REP", year))
        ).stream().map(RepairTask::getTaskNo).toList());
    }

    @Override
    public synchronized String nextRepairPlanNo() {
        int year = currentYear();
        return buildYearSerialNo("PLAN", year, repairPlanMapper.selectList(
            Wrappers.<RepairPlan>lambdaQuery()
                .select(RepairPlan::getPlanNo)
                .likeRight(RepairPlan::getPlanNo, yearPrefix("PLAN", year))
        ).stream().map(RepairPlan::getPlanNo).toList());
    }

    @Override
    public synchronized String nextRepairLogNo() {
        int year = currentYear();
        return buildYearSerialNo("LOG", year, repairLogMapper.selectList(
            Wrappers.<RepairLog>lambdaQuery()
                .select(RepairLog::getLogNo)
                .likeRight(RepairLog::getLogNo, yearPrefix("LOG", year))
        ).stream().map(RepairLog::getLogNo).toList());
    }

    @Override
    public synchronized String nextRepairAcceptanceNo() {
        int year = currentYear();
        return buildYearSerialNo("ACC", year, repairAcceptanceMapper.selectList(
            Wrappers.<RepairAcceptance>lambdaQuery()
                .select(RepairAcceptance::getAcceptanceNo)
                .likeRight(RepairAcceptance::getAcceptanceNo, yearPrefix("ACC", year))
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

    private int currentYear() {
        return LocalDate.now().getYear();
    }

    private String yearPrefix(String prefix, int year) {
        return prefix + "-" + year + "-";
    }

    private String buildYearSerialNo(String prefix, int year, List<String> existingNos) {
        int max = existingNos.stream()
            .mapToInt(code -> parseYearSerial(prefix, year, code))
            .max()
            .orElse(0);
        return String.format("%s-%d-%03d", prefix, year, max + 1);
    }

    private int parseYearSerial(String prefix, int year, String code) {
        if (code == null) {
            return 0;
        }
        Matcher matcher = YEAR_SERIAL_PATTERN.matcher(code);
        if (!matcher.matches()) {
            return 0;
        }
        if (!prefix.equals(matcher.group(1)) || year != Integer.parseInt(matcher.group(2))) {
            return 0;
        }
        return Integer.parseInt(matcher.group(3));
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

package com.mhmp.config;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.entity.BaseEntity;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.entity.RepairAcceptance;
import com.mhmp.entity.RepairLog;
import com.mhmp.entity.RepairPlan;
import com.mhmp.entity.RepairTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicAttachment;
import com.mhmp.entity.RelicInboundDetail;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.entity.RelicOutboundDetail;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.entity.SysDictItem;
import com.mhmp.entity.SysDictType;
import com.mhmp.entity.SysUser;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairPlanMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicAttachmentMapper;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.SysDictItemMapper;
import com.mhmp.mapper.SysDictTypeMapper;
import com.mhmp.mapper.SysUserMapper;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
@ConditionalOnProperty(prefix = "mhmp.startup", name = "init-enabled", havingValue = "true")
@Order(1)
public class DemoDataInitializer implements ApplicationRunner {

    private static final String PLACEHOLDER_PNG_BASE64 =
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO2Z2y8AAAAASUVORK5CYII=";
    private static final Pattern DATE_SERIAL_PATTERN = Pattern.compile("^([A-Z]+)-(\\d{8})-(\\d{3,})$");
    private static final Pattern YEAR_SERIAL_PATTERN = Pattern.compile("^([A-Z]+)-(\\d{4})-(\\d{3,})$");
    private static final DateTimeFormatter DATE_SEGMENT_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");
    private static final LocalDateTime DEMO_BASE_TIME = LocalDateTime.of(2026, 4, 8, 10, 0);

    private final SysUserMapper sysUserMapper;
    private final SysDictTypeMapper sysDictTypeMapper;
    private final SysDictItemMapper sysDictItemMapper;
    private final RelicMapper relicMapper;
    private final RelicAttachmentMapper relicAttachmentMapper;
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
    private final FileStorageProperties fileStorageProperties;

    public DemoDataInitializer(SysUserMapper sysUserMapper,
                               SysDictTypeMapper sysDictTypeMapper,
                               SysDictItemMapper sysDictItemMapper,
                               RelicMapper relicMapper,
                               RelicAttachmentMapper relicAttachmentMapper,
                               RelicInboundOrderMapper relicInboundOrderMapper,
                               RelicInboundDetailMapper relicInboundDetailMapper,
                               RelicOutboundOrderMapper relicOutboundOrderMapper,
                               RelicOutboundDetailMapper relicOutboundDetailMapper,
                               InventoryTaskMapper inventoryTaskMapper,
                               InventoryTaskDetailMapper inventoryTaskDetailMapper,
                               RepairTaskMapper repairTaskMapper,
                               RepairPlanMapper repairPlanMapper,
                               RepairLogMapper repairLogMapper,
                               RepairAcceptanceMapper repairAcceptanceMapper,
                               FileStorageProperties fileStorageProperties) {
        this.sysUserMapper = sysUserMapper;
        this.sysDictTypeMapper = sysDictTypeMapper;
        this.sysDictItemMapper = sysDictItemMapper;
        this.relicMapper = relicMapper;
        this.relicAttachmentMapper = relicAttachmentMapper;
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
        this.fileStorageProperties = fileStorageProperties;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void run(ApplicationArguments args) throws Exception {
        List<SysUser> users = sysUserMapper.selectList(
            Wrappers.<SysUser>lambdaQuery()
                .eq(SysUser::getStatus, "ENABLED")
                .orderByAsc(SysUser::getId)
        );
        Long primaryUserId = users.isEmpty() ? null : users.get(0).getId();
        Long secondaryUserId = users.size() > 1 ? users.get(1).getId() : primaryUserId;
        Long tertiaryUserId = users.size() > 2 ? users.get(2).getId() : secondaryUserId;

        DemoFileBundle demoFiles = prepareDemoFiles();
        ensureDictData(primaryUserId);
        normalizeLegacyRelicData(primaryUserId);
        long relicCount = relicMapper.selectCount(null);
        if (relicCount >= 10) {
            ensureInboundPendingSampleRelic(primaryUserId, demoFiles);
            ensureToBeInboundSampleRelic(primaryUserId, demoFiles);
            ensurePendingInboundSampleOrder(primaryUserId);
            return;
        }
        Map<String, Relic> relics = ensureRelicData(primaryUserId, demoFiles);
        ensureRelicAttachments(relics, primaryUserId, demoFiles);
        ensureInboundData(relics, primaryUserId);
        ensureOutboundData(relics, primaryUserId, secondaryUserId);
        ensureInventoryData(relics, primaryUserId);
        ensureRepairData(relics, primaryUserId, secondaryUserId, tertiaryUserId, demoFiles);
    }

    private void ensureDictData(Long operatorId) {
        ensureDictType("relic_category", "文物类别", operatorId);
        ensureDictType("relic_material", "文物材质", operatorId);
        ensureDictType("relic_status", "文物状态", operatorId);
        ensureDictType("storage_location", "藏品库位", operatorId);
        ensureDictType("preservation_status", "保存状态", operatorId);
        ensureDictType("outbound_status", "出库状态", operatorId);

        ensureDictItem("relic_category", "青铜器", "BRONZE", 1, operatorId);
        ensureDictItem("relic_category", "陶瓷器", "CERAMIC", 2, operatorId);
        ensureDictItem("relic_category", "书画", "PAINTING", 3, operatorId);
        ensureDictItem("relic_category", "石刻造像", "STONE", 4, operatorId);
        ensureDictItem("relic_category", "玉器", "JADE", 5, operatorId);
        ensureDictItem("relic_category", "漆器", "LACQUER", 6, operatorId);
        ensureDictItem("relic_category", "陶俑", "POTTERY", 7, operatorId);
        ensureDictItem("relic_category", "金器", "GOLD", 8, operatorId);
        ensureDictItem("relic_category", "简牍", "BAMBOO", 9, operatorId);
        ensureDictItem("relic_category", "木雕", "WOOD", 10, operatorId);

        ensureDictItem("relic_material", "青铜", "BRONZE", 1, operatorId);
        ensureDictItem("relic_material", "瓷", "PORCELAIN", 2, operatorId);
        ensureDictItem("relic_material", "绢本", "SILK", 3, operatorId);
        ensureDictItem("relic_material", "石材", "STONE", 4, operatorId);
        ensureDictItem("relic_material", "玉石", "JADE", 5, operatorId);
        ensureDictItem("relic_material", "漆木", "LACQUER_WOOD", 6, operatorId);
        ensureDictItem("relic_material", "陶土", "CLAY", 7, operatorId);
        ensureDictItem("relic_material", "金", "GOLD", 8, operatorId);
        ensureDictItem("relic_material", "竹木", "BAMBOO_WOOD", 9, operatorId);

        syncDictItems("relic_status", operatorId, new String[][]{
            {"待入库", "TO_BE_INBOUND"},
            {"在库", "IN_STOCK"},
            {"入库待审批", "INBOUND_PENDING"},
            {"出库待审批", "OUTBOUND_PENDING"},
            {"已出库", "OUT_STOCK"},
            {"修复中", "IN_REPAIR"}
        });

        ensureDictItem("storage_location", "一号综合库", "LOC_A", 1, operatorId);
        ensureDictItem("storage_location", "二号恒温库", "LOC_B", 2, operatorId);
        ensureDictItem("storage_location", "三号精品库", "LOC_C", 3, operatorId);
        ensureDictItem("storage_location", "文保修复库", "LOC_D", 4, operatorId);
        ensureDictItem("storage_location", "珍品专柜", "LOC_VIP", 5, operatorId);

        syncDictItems("preservation_status", operatorId, new String[][]{
            {"完整", "COMPLETE"},
            {"基本完整", "BASIC_COMPLETE"},
            {"残缺", "INCOMPLETE"},
            {"严重残缺", "SEVERE_INCOMPLETE"},
            {"残碎", "FRAGMENTED"},
            {"物理机械损伤", "PHYSICAL_DAMAGE"},
            {"化学劣化", "CHEMICAL_DEGRADATION"},
            {"生物病害", "BIOLOGICAL_DISEASE"}
        });

        ensureDictItem("outbound_status", "待审批", "PENDING", 1, operatorId);
        ensureDictItem("outbound_status", "已审批", "APPROVED", 2, operatorId);
        ensureDictItem("outbound_status", "已归还", "RETURNED", 3, operatorId);
        ensureDictItem("outbound_status", "已驳回", "REJECTED", 4, operatorId);
    }

    private void normalizeLegacyRelicData(Long operatorId) {
        List<Relic> relics = relicMapper.selectList(null);
        for (Relic relic : relics) {
            String normalizedCurrentStatus = normalizeCurrentStatus(relic.getCurrentStatus());
            String normalizedPreservationStatus = normalizePreservationStatus(relic.getPreservationStatusCode(), normalizedCurrentStatus);
            if (normalizedCurrentStatus.equals(relic.getCurrentStatus())
                && normalizedPreservationStatus.equals(relic.getPreservationStatusCode())) {
                continue;
            }
            relic.setCurrentStatus(normalizedCurrentStatus);
            relic.setPreservationStatusCode(normalizedPreservationStatus);
            relic.setUpdateBy(operatorId);
            relicMapper.updateById(relic);
        }
    }

    private void ensureInboundPendingSampleRelic(Long operatorId, DemoFileBundle demoFiles) {
        upsertRelic("REL-2026-013", "民国木胎漆盘", "LACQUER", "LACQUER_WOOD", "民国", "临时征集",
            "LOC_D", "BASIC_COMPLETE", "INBOUND_PENDING", "一般", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于模拟文物入库待审批状态。", operatorId, demoNow().minusDays(12));
    }

    private void ensureToBeInboundSampleRelic(Long operatorId, DemoFileBundle demoFiles) {
        upsertRelic("REL-2026-015", "清代嵌螺钿木匣", "WOOD", "BAMBOO_WOOD", "清代", "新征集待交接",
            null, "BASIC_COMPLETE", "TO_BE_INBOUND", "一般", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于模拟新增建档后待入库、可发起入库的文物。", operatorId, demoNow().minusDays(5));
    }

    private void ensurePendingInboundSampleOrder(Long operatorId) {
        Relic relic = relicMapper.selectOne(
            Wrappers.<Relic>lambdaQuery()
                .eq(Relic::getName, "民国木胎漆盘")
                .last("LIMIT 1")
        );
        if (relic == null) {
            return;
        }
        LocalDateTime now = demoNow();
        upsertInboundOrder("IN-2026-003", "BATCH-2026-003", "馆际征集交接", "周敏", now.minusDays(11),
            1, "PENDING", "待审批演示入库单", operatorId);
        upsertInboundDetail("IN-2026-003", relic, 1, "待入库审批", operatorId, now.minusDays(11));
    }

    private String normalizeCurrentStatus(String currentStatus) {
        if (currentStatus == null || currentStatus.isBlank()) {
            return "IN_STOCK";
        }
        return switch (currentStatus) {
            case "TO_BE_INBOUND", "IN_STOCK", "INBOUND_PENDING", "OUTBOUND_PENDING", "OUT_STOCK", "IN_REPAIR" -> currentStatus;
            default -> currentStatus;
        };
    }

    private String normalizePreservationStatus(String preservationStatusCode, String currentStatus) {
        if (preservationStatusCode == null || preservationStatusCode.isBlank()) {
            return "IN_REPAIR".equals(currentStatus) ? "PHYSICAL_DAMAGE" : "COMPLETE";
        }
        return switch (preservationStatusCode) {
            case "COMPLETE", "BASIC_COMPLETE", "INCOMPLETE", "SEVERE_INCOMPLETE",
                "FRAGMENTED", "PHYSICAL_DAMAGE", "CHEMICAL_DEGRADATION", "BIOLOGICAL_DISEASE" -> preservationStatusCode;
            case "GOOD" -> "COMPLETE";
            case "DAMAGED" -> "INCOMPLETE";
            case "TO_BE_REPAIRED", "UNDER_REPAIR" -> "PHYSICAL_DAMAGE";
            case "SEVERE_DAMAGE" -> "SEVERE_INCOMPLETE";
            case "RESTORED" -> "BASIC_COMPLETE";
            case "FRAGILE" -> "BIOLOGICAL_DISEASE";
            default -> preservationStatusCode;
        };
    }

    private void syncDictItems(String dictTypeCode, Long operatorId, String[][] items) {
        Set<String> enabledValues = new HashSet<>();
        for (int index = 0; index < items.length; index++) {
            ensureDictItem(dictTypeCode, items[index][0], items[index][1], index + 1, operatorId);
            enabledValues.add(items[index][1]);
        }
        disableMissingDictItems(dictTypeCode, enabledValues, operatorId);
    }

    private void disableMissingDictItems(String dictTypeCode, Set<String> enabledValues, Long operatorId) {
        List<SysDictItem> dictItems = sysDictItemMapper.selectList(
            Wrappers.<SysDictItem>lambdaQuery()
                .eq(SysDictItem::getDictTypeCode, dictTypeCode)
                .eq(SysDictItem::getStatus, "ENABLED")
        );
        for (SysDictItem dictItem : dictItems) {
            if (enabledValues.contains(dictItem.getItemValue())) {
                continue;
            }
            dictItem.setStatus("DISABLED");
            dictItem.setUpdateBy(operatorId);
            sysDictItemMapper.updateById(dictItem);
        }
    }

    private Map<String, Relic> ensureRelicData(Long operatorId, DemoFileBundle demoFiles) {
        Map<String, Relic> relics = new LinkedHashMap<>();
        relics.put("REL-2026-001", upsertRelic("REL-2026-001", "西周饕餮纹青铜鼎", "BRONZE", "BRONZE", "西周", "考古发掘",
            "LOC_A", "COMPLETE", "IN_STOCK", "一级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "馆藏代表性青铜器，适合答辩展示完整档案流程。", operatorId, demoNow().minusMonths(8)));
        relics.put("REL-2026-002", upsertRelic("REL-2026-002", "宋代青釉刻花碗", "CERAMIC", "PORCELAIN", "宋代", "社会征集",
            "LOC_A", "INCOMPLETE", "IN_STOCK", "二级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "口沿存在细裂，需要进入待修复清单。", operatorId, demoNow().minusMonths(6)));
        relics.put("REL-2026-003", upsertRelic("REL-2026-003", "明代绢本山水轴", "PAINTING", "SILK", "明代", "旧藏移交",
            "LOC_B", "PHYSICAL_DAMAGE", "IN_REPAIR", "一级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "正在进行修复过程跟踪。", operatorId, demoNow().minusMonths(5)));
        relics.put("REL-2026-004", upsertRelic("REL-2026-004", "北齐石佛立像", "STONE", "STONE", "北齐", "寺院征集",
            "LOC_C", "COMPLETE", "OUT_STOCK", "一级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于模拟已审批未归还的出库状态。", operatorId, demoNow().minusMonths(10)));
        relics.put("REL-2026-005", upsertRelic("REL-2026-005", "汉代白玉璧", "JADE", "JADE", "汉代", "移交入藏",
            "LOC_C", "BASIC_COMPLETE", "OUTBOUND_PENDING", "一级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于模拟待审批出库申请。", operatorId, demoNow().minusMonths(4)));
        relics.put("REL-2026-006", upsertRelic("REL-2026-006", "清代描金漆盒", "LACQUER", "LACQUER_WOOD", "清代", "社会捐赠",
            "LOC_B", "CHEMICAL_DEGRADATION", "IN_STOCK", "二级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "漆层脱落，待研究员申请修复。", operatorId, demoNow().minusMonths(3)));
        relics.put("REL-2026-007", upsertRelic("REL-2026-007", "唐代彩绘陶马", "POTTERY", "CLAY", "唐代", "考古发掘",
            "LOC_D", "BIOLOGICAL_DISEASE", "IN_STOCK", "二级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于模拟已归还后的在库文物。", operatorId, demoNow().minusMonths(7)));
        relics.put("REL-2026-008", upsertRelic("REL-2026-008", "金代累丝发冠", "GOLD", "GOLD", "金代", "旧藏整理",
            "LOC_VIP", "COMPLETE", "IN_STOCK", "一级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于模拟修复申请被驳回与出库申请被驳回。", operatorId, demoNow().minusMonths(2)));
        relics.put("REL-2026-009", upsertRelic("REL-2026-009", "战国竹简", "BAMBOO", "BAMBOO_WOOD", "战国", "考古发掘",
            "LOC_A", "BASIC_COMPLETE", "IN_STOCK", "一级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于展示已修复页面与多次修复历史。", operatorId, demoNow().minusMonths(9)));
        relics.put("REL-2026-010", upsertRelic("REL-2026-010", "清雍正粉彩瓶", "CERAMIC", "PORCELAIN", "清代", "社会征集",
            "LOC_C", "INCOMPLETE", "IN_STOCK", "一级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "已通过修复审批，等待研究员正式开展修复。", operatorId, demoNow().minusMonths(4)));
        relics.put("REL-2026-011", upsertRelic("REL-2026-011", "汉代铜镜", "BRONZE", "BRONZE", "汉代", "旧藏移交",
            "LOC_B", "SEVERE_INCOMPLETE", "IN_STOCK", "二级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "严重病害文物，已有待审批修复申请。", operatorId, demoNow().minusMonths(5)));
        relics.put("REL-2026-012", upsertRelic("REL-2026-012", "明代木雕佛像", "WOOD", "BAMBOO_WOOD", "明代", "寺院征集",
            "LOC_D", "FRAGMENTED", "IN_REPAIR", "一级", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "修复流程已完成，等待验收。", operatorId, demoNow().minusMonths(6)));
        relics.put("REL-2026-013", upsertRelic("REL-2026-013", "民国木胎漆盘", "LACQUER", "LACQUER_WOOD", "民国", "临时征集",
            "LOC_D", "BASIC_COMPLETE", "INBOUND_PENDING", "一般", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于模拟文物入库待审批状态。", operatorId, demoNow().minusDays(12)));
        relics.put("REL-2026-015", upsertRelic("REL-2026-015", "清代嵌螺钿木匣", "WOOD", "BAMBOO_WOOD", "清代", "新征集待交接",
            null, "BASIC_COMPLETE", "TO_BE_INBOUND", "一般", demoFiles.imageUrl(), demoFiles.reportUrl(),
            "用于模拟新增建档后待入库、可发起入库的文物。", operatorId, demoNow().minusDays(5)));
        return relics;
    }

    private void ensureRelicAttachments(Map<String, Relic> relics, Long operatorId, DemoFileBundle demoFiles) {
        upsertAttachment(relics.get("REL-2026-001").getId(), "DOCUMENT", "青铜鼎测绘记录.txt", demoFiles.attachmentUrl(),
            256L, "txt", "基础档案附件", operatorId, demoNow().minusMonths(7));
        upsertAttachment(relics.get("REL-2026-006").getId(), "DOCUMENT", "漆盒病害说明.txt", demoFiles.attachmentUrl(),
            256L, "txt", "待修复病害说明", operatorId, demoNow().minusMonths(2));
        upsertAttachment(relics.get("REL-2026-009").getId(), "DOCUMENT", "竹简修复总结.txt", demoFiles.reportUrl(),
            512L, "txt", "已修复总结材料", operatorId, demoNow().minusMonths(1));
    }

    private void ensureInboundData(Map<String, Relic> relics, Long operatorId) {
        LocalDateTime now = demoNow();
        upsertInboundOrder("IN-2026-001", "BATCH-2026-001", "考古工地移交", "王倩", now.minusMonths(6), 4, "COMPLETED", "第一批演示入库单", operatorId);
        upsertInboundDetail("IN-2026-001", relics.get("REL-2026-001"), 1, "入库验收通过", operatorId, now.minusMonths(6));
        upsertInboundDetail("IN-2026-001", relics.get("REL-2026-002"), 1, "入库验收通过", operatorId, now.minusMonths(6));
        upsertInboundDetail("IN-2026-001", relics.get("REL-2026-006"), 1, "入库验收通过", operatorId, now.minusMonths(6));
        upsertInboundDetail("IN-2026-001", relics.get("REL-2026-011"), 1, "入库验收通过", operatorId, now.minusMonths(6));

        upsertInboundOrder("IN-2026-002", "BATCH-2026-002", "社会征集", "李静", now.minusMonths(4), 4, "COMPLETED", "第二批演示入库单", operatorId);
        upsertInboundDetail("IN-2026-002", relics.get("REL-2026-007"), 1, "入库验收通过", operatorId, now.minusMonths(4));
        upsertInboundDetail("IN-2026-002", relics.get("REL-2026-008"), 1, "入库验收通过", operatorId, now.minusMonths(4));
        upsertInboundDetail("IN-2026-002", relics.get("REL-2026-009"), 1, "入库验收通过", operatorId, now.minusMonths(4));
        upsertInboundDetail("IN-2026-002", relics.get("REL-2026-010"), 1, "入库验收通过", operatorId, now.minusMonths(4));

        upsertInboundOrder("IN-2026-003", "BATCH-2026-003", "馆际征集交接", "周敏", now.minusDays(11), 1, "PENDING", "待审批演示入库单", operatorId);
        upsertInboundDetail("IN-2026-003", relics.get("REL-2026-013"), 1, "待入库审批", operatorId, now.minusDays(11));
    }

    private void ensureOutboundData(Map<String, Relic> relics, Long applyUserId, Long approveUserId) {
        LocalDateTime now = demoNow();
        upsertOutboundOrder("OUT-2026-001", "专题展借展", "省博临展厅", "陈昊", now.minusDays(8),
            applyUserId, "PENDING", null, null, "等待审批中", null, "待审批出库申请", applyUserId);
        upsertOutboundDetail("OUT-2026-001", relics.get("REL-2026-005"), 1, "IN_STOCK", "待审批快照", applyUserId, now.minusDays(8));

        upsertOutboundOrder("OUT-2026-002", "外馆联合展", "历史文化展区", "赵楠", now.minusDays(22),
            applyUserId, "APPROVED", approveUserId, now.minusDays(21), "同意出库", null, "已审批未归还", applyUserId);
        upsertOutboundDetail("OUT-2026-002", relics.get("REL-2026-004"), 1, "IN_STOCK", "审批时在库", applyUserId, now.minusDays(22));

        upsertOutboundOrder("OUT-2026-003", "馆际交流", "市博修复中心", "孙洁", now.minusDays(45),
            applyUserId, "RETURNED", approveUserId, now.minusDays(44), "借展完成", now.minusDays(30), "已归还", applyUserId);
        upsertOutboundDetail("OUT-2026-003", relics.get("REL-2026-007"), 1, "IN_STOCK", "已归还示例", applyUserId, now.minusDays(45));

        upsertOutboundOrder("OUT-2026-004", "学术研究借阅", "高校实验室", "周洋", now.minusDays(15),
            applyUserId, "REJECTED", approveUserId, now.minusDays(14), "文物等级较高，暂不外借", null, "已驳回", applyUserId);
        upsertOutboundDetail("OUT-2026-004", relics.get("REL-2026-008"), 1, "IN_STOCK", "驳回示例", applyUserId, now.minusDays(15));
    }

    private void ensureInventoryData(Map<String, Relic> relics, Long operatorId) {
        LocalDateTime now = demoNow();
        upsertInventoryTask("INV-2026-001", "一号综合库季度盘点", "LOC_A", "COMPLETED",
            now.minusDays(26), now.minusDays(25), "王敏", "已完成盘点提交", operatorId);
        upsertInventoryTaskDetail("INV-2026-001", relics.get("REL-2026-001"), 1, 1, 0, "", "NORMAL", operatorId, now.minusDays(25));
        upsertInventoryTaskDetail("INV-2026-001", relics.get("REL-2026-002"), 1, 1, 0, "口沿裂痕已单独记录", "NORMAL", operatorId, now.minusDays(25));
        upsertInventoryTaskDetail("INV-2026-001", relics.get("REL-2026-009"), 1, 1, 0, "修复后状态正常", "NORMAL", operatorId, now.minusDays(25));

        upsertInventoryTask("INV-2026-002", "二号恒温库专项盘点", "LOC_B", "IN_PROGRESS",
            now.minusDays(6), null, "李倩", "正在核对重点病害文物", operatorId);
        upsertInventoryTaskDetail("INV-2026-002", relics.get("REL-2026-003"), 1, 1, 0, "修复中已现场核实", "CHECKED", operatorId, now.minusDays(5));
        upsertInventoryTaskDetail("INV-2026-002", relics.get("REL-2026-006"), 1, null, null, "", "PENDING", operatorId, now.minusDays(5));
        upsertInventoryTaskDetail("INV-2026-002", relics.get("REL-2026-011"), 1, 0, -1, "库位封存待复核", "DIFF_FOUND", operatorId, now.minusDays(5));

        upsertInventoryTask("INV-2026-003", "三号精品库月度盘点", "LOC_C", "CREATED",
            now.minusDays(1), null, "陈刚", "新建待执行任务", operatorId);
        upsertInventoryTaskDetail("INV-2026-003", relics.get("REL-2026-010"), 1, null, null, "", "PENDING", operatorId, now.minusDays(1));
    }

    private void ensureRepairData(Map<String, Relic> relics,
                                  Long primaryUserId,
                                  Long secondaryUserId,
                                  Long tertiaryUserId,
                                  DemoFileBundle demoFiles) {
        LocalDateTime now = demoNow();

        RepairTask acceptedRecent = upsertRepairTask("REP-2026-001", relics.get("REL-2026-009"), primaryUserId,
            "纸基脆弱、局部断裂，需要系统修复", "ACCEPTED", "SUCCESS", now.minusDays(120), secondaryUserId,
            now.minusDays(119), "同意修复", now.minusDays(118), now.minusDays(110), "最新一次修复已验收");
        upsertRepairPlan("PLAN-2026-001", acceptedRecent.getId(), "竹简分层加固方案", "先清洁后加固，再进行局部拼接",
            "无酸纸、日式浆糊、棉签", "注意控制湿度变化", "APPROVED", "研究员A", "文保主管", now.minusDays(119), "方案通过", primaryUserId);
        upsertRepairLog("LOG-2026-001", acceptedRecent.getId(), "病害复核", "完成病害点位复核与分级记录",
            "显微镜、记录卡", "研究员A", now.minusDays(118), "IN_PROGRESS", "进入正式修复前复核", primaryUserId);
        upsertRepairLog("LOG-2026-002", acceptedRecent.getId(), "拼接加固", "完成主要断裂部位拼接加固",
            "无酸纸、浆糊", "研究员A", now.minusDays(112), "COMPLETED", "可提交验收", primaryUserId);
        upsertRepairAcceptance("ACC-2026-001", acceptedRecent.getId(), "PASS", tertiaryUserId,
            now.minusDays(109), "修复质量符合预期", "入库后继续观察温湿度", primaryUserId);
        upsertAttachment(relics.get("REL-2026-009").getId(), "REPAIR_IMAGE", "竹简修复前后对比.png", demoFiles.repairImageUrl(),
            128L, "png", "repairTaskId=" + acceptedRecent.getId() + ";step=完成验收;remark=修复成果照片", primaryUserId, now.minusDays(109));

        RepairTask acceptedOld = upsertRepairTask("REP-2025-001", relics.get("REL-2026-009"), secondaryUserId,
            "早年封装材料老化，需要重新整理", "ACCEPTED", "SUCCESS", now.minusDays(260), tertiaryUserId,
            now.minusDays(259), "同意实施", now.minusDays(258), now.minusDays(250), "历史修复任务");
        upsertRepairPlan("PLAN-2025-001", acceptedOld.getId(), "旧封装材料更换方案", "拆除旧封装，重新建立支撑材料",
            "支撑板、无酸纸", "避免二次折损", "APPROVED", "研究员B", "文保主管", now.minusDays(259), "历史方案", primaryUserId);
        upsertRepairLog("LOG-2025-001", acceptedOld.getId(), "旧封装拆除", "拆除老化封装并建立临时支撑",
            "支撑板", "研究员B", now.minusDays(257), "COMPLETED", "历史任务日志", primaryUserId);
        upsertRepairAcceptance("ACC-2025-001", acceptedOld.getId(), "PASS", tertiaryUserId,
            now.minusDays(249), "历史任务验收通过", "转入稳定观察", primaryUserId);

        RepairTask inProgress = upsertRepairTask("REP-2026-002", relics.get("REL-2026-003"), primaryUserId,
            "画心起翘、边缘虫蛀，需要分阶段修复", "IN_PROGRESS", "UNACCEPTED", now.minusDays(14), secondaryUserId,
            now.minusDays(13), "同意尽快开展", now.minusDays(12), null, "研究员持续更新进度");
        upsertRepairPlan("PLAN-2026-002", inProgress.getId(), "绢本书画揭展修复方案", "先稳固颜料层，再进行托裱与边缘补配",
            "宣纸、绢料、明胶", "注意颜料层脱落风险", "APPROVED", "研究员A", "文保主管", now.minusDays(13), "重点关注颜料层", primaryUserId);
        upsertRepairLog("LOG-2026-003", inProgress.getId(), "颜料层加固", "完成颜料层边缘试样加固",
            "明胶、毛刷", "研究员A", now.minusDays(12), "IN_PROGRESS", "效果稳定", primaryUserId);
        upsertRepairLog("LOG-2026-004", inProgress.getId(), "局部揭展", "开始对折痕区域进行局部揭展",
            "镊子、宣纸", "研究员A", now.minusDays(10), "IN_PROGRESS", "仍在处理中", primaryUserId);
        upsertAttachment(relics.get("REL-2026-003").getId(), "REPAIR_IMAGE", "书画修复过程照片.png", demoFiles.repairImageUrl(),
            128L, "png", "repairTaskId=" + inProgress.getId() + ";step=局部揭展;remark=修复过程图片", primaryUserId, now.minusDays(10));
        upsertAttachment(relics.get("REL-2026-003").getId(), "REPAIR_FILE", "书画修复记录.txt", demoFiles.repairFileUrl(),
            256L, "txt", "repairTaskId=" + inProgress.getId() + ";step=局部揭展;remark=修复过程附件", primaryUserId, now.minusDays(10));

        RepairTask approved = upsertRepairTask("REP-2026-003", relics.get("REL-2026-010"), primaryUserId,
            "口沿冲线明显，需要先制定补配方案", "APPROVED", "UNACCEPTED", now.minusDays(6), secondaryUserId,
            now.minusDays(5), "方案已通过，等待排期", null, null, "已审批待开工");
        upsertRepairPlan("PLAN-2026-003", approved.getId(), "粉彩瓶口沿补配方案", "先做材质测试，再进行缺口补配",
            "矿物颜料、石膏", "需控制色差", "APPROVED", "研究员A", "文保主管", now.minusDays(5), "等待研究员排期", primaryUserId);

        RepairTask completed = upsertRepairTask("REP-2026-004", relics.get("REL-2026-012"), primaryUserId,
            "木胎开裂，需完成结构加固后验收", "COMPLETED", "WAITING", now.minusDays(18), secondaryUserId,
            now.minusDays(17), "同意实施", now.minusDays(16), now.minusDays(3), "已提交验收");
        upsertRepairPlan("PLAN-2026-004", completed.getId(), "木雕佛像结构加固方案", "先除尘，再进行裂隙填补和结构加固",
            "木粉、胶料、夹具", "避免过度加压", "APPROVED", "研究员A", "文保主管", now.minusDays(17), "按步骤推进", primaryUserId);
        upsertRepairLog("LOG-2026-005", completed.getId(), "裂隙处理", "完成主裂隙清理与填补", "木粉、胶料",
            "研究员A", now.minusDays(15), "IN_PROGRESS", "结构稳定", primaryUserId);
        upsertRepairLog("LOG-2026-006", completed.getId(), "结构加固", "完成结构加固并整理表面", "夹具、保护纸",
            "研究员A", now.minusDays(3), "COMPLETED", "等待验收", primaryUserId);
        upsertAttachment(relics.get("REL-2026-012").getId(), "REPAIR_FILE", "木雕佛像修复完成说明.txt", demoFiles.repairFileUrl(),
            256L, "txt", "repairTaskId=" + completed.getId() + ";step=结构加固;remark=待验收资料", primaryUserId, now.minusDays(3));

        upsertRepairTask("REP-2026-005", relics.get("REL-2026-011"), secondaryUserId,
            "镜面锈蚀严重，申请优先修复", "APPLIED", "UNACCEPTED", now.minusDays(2), null,
            null, null, null, null, "等待主管审批");

        upsertRepairTask("REP-2026-006", relics.get("REL-2026-008"), secondaryUserId,
            "金丝局部松动，希望做紧急加固", "REJECTED", "UNACCEPTED", now.minusDays(60), tertiaryUserId,
            now.minusDays(59), "先纳入年度计划，暂不单独立项", null, null, "示例驳回任务");
    }

    private SysDictType ensureDictType(String dictTypeCode, String dictName, Long operatorId) {
        SysDictType entity = sysDictTypeMapper.selectOne(
            Wrappers.<SysDictType>lambdaQuery()
                .eq(SysDictType::getDictTypeCode, dictTypeCode)
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new SysDictType();
        }
        entity.setDictTypeCode(dictTypeCode);
        entity.setDictName(dictName);
        entity.setStatus("ENABLED");
        entity.setRemark("Demo generated dictionary data");
        fillAuditFields(entity, operatorId, demoNow().minusDays(30), demoNow());
        if (entity.getId() == null) {
            sysDictTypeMapper.insert(entity);
        } else {
            sysDictTypeMapper.updateById(entity);
        }
        return entity;
    }

    private void ensureDictItem(String dictTypeCode, String itemLabel, String itemValue, int itemSort, Long operatorId) {
        SysDictItem entity = sysDictItemMapper.selectOne(
            Wrappers.<SysDictItem>lambdaQuery()
                .eq(SysDictItem::getDictTypeCode, dictTypeCode)
                .eq(SysDictItem::getItemValue, itemValue)
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new SysDictItem();
        }
        entity.setDictTypeCode(dictTypeCode);
        entity.setItemLabel(itemLabel);
        entity.setItemValue(itemValue);
        entity.setItemSort(itemSort);
        entity.setStatus("ENABLED");
        entity.setRemark("Demo generated dictionary item");
        fillAuditFields(entity, operatorId, demoNow().minusDays(30), demoNow());
        if (entity.getId() == null) {
            sysDictItemMapper.insert(entity);
        } else {
            sysDictItemMapper.updateById(entity);
        }
    }

    private Relic upsertRelic(String relicNo,
                              String name,
                              String categoryCode,
                              String materialCode,
                              String era,
                              String source,
                              String storageLocationCode,
                              String preservationStatusCode,
                              String currentStatus,
                              String protectionLevel,
                              String imageUrl,
                              String reportUrl,
                              String note,
                              Long operatorId,
                              LocalDateTime createTime) {
        String normalizedRelicNo = normalizeBusinessNo(relicNo, createTime);
        Relic relic = relicMapper.selectOne(
            Wrappers.<Relic>lambdaQuery()
                .and(wrapper -> wrapper.eq(Relic::getRelicNo, relicNo)
                    .or()
                    .eq(Relic::getRelicNo, normalizedRelicNo))
                .last("LIMIT 1")
        );
        if (relic != null) {
            boolean changed = false;
            String persistedRelicNo = resolvePersistedBusinessNo(relic.getRelicNo(), relicNo, createTime);
            if (!Objects.equals(relic.getRelicNo(), persistedRelicNo)) {
                relic.setRelicNo(persistedRelicNo);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getName()) && StringUtils.hasText(name)) {
                relic.setName(name);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getCategoryCode()) && StringUtils.hasText(categoryCode)) {
                relic.setCategoryCode(categoryCode);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getMaterialCode()) && StringUtils.hasText(materialCode)) {
                relic.setMaterialCode(materialCode);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getEra()) && StringUtils.hasText(era)) {
                relic.setEra(era);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getSource()) && StringUtils.hasText(source)) {
                relic.setSource(source);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getStorageLocationCode()) && StringUtils.hasText(storageLocationCode)) {
                relic.setStorageLocationCode(storageLocationCode);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getPreservationStatusCode()) && StringUtils.hasText(preservationStatusCode)) {
                relic.setPreservationStatusCode(preservationStatusCode);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getCurrentStatus()) && StringUtils.hasText(currentStatus)) {
                relic.setCurrentStatus(currentStatus);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getProtectionLevel()) && StringUtils.hasText(protectionLevel)) {
                relic.setProtectionLevel(protectionLevel);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getStorageCondition())) {
                relic.setStorageCondition("Constant temperature and humidity, quarterly inspection.");
                changed = true;
            }
            if (!StringUtils.hasText(relic.getAttentionNote())) {
                relic.setAttentionNote("Demo record for inbound, outbound, repair and inventory linkage.");
                changed = true;
            }
            if (!StringUtils.hasText(relic.getDescription())) {
                relic.setDescription(name + " demo record for museum business process simulation.");
                changed = true;
            }
            if (!StringUtils.hasText(relic.getNote()) && StringUtils.hasText(note)) {
                relic.setNote(note);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getImageUrl()) && StringUtils.hasText(imageUrl)) {
                relic.setImageUrl(imageUrl);
                changed = true;
            }
            if (!StringUtils.hasText(relic.getAppraisalReportUrl()) && StringUtils.hasText(reportUrl)) {
                relic.setAppraisalReportUrl(reportUrl);
                changed = true;
            }
            if (changed) {
                touchAuditFields(relic, operatorId, demoNow());
                relicMapper.updateById(relic);
            }
            return relic;
        }
        relic = new Relic();
        relic.setRelicNo(resolvePersistedBusinessNo(relic.getRelicNo(), relicNo, createTime));
        relic.setName(name);
        relic.setCategoryCode(categoryCode);
        relic.setMaterialCode(materialCode);
        relic.setEra(era);
        relic.setSource(source);
        relic.setStorageLocationCode(storageLocationCode);
        relic.setPreservationStatusCode(preservationStatusCode);
        relic.setCurrentStatus(currentStatus);
        relic.setProtectionLevel(protectionLevel);
        relic.setStorageCondition("Constant temperature and humidity, quarterly inspection.");
        relic.setAttentionNote("Demo record for inbound, outbound, repair and inventory linkage.");
        relic.setDescription(name + " demo record for museum business process simulation.");
        relic.setNote(note);
        relic.setImageUrl(imageUrl);
        relic.setAppraisalReportUrl(reportUrl);
        fillAuditFields(relic, operatorId, createTime, demoNow());
        if (relic.getId() == null) {
            relicMapper.insert(relic);
        } else {
            relicMapper.updateById(relic);
        }
        return relic;
    }

    private void upsertAttachment(Long relicId,
                                  String attachmentType,
                                  String fileName,
                                  String fileUrl,
                                  Long fileSize,
                                  String fileSuffix,
                                  String remark,
                                  Long operatorId,
                                  LocalDateTime createTime) {
        RelicAttachment entity = relicAttachmentMapper.selectOne(
            Wrappers.<RelicAttachment>lambdaQuery()
                .eq(RelicAttachment::getRelicId, relicId)
                .eq(RelicAttachment::getAttachmentType, attachmentType)
                .eq(RelicAttachment::getFileName, fileName)
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RelicAttachment();
        }
        entity.setRelicId(relicId);
        entity.setAttachmentType(attachmentType);
        entity.setFileName(fileName);
        entity.setFileUrl(fileUrl);
        entity.setFileSize(fileSize);
        entity.setFileSuffix(fileSuffix);
        entity.setRemark(remark);
        fillAuditFields(entity, operatorId, createTime, demoNow());
        if (entity.getId() == null) {
            relicAttachmentMapper.insert(entity);
        } else {
            relicAttachmentMapper.updateById(entity);
        }
    }

    private void upsertInboundOrder(String orderNo,
                                    String batchNo,
                                    String source,
                                    String handlerName,
                                    LocalDateTime inboundTime,
                                    Integer totalCount,
                                    String status,
                                    String remark,
                                    Long operatorId) {
        String normalizedOrderNo = normalizeBusinessNo(orderNo, inboundTime);
        RelicInboundOrder entity = relicInboundOrderMapper.selectOne(
            Wrappers.<RelicInboundOrder>lambdaQuery()
                .and(wrapper -> wrapper.eq(RelicInboundOrder::getOrderNo, orderNo)
                    .or()
                    .eq(RelicInboundOrder::getOrderNo, normalizedOrderNo))
                .last("LIMIT 1")
        );
        if (entity != null) {
            boolean changed = false;
            String persistedOrderNo = resolvePersistedBusinessNo(entity.getOrderNo(), orderNo, inboundTime);
            if (!Objects.equals(entity.getOrderNo(), persistedOrderNo)) {
                entity.setOrderNo(persistedOrderNo);
                changed = true;
            }
            String persistedBatchNo = resolvePersistedBusinessNo(entity.getBatchNo(), batchNo, inboundTime);
            if (!Objects.equals(entity.getBatchNo(), persistedBatchNo)) {
                entity.setBatchNo(persistedBatchNo);
                changed = true;
            }
            if (!StringUtils.hasText(entity.getSource()) && StringUtils.hasText(source)) {
                entity.setSource(source);
                changed = true;
            }
            if (!StringUtils.hasText(entity.getHandlerName()) && StringUtils.hasText(handlerName)) {
                entity.setHandlerName(handlerName);
                changed = true;
            }
            if (entity.getInboundTime() == null && inboundTime != null) {
                entity.setInboundTime(inboundTime);
                changed = true;
            }
            if (entity.getTotalCount() == null && totalCount != null) {
                entity.setTotalCount(totalCount);
                changed = true;
            }
            if (!StringUtils.hasText(entity.getStatus()) && StringUtils.hasText(status)) {
                entity.setStatus(status);
                changed = true;
            }
            if (!StringUtils.hasText(entity.getRemark()) && StringUtils.hasText(remark)) {
                entity.setRemark(remark);
                changed = true;
            }
            if (changed) {
                touchAuditFields(entity, operatorId, inboundTime == null ? demoNow() : inboundTime.plusHours(2));
                relicInboundOrderMapper.updateById(entity);
            }
            return;
        }
        entity = new RelicInboundOrder();
        entity.setOrderNo(resolvePersistedBusinessNo(entity.getOrderNo(), orderNo, inboundTime));
        entity.setBatchNo(resolvePersistedBusinessNo(entity.getBatchNo(), batchNo, inboundTime));
        entity.setSource(source);
        entity.setHandlerName(handlerName);
        entity.setInboundTime(inboundTime);
        entity.setTotalCount(totalCount);
        entity.setStatus(status);
        entity.setRemark(remark);
        fillAuditFields(entity, operatorId, inboundTime, inboundTime.plusHours(2));
        if (entity.getId() == null) {
            relicInboundOrderMapper.insert(entity);
        } else {
            relicInboundOrderMapper.updateById(entity);
        }
    }

    private void upsertInboundDetail(String orderNo,
                                     Relic relic,
                                     Integer quantity,
                                     String remark,
                                     Long operatorId,
                                     LocalDateTime createTime) {
        String normalizedOrderNo = normalizeBusinessNo(orderNo, createTime);
        RelicInboundOrder order = relicInboundOrderMapper.selectOne(
            Wrappers.<RelicInboundOrder>lambdaQuery()
                .and(wrapper -> wrapper.eq(RelicInboundOrder::getOrderNo, orderNo)
                    .or()
                    .eq(RelicInboundOrder::getOrderNo, normalizedOrderNo))
                .last("LIMIT 1")
        );
        if (order == null || relic == null) {
            return;
        }
        RelicInboundDetail entity = relicInboundDetailMapper.selectOne(
            Wrappers.<RelicInboundDetail>lambdaQuery()
                .eq(RelicInboundDetail::getOrderId, order.getId())
                .eq(RelicInboundDetail::getRelicId, relic.getId())
                .last("LIMIT 1")
        );
        if (entity != null) {
            boolean changed = false;
            if (!Objects.equals(entity.getOrderId(), order.getId())) {
                entity.setOrderId(order.getId());
                changed = true;
            }
            if (!Objects.equals(entity.getRelicId(), relic.getId())) {
                entity.setRelicId(relic.getId());
                changed = true;
            }
            if (!StringUtils.hasText(entity.getRelicNo()) && StringUtils.hasText(relic.getRelicNo())) {
                entity.setRelicNo(relic.getRelicNo());
                changed = true;
            }
            if (!StringUtils.hasText(entity.getRelicName()) && StringUtils.hasText(relic.getName())) {
                entity.setRelicName(relic.getName());
                changed = true;
            }
            if (entity.getQuantity() == null && quantity != null) {
                entity.setQuantity(quantity);
                changed = true;
            }
            if (!StringUtils.hasText(entity.getRemark()) && StringUtils.hasText(remark)) {
                entity.setRemark(remark);
                changed = true;
            }
            if (changed) {
                touchAuditFields(entity, operatorId, createTime.plusHours(1));
                relicInboundDetailMapper.updateById(entity);
            }
            return;
        }
        entity = new RelicInboundDetail();
        entity.setOrderId(order.getId());
        entity.setRelicId(relic.getId());
        entity.setRelicNo(relic.getRelicNo());
        entity.setRelicName(relic.getName());
        entity.setQuantity(quantity);
        entity.setRemark(remark);
        fillAuditFields(entity, operatorId, createTime, createTime.plusHours(1));
        if (entity.getId() == null) {
            relicInboundDetailMapper.insert(entity);
        } else {
            relicInboundDetailMapper.updateById(entity);
        }
    }

    private void upsertOutboundOrder(String orderNo,
                                     String purpose,
                                     String destination,
                                     String handlerName,
                                     LocalDateTime outboundTime,
                                     Long applyUserId,
                                     String approveStatus,
                                     Long approveBy,
                                     LocalDateTime approveTime,
                                     String approveRemark,
                                     LocalDateTime returnTime,
                                     String remark,
                                     Long operatorId) {
        String normalizedOrderNo = normalizeBusinessNo(orderNo, outboundTime);
        RelicOutboundOrder entity = relicOutboundOrderMapper.selectOne(
            Wrappers.<RelicOutboundOrder>lambdaQuery()
                .and(wrapper -> wrapper.eq(RelicOutboundOrder::getOrderNo, orderNo)
                    .or()
                    .eq(RelicOutboundOrder::getOrderNo, normalizedOrderNo))
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RelicOutboundOrder();
        }
        entity.setOrderNo(resolvePersistedBusinessNo(entity.getOrderNo(), orderNo, outboundTime));
        entity.setPurpose(purpose);
        entity.setDestination(destination);
        entity.setHandlerName(handlerName);
        entity.setOutboundTime(outboundTime);
        entity.setApplyUserId(applyUserId);
        entity.setApproveStatus(approveStatus);
        entity.setApproveBy(approveBy);
        entity.setApproveTime(approveTime);
        entity.setApproveRemark(approveRemark);
        entity.setReturnTime(returnTime);
        entity.setRemark(remark);
        fillAuditFields(entity, operatorId, outboundTime, demoNow());
        if (entity.getId() == null) {
            relicOutboundOrderMapper.insert(entity);
        } else {
            relicOutboundOrderMapper.updateById(entity);
        }
    }

    private void upsertOutboundDetail(String orderNo,
                                      Relic relic,
                                      Integer quantity,
                                      String currentStatusSnapshot,
                                      String remark,
                                      Long operatorId,
                                      LocalDateTime createTime) {
        String normalizedOrderNo = normalizeBusinessNo(orderNo, createTime);
        RelicOutboundOrder order = relicOutboundOrderMapper.selectOne(
            Wrappers.<RelicOutboundOrder>lambdaQuery()
                .and(wrapper -> wrapper.eq(RelicOutboundOrder::getOrderNo, orderNo)
                    .or()
                    .eq(RelicOutboundOrder::getOrderNo, normalizedOrderNo))
                .last("LIMIT 1")
        );
        if (order == null || relic == null) {
            return;
        }
        RelicOutboundDetail entity = relicOutboundDetailMapper.selectOne(
            Wrappers.<RelicOutboundDetail>lambdaQuery()
                .eq(RelicOutboundDetail::getOrderId, order.getId())
                .eq(RelicOutboundDetail::getRelicId, relic.getId())
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RelicOutboundDetail();
        }
        entity.setOrderId(order.getId());
        entity.setRelicId(relic.getId());
        entity.setRelicNo(relic.getRelicNo());
        entity.setRelicName(relic.getName());
        entity.setQuantity(quantity);
        entity.setCurrentStatusSnapshot(currentStatusSnapshot);
        entity.setRemark(remark);
        fillAuditFields(entity, operatorId, createTime, createTime.plusHours(1));
        if (entity.getId() == null) {
            relicOutboundDetailMapper.insert(entity);
        } else {
            relicOutboundDetailMapper.updateById(entity);
        }
    }

    private void upsertInventoryTask(String taskNo,
                                     String taskName,
                                     String locationCode,
                                     String taskStatus,
                                     LocalDateTime startTime,
                                     LocalDateTime endTime,
                                     String principalName,
                                     String remark,
                                     Long operatorId) {
        String normalizedTaskNo = normalizeBusinessNo(taskNo, startTime);
        InventoryTask entity = inventoryTaskMapper.selectOne(
            Wrappers.<InventoryTask>lambdaQuery()
                .and(wrapper -> wrapper.eq(InventoryTask::getTaskNo, taskNo)
                    .or()
                    .eq(InventoryTask::getTaskNo, normalizedTaskNo))
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new InventoryTask();
        }
        entity.setTaskNo(resolvePersistedBusinessNo(entity.getTaskNo(), taskNo, startTime));
        entity.setTaskName(taskName);
        entity.setLocationCode(locationCode);
        entity.setTaskStatus(taskStatus);
        entity.setStartTime(startTime);
        entity.setEndTime(endTime);
        entity.setPrincipalName(principalName);
        entity.setRemark(remark);
        fillAuditFields(entity, operatorId, startTime, endTime == null ? demoNow() : endTime);
        if (entity.getId() == null) {
            inventoryTaskMapper.insert(entity);
        } else {
            inventoryTaskMapper.updateById(entity);
        }
    }

    private void upsertInventoryTaskDetail(String taskNo,
                                           Relic relic,
                                           Integer systemQuantity,
                                           Integer actualQuantity,
                                           Integer diffQuantity,
                                           String diffRemark,
                                           String resultStatus,
                                           Long operatorId,
                                           LocalDateTime createTime) {
        String normalizedTaskNo = normalizeBusinessNo(taskNo, createTime);
        InventoryTask task = inventoryTaskMapper.selectOne(
            Wrappers.<InventoryTask>lambdaQuery()
                .and(wrapper -> wrapper.eq(InventoryTask::getTaskNo, taskNo)
                    .or()
                    .eq(InventoryTask::getTaskNo, normalizedTaskNo))
                .last("LIMIT 1")
        );
        if (task == null || relic == null) {
            return;
        }
        InventoryTaskDetail entity = inventoryTaskDetailMapper.selectOne(
            Wrappers.<InventoryTaskDetail>lambdaQuery()
                .eq(InventoryTaskDetail::getTaskId, task.getId())
                .eq(InventoryTaskDetail::getRelicId, relic.getId())
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new InventoryTaskDetail();
        }
        entity.setTaskId(task.getId());
        entity.setRelicId(relic.getId());
        entity.setRelicNo(relic.getRelicNo());
        entity.setRelicName(relic.getName());
        entity.setSystemQuantity(systemQuantity);
        entity.setActualQuantity(actualQuantity);
        entity.setDiffQuantity(diffQuantity);
        entity.setDiffRemark(diffRemark);
        entity.setResultStatus(resultStatus);
        fillAuditFields(entity, operatorId, createTime, demoNow());
        if (entity.getId() == null) {
            inventoryTaskDetailMapper.insert(entity);
        } else {
            inventoryTaskDetailMapper.updateById(entity);
        }
    }

    private RepairTask upsertRepairTask(String taskNo,
                                        Relic relic,
                                        Long applyUserId,
                                        String applyReason,
                                        String taskStatus,
                                        String acceptanceStatus,
                                        LocalDateTime applyTime,
                                        Long approveBy,
                                        LocalDateTime approveTime,
                                        String approveRemark,
                                        LocalDateTime startTime,
                                        LocalDateTime endTime,
                                        String remark) {
        String normalizedTaskNo = normalizeBusinessNo(taskNo, applyTime);
        RepairTask entity = repairTaskMapper.selectOne(
            Wrappers.<RepairTask>lambdaQuery()
                .and(wrapper -> wrapper.eq(RepairTask::getTaskNo, taskNo)
                    .or()
                    .eq(RepairTask::getTaskNo, normalizedTaskNo))
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RepairTask();
        }
        entity.setTaskNo(resolvePersistedBusinessNo(entity.getTaskNo(), taskNo, applyTime));
        entity.setRelicId(relic.getId());
        entity.setRelicNo(relic.getRelicNo());
        entity.setRelicName(relic.getName());
        entity.setApplyUserId(applyUserId);
        entity.setApplyReason(applyReason);
        entity.setTaskStatus(taskStatus);
        entity.setAcceptanceStatus(acceptanceStatus);
        entity.setApplyTime(applyTime);
        entity.setApproveBy(approveBy);
        entity.setApproveTime(approveTime);
        entity.setApproveRemark(approveRemark);
        entity.setStartTime(startTime);
        entity.setEndTime(endTime);
        entity.setRemark(remark);
        fillAuditFields(entity, applyUserId, applyTime, demoNow());
        if (entity.getId() == null) {
            repairTaskMapper.insert(entity);
        } else {
            repairTaskMapper.updateById(entity);
        }
        return entity;
    }

    private void upsertRepairPlan(String planNo,
                                  Long repairTaskId,
                                  String planTitle,
                                  String planContent,
                                  String materials,
                                  String riskNote,
                                  String planStatus,
                                  String submitterName,
                                  String reviewerName,
                                  LocalDateTime reviewTime,
                                  String reviewRemark,
                                  Long operatorId) {
        String normalizedPlanNo = normalizeBusinessNo(planNo, reviewTime);
        RepairPlan entity = repairPlanMapper.selectOne(
            Wrappers.<RepairPlan>lambdaQuery()
                .and(wrapper -> wrapper.eq(RepairPlan::getPlanNo, planNo)
                    .or()
                    .eq(RepairPlan::getPlanNo, normalizedPlanNo))
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RepairPlan();
        }
        entity.setRepairTaskId(repairTaskId);
        entity.setPlanNo(resolvePersistedBusinessNo(entity.getPlanNo(), planNo, reviewTime));
        entity.setPlanTitle(planTitle);
        entity.setPlanContent(planContent);
        entity.setMaterials(materials);
        entity.setRiskNote(riskNote);
        entity.setPlanStatus(planStatus);
        entity.setSubmitterName(submitterName);
        entity.setReviewerName(reviewerName);
        entity.setReviewTime(reviewTime);
        entity.setReviewRemark(reviewRemark);
        fillAuditFields(entity, operatorId, reviewTime.minusHours(1), reviewTime);
        if (entity.getId() == null) {
            repairPlanMapper.insert(entity);
        } else {
            repairPlanMapper.updateById(entity);
        }
    }

    private void upsertRepairLog(String logNo,
                                 Long repairTaskId,
                                 String stepName,
                                 String operationContent,
                                 String materialsUsed,
                                 String operatorName,
                                 LocalDateTime logTime,
                                 String progressStatus,
                                 String remark,
                                 Long operatorId) {
        String normalizedLogNo = normalizeBusinessNo(logNo, logTime);
        RepairLog entity = repairLogMapper.selectOne(
            Wrappers.<RepairLog>lambdaQuery()
                .and(wrapper -> wrapper.eq(RepairLog::getLogNo, logNo)
                    .or()
                    .eq(RepairLog::getLogNo, normalizedLogNo))
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RepairLog();
        }
        entity.setRepairTaskId(repairTaskId);
        entity.setLogNo(resolvePersistedBusinessNo(entity.getLogNo(), logNo, logTime));
        entity.setStepName(stepName);
        entity.setOperationContent(operationContent);
        entity.setMaterialsUsed(materialsUsed);
        entity.setOperatorName(operatorName);
        entity.setLogTime(logTime);
        entity.setProgressStatus(progressStatus);
        entity.setRemark(remark);
        fillAuditFields(entity, operatorId, logTime, logTime);
        if (entity.getId() == null) {
            repairLogMapper.insert(entity);
        } else {
            repairLogMapper.updateById(entity);
        }
    }

    private void upsertRepairAcceptance(String acceptanceNo,
                                        Long repairTaskId,
                                        String acceptanceResult,
                                        Long acceptanceBy,
                                        LocalDateTime acceptanceTime,
                                        String acceptanceRemark,
                                        String followUpSuggestion,
                                        Long operatorId) {
        String normalizedAcceptanceNo = normalizeBusinessNo(acceptanceNo, acceptanceTime);
        RepairAcceptance entity = repairAcceptanceMapper.selectOne(
            Wrappers.<RepairAcceptance>lambdaQuery()
                .and(wrapper -> wrapper.eq(RepairAcceptance::getAcceptanceNo, acceptanceNo)
                    .or()
                    .eq(RepairAcceptance::getAcceptanceNo, normalizedAcceptanceNo))
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RepairAcceptance();
        }
        entity.setRepairTaskId(repairTaskId);
        entity.setAcceptanceNo(resolvePersistedBusinessNo(entity.getAcceptanceNo(), acceptanceNo, acceptanceTime));
        entity.setAcceptanceResult(acceptanceResult);
        entity.setAcceptanceBy(acceptanceBy);
        entity.setAcceptanceTime(acceptanceTime);
        entity.setAcceptanceRemark(acceptanceRemark);
        entity.setFollowUpSuggestion(followUpSuggestion);
        fillAuditFields(entity, operatorId, acceptanceTime, acceptanceTime);
        if (entity.getId() == null) {
            repairAcceptanceMapper.insert(entity);
        } else {
            repairAcceptanceMapper.updateById(entity);
        }
    }

    private void fillAuditFields(BaseEntity entity, Long operatorId, LocalDateTime createTime, LocalDateTime updateTime) {
        entity.setCreateBy(operatorId);
        entity.setCreateTime(createTime);
        entity.setUpdateBy(operatorId);
        entity.setUpdateTime(updateTime);
        entity.setDeleted(0);
    }

    private void touchAuditFields(BaseEntity entity, Long operatorId, LocalDateTime updateTime) {
        entity.setUpdateBy(operatorId);
        entity.setUpdateTime(updateTime);
        entity.setDeleted(0);
    }

    private LocalDateTime demoNow() {
        return DEMO_BASE_TIME;
    }

    private String normalizeBusinessNo(String businessNo, LocalDateTime businessTime) {
        if (!StringUtils.hasText(businessNo)) {
            return businessNo;
        }
        Matcher dateMatcher = DATE_SERIAL_PATTERN.matcher(businessNo);
        if (dateMatcher.matches()) {
            return businessNo;
        }

        Matcher yearMatcher = YEAR_SERIAL_PATTERN.matcher(businessNo);
        if (!yearMatcher.matches()) {
            return businessNo;
        }

        LocalDateTime resolvedTime = businessTime == null ? demoNow() : businessTime;
        return String.format("%s-%s-%s",
            yearMatcher.group(1),
            resolvedTime.format(DATE_SEGMENT_FORMATTER),
            yearMatcher.group(3));
    }

    private String resolvePersistedBusinessNo(String existingBusinessNo, String inputBusinessNo, LocalDateTime businessTime) {
        if (StringUtils.hasText(existingBusinessNo) && DATE_SERIAL_PATTERN.matcher(existingBusinessNo).matches()) {
            return existingBusinessNo;
        }
        return normalizeBusinessNo(inputBusinessNo, businessTime);
    }

    private DemoFileBundle prepareDemoFiles() throws IOException {
        Path basePath = Paths.get(fileStorageProperties.getBasePath()).toAbsolutePath().normalize();
        Path imageFile = basePath.resolve("demo").resolve("images").resolve("relic-placeholder.png");
        Path reportFile = basePath.resolve("demo").resolve("reports").resolve("appraisal-note.txt");
        Path attachmentFile = basePath.resolve("demo").resolve("reports").resolve("archive-note.txt");
        Path repairFile = basePath.resolve("demo").resolve("repair").resolve("repair-log-note.txt");

        createFileIfMissing(imageFile, Base64.getDecoder().decode(PLACEHOLDER_PNG_BASE64));
        createFileIfMissing(reportFile, "Demo appraisal report file.".getBytes(StandardCharsets.UTF_8));
        createFileIfMissing(attachmentFile, "Demo archive attachment file.".getBytes(StandardCharsets.UTF_8));
        createFileIfMissing(repairFile, "Demo repair attachment file.".getBytes(StandardCharsets.UTF_8));

        return new DemoFileBundle(
            "/uploads/demo/images/relic-placeholder.png",
            "/uploads/demo/reports/appraisal-note.txt",
            "/uploads/demo/reports/archive-note.txt",
            "/uploads/demo/images/relic-placeholder.png",
            "/uploads/demo/repair/repair-log-note.txt"
        );
    }

    private void createFileIfMissing(Path path, byte[] content) throws IOException {
        Files.createDirectories(path.getParent());
        if (!Files.exists(path) || Files.size(path) == 0) {
            Files.write(path, content);
        }
    }

    private record DemoFileBundle(String imageUrl,
                                  String reportUrl,
                                  String attachmentUrl,
                                  String repairImageUrl,
                                  String repairFileUrl) {
    }
}

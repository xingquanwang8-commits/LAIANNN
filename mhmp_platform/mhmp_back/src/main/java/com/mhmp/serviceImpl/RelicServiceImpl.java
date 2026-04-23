package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.RelicBusinessRuleUtils;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.AttachmentSaveDTO;
import com.mhmp.dto.RelicPageQueryDTO;
import com.mhmp.dto.RelicSaveDTO;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.entity.RepairAcceptance;
import com.mhmp.entity.RepairLog;
import com.mhmp.entity.RepairTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicAttachment;
import com.mhmp.entity.RelicInboundDetail;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.entity.RelicOutboundDetail;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.entity.RelicTransferTask;
import com.mhmp.entity.SysDictItem;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicAttachmentMapper;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.RelicTransferTaskMapper;
import com.mhmp.mapper.SysDictItemMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.service.RelicService;
import com.mhmp.vo.RelicAttachmentVO;
import com.mhmp.vo.RelicBusinessTimelineVO;
import com.mhmp.vo.RelicDetailVO;
import com.mhmp.vo.RelicListVO;
import com.mhmp.vo.RelicPendingBusinessVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class RelicServiceImpl implements RelicService {

    private static final String TRANSFER_PREFIX = "[TRANSFER]";

    private final RelicMapper relicMapper;
    private final RelicAttachmentMapper relicAttachmentMapper;
    private final RelicInboundDetailMapper relicInboundDetailMapper;
    private final RelicInboundOrderMapper relicInboundOrderMapper;
    private final RelicOutboundDetailMapper relicOutboundDetailMapper;
    private final RelicOutboundOrderMapper relicOutboundOrderMapper;
    private final RelicTransferTaskMapper relicTransferTaskMapper;
    private final InventoryTaskDetailMapper inventoryTaskDetailMapper;
    private final InventoryTaskMapper inventoryTaskMapper;
    private final RepairTaskMapper repairTaskMapper;
    private final RepairLogMapper repairLogMapper;
    private final RepairAcceptanceMapper repairAcceptanceMapper;
    private final SysDictItemMapper sysDictItemMapper;
    private final BusinessNoService businessNoService;

    public RelicServiceImpl(RelicMapper relicMapper,
                            RelicAttachmentMapper relicAttachmentMapper,
                            RelicInboundDetailMapper relicInboundDetailMapper,
                            RelicInboundOrderMapper relicInboundOrderMapper,
                            RelicOutboundDetailMapper relicOutboundDetailMapper,
                            RelicOutboundOrderMapper relicOutboundOrderMapper,
                            RelicTransferTaskMapper relicTransferTaskMapper,
                            InventoryTaskDetailMapper inventoryTaskDetailMapper,
                            InventoryTaskMapper inventoryTaskMapper,
                            RepairTaskMapper repairTaskMapper,
                            RepairLogMapper repairLogMapper,
                            RepairAcceptanceMapper repairAcceptanceMapper,
                            SysDictItemMapper sysDictItemMapper,
                            BusinessNoService businessNoService) {
        this.relicMapper = relicMapper;
        this.relicAttachmentMapper = relicAttachmentMapper;
        this.relicInboundDetailMapper = relicInboundDetailMapper;
        this.relicInboundOrderMapper = relicInboundOrderMapper;
        this.relicOutboundDetailMapper = relicOutboundDetailMapper;
        this.relicOutboundOrderMapper = relicOutboundOrderMapper;
        this.relicTransferTaskMapper = relicTransferTaskMapper;
        this.inventoryTaskDetailMapper = inventoryTaskDetailMapper;
        this.inventoryTaskMapper = inventoryTaskMapper;
        this.repairTaskMapper = repairTaskMapper;
        this.repairLogMapper = repairLogMapper;
        this.repairAcceptanceMapper = repairAcceptanceMapper;
        this.sysDictItemMapper = sysDictItemMapper;
        this.businessNoService = businessNoService;
    }

    @Override
    public PageResponse<RelicListVO> page(RelicPageQueryDTO queryDTO) {
        List<Long> activeTransferRelicIds = Boolean.TRUE.equals(queryDTO.getExcludeActiveTransferTask())
            ? relicTransferTaskMapper.selectList(
                Wrappers.<RelicTransferTask>lambdaQuery()
                    .in(RelicTransferTask::getTaskStatus, RelicBusinessRuleUtils.ACTIVE_TRANSFER_TASK_STATUSES)
                    .select(RelicTransferTask::getRelicId)
            ).stream()
                .map(RelicTransferTask::getRelicId)
                .filter(Objects::nonNull)
                .distinct()
                .toList()
            : List.of();
        Page<Relic> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<Relic> resultPage = relicMapper.selectPage(page,
            Wrappers.<Relic>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(Relic::getRelicNo, queryDTO.getKeyword())
                        .or()
                        .like(Relic::getName, queryDTO.getKeyword())
                        .or()
                        .like(Relic::getEra, queryDTO.getKeyword())
                        .or()
                        .like(Relic::getSource, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getCategoryCode()), Relic::getCategoryCode, queryDTO.getCategoryCode())
                .eq(StringUtils.hasText(queryDTO.getMaterialCode()), Relic::getMaterialCode, queryDTO.getMaterialCode())
                .eq(StringUtils.hasText(queryDTO.getPreservationStatusCode()), Relic::getPreservationStatusCode, queryDTO.getPreservationStatusCode())
                .eq(StringUtils.hasText(queryDTO.getCurrentStatus()), Relic::getCurrentStatus, queryDTO.getCurrentStatus())
                .eq(StringUtils.hasText(queryDTO.getStorageLocationCode()), Relic::getStorageLocationCode, queryDTO.getStorageLocationCode())
                .notIn(!activeTransferRelicIds.isEmpty(), Relic::getId, activeTransferRelicIds)
                .orderByDesc(Relic::getUpdateTime)
                .orderByDesc(Relic::getId)
        );
        return PageResponse.of(resultPage, resultPage.getRecords().stream().map(this::toListVO).toList());
    }

    @Override
    public RelicDetailVO detail(Long id) {
        Relic relic = getRelicOrThrow(id);
        RelicBusinessContext context = loadBusinessContext(id);
        RelicDetailVO vo = new RelicDetailVO();
        BeanUtils.copyProperties(relic, vo);
        vo.setAttachments(listAttachments(id));
        vo.setPendingBusinesses(buildPendingBusinesses(context));
        vo.setBusinessTimeline(buildBusinessTimeline(relic, context));
        return vo;
    }

    @Override
    public Long create(RelicSaveDTO saveDTO) {
        Long currentUserId = SecurityUtils.getUserId();
        Relic relic = new Relic();
        fillRelic(relic, saveDTO);
        relic.setRelicNo(businessNoService.nextRelicNo());
        relic.setCreateBy(currentUserId);
        relic.setUpdateBy(currentUserId);
        relic.setDeleted(0);
        relicMapper.insert(relic);
        saveAttachments(relic.getId(), saveDTO.getAttachments(), currentUserId);
        return relic.getId();
    }

    @Override
    public void update(Long id, RelicSaveDTO saveDTO) {
        Relic relic = getRelicOrThrow(id);
        Long currentUserId = SecurityUtils.getUserId();
        fillRelic(relic, saveDTO);
        relic.setUpdateBy(currentUserId);
        relicMapper.updateById(relic);
        saveAttachments(id, saveDTO.getAttachments(), currentUserId);
    }

    @Override
    public String createCategory(String categoryName) {
        return createDictItem("relic_category", categoryName, businessNoService.nextRelicCategoryValue(), "Created category from relic form");
    }

    @Override
    public String createMaterial(String materialName) {
        return createDictItem("relic_material", materialName, businessNoService.nextRelicMaterialValue(), "Created material from relic form");
    }

    @Override
    public void delete(Long id) {
        Relic relic = getRelicOrThrow(id);
        validateRelicCanDelete(id);
        relicMapper.deleteById(relic.getId());
    }

    @Override
    public List<RelicAttachmentVO> listAttachments(Long relicId) {
        return relicAttachmentMapper.selectList(
                buildNonRepairAttachmentQuery(relicId)
                    .orderByAsc(RelicAttachment::getId)
            ).stream()
            .map(this::toAttachmentVO)
            .toList();
    }

    private Relic getRelicOrThrow(Long id) {
        Relic relic = relicMapper.selectById(id);
        if (relic == null) {
            throw new BusinessException("文物不存在");
        }
        return relic;
    }

    private void fillRelic(Relic relic, RelicSaveDTO saveDTO) {
        String currentStatus = saveDTO.getCurrentStatus();
        relic.setName(saveDTO.getName());
        relic.setCategoryCode(saveDTO.getCategoryCode());
        relic.setMaterialCode(saveDTO.getMaterialCode());
        relic.setEra(saveDTO.getEra());
        relic.setSource(saveDTO.getSource());
        if ("OUT_STOCK".equals(currentStatus) || "TO_BE_INBOUND".equals(currentStatus)) {
            relic.setStorageLocationCode(null);
        } else {
            relic.setStorageLocationCode(saveDTO.getStorageLocationCode());
        }
        relic.setPreservationStatusCode(saveDTO.getPreservationStatusCode());
        relic.setCurrentStatus(currentStatus);
        relic.setProtectionLevel(saveDTO.getProtectionLevel());
        relic.setStorageCondition(saveDTO.getStorageCondition());
        relic.setAttentionNote(saveDTO.getAttentionNote());
        relic.setDescription(saveDTO.getDescription());
        relic.setNote(saveDTO.getNote());
        relic.setImageUrl(saveDTO.getImageUrl());
        relic.setAppraisalReportUrl(saveDTO.getAppraisalReportUrl());
    }

    private String createDictItem(String dictTypeCode, String itemName, String itemValue, String remark) {
        String normalizedName = itemName == null ? "" : itemName.trim();
        if (!StringUtils.hasText(normalizedName)) {
            throw new BusinessException("字典项名称不能为空");
        }

        long duplicateCount = sysDictItemMapper.selectCount(
            Wrappers.<SysDictItem>lambdaQuery()
                .eq(SysDictItem::getDictTypeCode, dictTypeCode)
                .eq(SysDictItem::getItemLabel, normalizedName)
        );
        if (duplicateCount > 0) {
            throw new BusinessException("字典项已存在");
        }

        Integer nextSort = sysDictItemMapper.selectList(
                Wrappers.<SysDictItem>lambdaQuery()
                    .eq(SysDictItem::getDictTypeCode, dictTypeCode)
                    .orderByDesc(SysDictItem::getItemSort)
                    .orderByDesc(SysDictItem::getId)
                    .last("LIMIT 1")
            ).stream()
            .map(SysDictItem::getItemSort)
            .filter(Objects::nonNull)
            .findFirst()
            .orElse(0) + 1;

        Long currentUserId = SecurityUtils.getUserId();
        SysDictItem entity = new SysDictItem();
        entity.setDictTypeCode(dictTypeCode);
        entity.setItemLabel(normalizedName);
        entity.setItemValue(itemValue);
        entity.setItemSort(nextSort);
        entity.setStatus("ENABLED");
        entity.setRemark(remark);
        entity.setCreateBy(currentUserId);
        entity.setUpdateBy(currentUserId);
        entity.setDeleted(0);
        sysDictItemMapper.insert(entity);
        return entity.getItemValue();
    }

    private void saveAttachments(Long relicId, List<AttachmentSaveDTO> attachments, Long currentUserId) {
        relicAttachmentMapper.delete(buildNonRepairAttachmentQuery(relicId));
        if (attachments == null || attachments.isEmpty()) {
            return;
        }
        for (AttachmentSaveDTO attachment : attachments) {
            if (attachment == null || !StringUtils.hasText(attachment.getFileUrl())) {
                continue;
            }
            RelicAttachment entity = new RelicAttachment();
            entity.setRelicId(relicId);
            entity.setAttachmentType(StringUtils.hasText(attachment.getAttachmentType()) ? attachment.getAttachmentType() : "DOCUMENT");
            entity.setFileName(attachment.getFileName());
            entity.setFileUrl(attachment.getFileUrl());
            entity.setFileSize(attachment.getFileSize());
            entity.setFileSuffix(attachment.getFileSuffix());
            entity.setRemark(attachment.getRemark());
            entity.setCreateBy(currentUserId);
            entity.setUpdateBy(currentUserId);
            entity.setDeleted(0);
            relicAttachmentMapper.insert(entity);
        }
    }

    private LambdaQueryWrapper<RelicAttachment> buildNonRepairAttachmentQuery(Long relicId) {
        return Wrappers.<RelicAttachment>lambdaQuery()
            .eq(RelicAttachment::getRelicId, relicId)
            .and(wrapper -> wrapper.isNull(RelicAttachment::getAttachmentType)
                .or()
                .notLikeRight(RelicAttachment::getAttachmentType, "REPAIR_"));
    }

    private RelicBusinessContext loadBusinessContext(Long relicId) {
        List<RelicInboundDetail> inboundDetails = listInboundDetailsByRelicId(relicId);
        Map<Long, RelicInboundOrder> inboundOrderMap = loadInboundOrderMap(extractIds(inboundDetails, RelicInboundDetail::getOrderId));

        List<RelicOutboundDetail> outboundDetails = listOutboundDetailsByRelicId(relicId);
        Map<Long, RelicOutboundOrder> outboundOrderMap = loadOutboundOrderMap(extractIds(outboundDetails, RelicOutboundDetail::getOrderId));

        List<InventoryTaskDetail> inventoryDetails = listInventoryDetailsByRelicId(relicId);
        Map<Long, InventoryTask> inventoryTaskMap = loadInventoryTaskMap(extractIds(inventoryDetails, InventoryTaskDetail::getTaskId));

        List<RelicTransferTask> transferTasks = listTransferTasksByRelicId(relicId);
        List<RepairTask> repairTasks = listRepairTasksByRelicId(relicId);
        Set<Long> repairTaskIds = extractIds(repairTasks, RepairTask::getId);

        return new RelicBusinessContext(
            inboundDetails,
            inboundOrderMap,
            outboundDetails,
            outboundOrderMap,
            inventoryDetails,
            inventoryTaskMap,
            transferTasks,
            repairTasks,
            loadRepairLogMap(repairTaskIds),
            loadRepairAcceptanceMap(repairTaskIds)
        );
    }

    private List<RelicPendingBusinessVO> buildPendingBusinesses(RelicBusinessContext context) {
        List<RelicPendingBusinessVO> pendingBusinesses = new ArrayList<>();
        context.transferTasks().stream()
            .filter(task -> RelicBusinessRuleUtils.ACTIVE_TRANSFER_TASK_STATUSES.contains(task.getTaskStatus()))
            .sorted(Comparator.comparing(RelicTransferTask::getAssignTime, Comparator.nullsLast(LocalDateTime::compareTo)).reversed())
            .forEach(task -> {
                RelicPendingBusinessVO vo = new RelicPendingBusinessVO();
                vo.setBusinessType("TRANSFER_CONFIRM");
                vo.setRelatedId(task.getId());
                vo.setTitle("待确认转存");
                vo.setDescription(String.format("转存任务 %s，库位：%s -> %s，负责人：%s",
                    task.getTaskNo(), task.getFromLocationCode(), task.getTargetLocationCode(), task.getPrincipalName()));
                vo.setStatus(task.getTaskStatus());
                vo.setEventTime(task.getAssignTime());
                pendingBusinesses.add(vo);
            });

        context.inboundOrderMap().values().stream()
            .filter(order -> "PENDING".equals(order.getStatus()))
            .sorted(Comparator.comparing(RelicInboundOrder::getInboundTime, Comparator.nullsLast(LocalDateTime::compareTo)).reversed())
            .forEach(order -> {
                RelicPendingBusinessVO vo = new RelicPendingBusinessVO();
                vo.setBusinessType("INBOUND_APPROVAL");
                vo.setRelatedId(order.getId());
                vo.setTitle("待处理入库审批");
                vo.setDescription(String.format("入库单 %s，来源：%s，批次：%s",
                    order.getOrderNo(), order.getSource(), order.getBatchNo()));
                vo.setStatus(order.getStatus());
                vo.setEventTime(order.getInboundTime());
                pendingBusinesses.add(vo);
            });

        context.outboundOrderMap().values().stream()
            .filter(order -> "PENDING".equals(order.getApproveStatus()) || "APPROVED".equals(order.getApproveStatus()))
            .sorted(Comparator.comparing(RelicOutboundOrder::getOutboundTime, Comparator.nullsLast(LocalDateTime::compareTo)).reversed())
            .forEach(order -> {
                RelicPendingBusinessVO vo = new RelicPendingBusinessVO();
                vo.setBusinessType("PENDING".equals(order.getApproveStatus()) ? "OUTBOUND_APPROVAL" : "OUTBOUND_RETURN");
                vo.setRelatedId(order.getId());
                vo.setTitle("PENDING".equals(order.getApproveStatus()) ? "待处理出库审批" : "待登记出库归还");
                vo.setDescription(String.format("出库单 %s，去向：%s，用途：%s",
                    order.getOrderNo(), order.getDestination(), order.getPurpose()));
                vo.setStatus(order.getApproveStatus());
                vo.setEventTime("PENDING".equals(order.getApproveStatus()) ? order.getOutboundTime() : order.getApproveTime());
                pendingBusinesses.add(vo);
            });

        context.repairTasks().stream()
            .filter(task -> "COMPLETED".equals(task.getTaskStatus()))
            .filter(task -> RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_WAITING.equals(task.getAcceptanceStatus()))
            .sorted(Comparator.comparing(RepairTask::getEndTime, Comparator.nullsLast(LocalDateTime::compareTo)).reversed())
            .forEach(task -> {
                RelicPendingBusinessVO vo = new RelicPendingBusinessVO();
                vo.setBusinessType("REPAIR_ACCEPTANCE");
                vo.setRelatedId(task.getId());
                vo.setTitle("待处理修复验收");
                vo.setDescription(String.format("修复任务 %s 已申请验收，等待管理员处理", task.getTaskNo()));
                vo.setStatus(task.getAcceptanceStatus());
                vo.setEventTime(task.getEndTime());
                pendingBusinesses.add(vo);
            });

        pendingBusinesses.sort(Comparator.comparing(RelicPendingBusinessVO::getEventTime, Comparator.nullsLast(LocalDateTime::compareTo)).reversed());
        return pendingBusinesses;
    }

    private List<RelicBusinessTimelineVO> buildBusinessTimeline(Relic relic, RelicBusinessContext context) {
        List<RelicBusinessTimelineVO> timeline = new ArrayList<>();

        timeline.add(createTimelineEvent(
            "ARCHIVE",
            "文物建档",
            String.format("完成文物档案建档，当前状态：%s", relic.getCurrentStatus()),
            relic.getCurrentStatus(),
            relic.getCreateTime(),
            relic.getId()
        ));

        appendTransferEvents(timeline, relic);
        appendInboundEvents(timeline, context);
        appendOutboundEvents(timeline, context);
        appendInventoryEvents(timeline, context);
        appendRepairEvents(timeline, context);

        return timeline.stream()
            .filter(item -> item.getEventTime() != null)
            .sorted(Comparator.comparing(RelicBusinessTimelineVO::getEventTime).reversed())
            .toList();
    }

    private void appendTransferEvents(List<RelicBusinessTimelineVO> timeline, Relic relic) {
        if (!StringUtils.hasText(relic.getNote())) {
            return;
        }
        String[] lines = relic.getNote().split("\\r?\\n");
        for (String line : lines) {
            if (!StringUtils.hasText(line) || !line.startsWith(TRANSFER_PREFIX)) {
                continue;
            }
            RelicBusinessTimelineVO event = parseTransferLine(line, relic.getId());
            if (event != null) {
                timeline.add(event);
            }
        }
    }

    private RelicBusinessTimelineVO parseTransferLine(String line, Long relicId) {
        try {
            int timeStart = line.indexOf('[');
            int timeEnd = line.indexOf(']', TRANSFER_PREFIX.length());
            if (timeStart < 0 || timeEnd < 0 || timeEnd <= TRANSFER_PREFIX.length()) {
                return null;
            }
            String timeText = line.substring(TRANSFER_PREFIX.length() + 1, timeEnd);
            String payload = line.substring(timeEnd + 1);
            Map<String, String> values = new HashMap<>();
            for (String part : payload.split(";")) {
                int index = part.indexOf('=');
                if (index > 0) {
                    values.put(part.substring(0, index), part.substring(index + 1));
                }
            }
            return createTimelineEvent(
                "TRANSFER",
                "馆内转存",
                String.format("库位由 %s 调整到 %s，原因：%s",
                    values.getOrDefault("from", "--"),
                    values.getOrDefault("to", "--"),
                    values.getOrDefault("reason", "未填写")),
                "COMPLETED",
                LocalDateTime.parse(timeText),
                relicId
            );
        } catch (DateTimeParseException ex) {
            return null;
        }
    }

    private void appendInboundEvents(List<RelicBusinessTimelineVO> timeline, RelicBusinessContext context) {
        for (RelicInboundDetail detail : context.inboundDetails()) {
            RelicInboundOrder order = context.inboundOrderMap().get(detail.getOrderId());
            if (order == null) {
                continue;
            }
            timeline.add(createTimelineEvent(
                "INBOUND",
                "文物入库",
                String.format("入库单 %s，来源：%s，批次：%s", order.getOrderNo(), order.getSource(), order.getBatchNo()),
                order.getStatus(),
                order.getInboundTime(),
                order.getId()
            ));
        }
    }

    private void appendOutboundEvents(List<RelicBusinessTimelineVO> timeline, RelicBusinessContext context) {
        for (RelicOutboundDetail detail : context.outboundDetails()) {
            RelicOutboundOrder order = context.outboundOrderMap().get(detail.getOrderId());
            if (order == null) {
                continue;
            }
            timeline.add(createTimelineEvent(
                "OUTBOUND_APPLY",
                "提交出库申请",
                String.format("出库单 %s，去向：%s，用途：%s", order.getOrderNo(), order.getDestination(), order.getPurpose()),
                order.getApproveStatus(),
                order.getOutboundTime(),
                order.getId()
            ));
            if (order.getApproveTime() != null) {
                timeline.add(createTimelineEvent(
                    "APPROVED".equals(order.getApproveStatus()) ? "OUTBOUND_APPROVE" : "OUTBOUND_REVIEW",
                    "REJECTED".equals(order.getApproveStatus()) ? "出库审批驳回" : "出库审批处理",
                    StringUtils.hasText(order.getApproveRemark()) ? order.getApproveRemark() : "已完成出库审批处理",
                    order.getApproveStatus(),
                    order.getApproveTime(),
                    order.getId()
                ));
            }
            if (order.getReturnTime() != null) {
                timeline.add(createTimelineEvent(
                    "OUTBOUND_RETURN",
                    "出库归还登记",
                    String.format("出库单 %s 已完成归还登记", order.getOrderNo()),
                    order.getApproveStatus(),
                    order.getReturnTime(),
                    order.getId()
                ));
            }
        }
    }

    private void appendInventoryEvents(List<RelicBusinessTimelineVO> timeline, RelicBusinessContext context) {
        for (InventoryTaskDetail detail : context.inventoryDetails()) {
            InventoryTask task = context.inventoryTaskMap().get(detail.getTaskId());
            if (task == null) {
                continue;
            }
            timeline.add(createTimelineEvent(
                "INVENTORY",
                "发起文物盘点",
                String.format("盘点任务 %s，库位：%s", task.getTaskNo(), task.getLocationCode()),
                task.getTaskStatus(),
                task.getStartTime(),
                task.getId()
            ));
            if (task.getEndTime() != null) {
                timeline.add(createTimelineEvent(
                    "INVENTORY_RESULT",
                    "盘点结果提交",
                    String.format("结果：%s，差异：%s", detail.getResultStatus(), detail.getDiffRemark()),
                    detail.getResultStatus(),
                    task.getEndTime(),
                    task.getId()
                ));
            }
        }
    }

    private void appendRepairEvents(List<RelicBusinessTimelineVO> timeline, RelicBusinessContext context) {
        if (context.repairTasks().isEmpty()) {
            return;
        }

        for (RepairTask task : context.repairTasks()) {
            timeline.add(createTimelineEvent(
                "REPAIR_APPLY",
                "提交修复申请",
                String.format("修复任务 %s，原因：%s", task.getTaskNo(), task.getApplyReason()),
                "APPLIED",
                task.getApplyTime(),
                task.getId()
            ));
            if (task.getApproveTime() != null) {
                timeline.add(createTimelineEvent(
                    "REPAIR_APPROVE",
                    "REJECTED".equals(task.getTaskStatus()) ? "修复审批驳回" : "修复审批通过",
                    StringUtils.hasText(task.getApproveRemark()) ? task.getApproveRemark() : "已完成修复审批",
                    "REJECTED".equals(task.getTaskStatus()) ? "REJECTED" : "APPROVED",
                    task.getApproveTime(),
                    task.getId()
                ));
            }
            if (task.getEndTime() != null) {
                timeline.add(createTimelineEvent(
                    "REPAIR_COMPLETE",
                    "修复完成",
                    String.format("修复任务 %s 已完成，等待后续验收", task.getTaskNo()),
                    StringUtils.hasText(task.getAcceptanceStatus()) ? task.getAcceptanceStatus() : task.getTaskStatus(),
                    task.getEndTime(),
                    task.getId()
                ));
            }
            for (RepairLog log : context.repairLogMap().getOrDefault(task.getId(), List.of())) {
                timeline.add(createTimelineEvent(
                    "REPAIR_LOG",
                    StringUtils.hasText(log.getStepName()) ? log.getStepName() : "修复过程更新",
                    log.getOperationContent(),
                    log.getProgressStatus(),
                    log.getLogTime(),
                    task.getId()
                ));
            }
            RepairAcceptance acceptance = context.repairAcceptanceMap().get(task.getId());
            if (acceptance != null && acceptance.getAcceptanceTime() != null) {
                timeline.add(createTimelineEvent(
                    "REPAIR_ACCEPTANCE",
                    "PASS".equals(acceptance.getAcceptanceResult()) ? "修复验收通过" : "修复验收驳回",
                    StringUtils.hasText(acceptance.getAcceptanceRemark()) ? acceptance.getAcceptanceRemark() : "已提交修复验收结果",
                    acceptance.getAcceptanceResult(),
                    acceptance.getAcceptanceTime(),
                    task.getId()
                ));
            }
        }
    }

    private List<RelicInboundDetail> listInboundDetailsByRelicId(Long relicId) {
        return relicInboundDetailMapper.selectList(
            Wrappers.<RelicInboundDetail>lambdaQuery().eq(RelicInboundDetail::getRelicId, relicId)
        );
    }

    private List<RelicOutboundDetail> listOutboundDetailsByRelicId(Long relicId) {
        return relicOutboundDetailMapper.selectList(
            Wrappers.<RelicOutboundDetail>lambdaQuery().eq(RelicOutboundDetail::getRelicId, relicId)
        );
    }

    private List<InventoryTaskDetail> listInventoryDetailsByRelicId(Long relicId) {
        return inventoryTaskDetailMapper.selectList(
            Wrappers.<InventoryTaskDetail>lambdaQuery().eq(InventoryTaskDetail::getRelicId, relicId)
        );
    }

    private List<RelicTransferTask> listTransferTasksByRelicId(Long relicId) {
        return relicTransferTaskMapper.selectList(
            Wrappers.<RelicTransferTask>lambdaQuery()
                .eq(RelicTransferTask::getRelicId, relicId)
                .orderByDesc(RelicTransferTask::getAssignTime)
                .orderByDesc(RelicTransferTask::getId)
        );
    }

    private List<RepairTask> listRepairTasksByRelicId(Long relicId) {
        return repairTaskMapper.selectList(
            Wrappers.<RepairTask>lambdaQuery()
                .eq(RepairTask::getRelicId, relicId)
                .orderByDesc(RepairTask::getApplyTime)
        );
    }

    private Map<Long, List<RepairLog>> loadRepairLogMap(Set<Long> taskIds) {
        if (taskIds == null || taskIds.isEmpty()) {
            return Map.of();
        }
        return repairLogMapper.selectList(
                Wrappers.<RepairLog>lambdaQuery()
                    .in(RepairLog::getRepairTaskId, taskIds)
                    .orderByAsc(RepairLog::getLogTime)
            ).stream()
            .collect(Collectors.groupingBy(RepairLog::getRepairTaskId));
    }

    private Map<Long, RepairAcceptance> loadRepairAcceptanceMap(Set<Long> taskIds) {
        if (taskIds == null || taskIds.isEmpty()) {
            return Map.of();
        }
        return repairAcceptanceMapper.selectList(
                Wrappers.<RepairAcceptance>lambdaQuery().in(RepairAcceptance::getRepairTaskId, taskIds)
            ).stream()
            .collect(Collectors.toMap(RepairAcceptance::getRepairTaskId, item -> item, (left, right) -> left));
    }

    private Map<Long, RelicInboundOrder> loadInboundOrderMap(Set<Long> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return Map.of();
        }
        return relicInboundOrderMapper.selectBatchIds(orderIds).stream()
            .collect(Collectors.toMap(RelicInboundOrder::getId, item -> item));
    }

    private Map<Long, RelicOutboundOrder> loadOutboundOrderMap(Set<Long> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return Map.of();
        }
        return relicOutboundOrderMapper.selectBatchIds(orderIds).stream()
            .collect(Collectors.toMap(RelicOutboundOrder::getId, item -> item));
    }

    private Map<Long, InventoryTask> loadInventoryTaskMap(Set<Long> taskIds) {
        if (taskIds == null || taskIds.isEmpty()) {
            return Map.of();
        }
        return inventoryTaskMapper.selectBatchIds(taskIds).stream()
            .collect(Collectors.toMap(InventoryTask::getId, item -> item));
    }

    private <T> Set<Long> extractIds(List<T> entities, Function<T, Long> idExtractor) {
        if (entities == null || entities.isEmpty()) {
            return Set.of();
        }
        return entities.stream()
            .map(idExtractor)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
    }

    private void validateRelicCanDelete(Long relicId) {
        long inboundCount = relicInboundDetailMapper.selectCount(
            Wrappers.<RelicInboundDetail>lambdaQuery().eq(RelicInboundDetail::getRelicId, relicId)
        );
        long outboundCount = relicOutboundDetailMapper.selectCount(
            Wrappers.<RelicOutboundDetail>lambdaQuery().eq(RelicOutboundDetail::getRelicId, relicId)
        );
        long inventoryCount = inventoryTaskDetailMapper.selectCount(
            Wrappers.<InventoryTaskDetail>lambdaQuery().eq(InventoryTaskDetail::getRelicId, relicId)
        );
        long transferCount = relicTransferTaskMapper.selectCount(
            Wrappers.<RelicTransferTask>lambdaQuery().eq(RelicTransferTask::getRelicId, relicId)
        );
        long repairCount = repairTaskMapper.selectCount(
            Wrappers.<RepairTask>lambdaQuery().eq(RepairTask::getRelicId, relicId)
        );
        if (inboundCount + outboundCount + inventoryCount + transferCount + repairCount > 0) {
            throw new BusinessException("This relic has related business records and cannot be deleted");
        }
    }

    private RelicBusinessTimelineVO createTimelineEvent(String eventType,
                                                        String title,
                                                        String description,
                                                        String status,
                                                        LocalDateTime eventTime,
                                                        Long relatedId) {
        RelicBusinessTimelineVO vo = new RelicBusinessTimelineVO();
        vo.setEventType(eventType);
        vo.setTitle(title);
        vo.setDescription(description);
        vo.setStatus(status);
        vo.setEventTime(eventTime);
        vo.setRelatedId(relatedId);
        return vo;
    }

    private RelicListVO toListVO(Relic entity) {
        RelicListVO vo = new RelicListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private RelicAttachmentVO toAttachmentVO(RelicAttachment entity) {
        RelicAttachmentVO vo = new RelicAttachmentVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private String appendBusinessNote(String originalNote, String noteLine) {
        if (!StringUtils.hasText(originalNote)) {
            return noteLine;
        }
        return originalNote + System.lineSeparator() + noteLine;
    }

    private record RelicBusinessContext(List<RelicInboundDetail> inboundDetails,
                                        Map<Long, RelicInboundOrder> inboundOrderMap,
                                        List<RelicOutboundDetail> outboundDetails,
                                        Map<Long, RelicOutboundOrder> outboundOrderMap,
                                        List<InventoryTaskDetail> inventoryDetails,
                                        Map<Long, InventoryTask> inventoryTaskMap,
                                        List<RelicTransferTask> transferTasks,
                                        List<RepairTask> repairTasks,
                                        Map<Long, List<RepairLog>> repairLogMap,
                                        Map<Long, RepairAcceptance> repairAcceptanceMap) {
    }
}

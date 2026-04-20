package com.mhmp.common.util;

import com.mhmp.common.exception.BusinessException;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.entity.RepairTask;
import org.springframework.util.StringUtils;

import java.util.List;

public final class RelicBusinessRuleUtils {

    public static final String REPAIR_ACCEPTANCE_STATUS_UNACCEPTED = "UNACCEPTED";
    public static final String REPAIR_ACCEPTANCE_STATUS_WAITING = "WAITING";
    public static final String REPAIR_ACCEPTANCE_STATUS_SUCCESS = "SUCCESS";
    public static final String REPAIR_ACCEPTANCE_STATUS_REJECTED = "REJECTED";

    public static final List<String> REPAIRABLE_PRESERVATION_CODES = List.of(
        "INCOMPLETE",
        "SEVERE_INCOMPLETE",
        "FRAGMENTED",
        "PHYSICAL_DAMAGE",
        "CHEMICAL_DEGRADATION",
        "BIOLOGICAL_DISEASE"
    );

    public static final List<String> ACTIVE_INVENTORY_TASK_STATUSES = List.of("CREATED", "IN_PROGRESS");
    public static final List<String> ACTIVE_TRANSFER_TASK_STATUSES = List.of("ASSIGNED");
    public static final List<String> REPAIR_LOGGABLE_TASK_STATUSES = List.of("APPROVED", "IN_PROGRESS", "COMPLETED");
    public static final List<String> REPAIR_LOG_PROGRESS_STATUSES = List.of("IN_PROGRESS", "COMPLETED");
    public static final List<String> INVENTORY_EDITABLE_TASK_STATUSES = List.of("CREATED", "IN_PROGRESS");
    public static final List<String> INVENTORY_SUBMITTABLE_TASK_STATUSES = INVENTORY_EDITABLE_TASK_STATUSES;

    private static final List<String> REPAIR_REVIEW_RESULTS = List.of("APPROVED", "REJECTED");
    private static final List<String> REPAIR_ACCEPTANCE_RESULTS = List.of("PASS", "REJECTED");

    private RelicBusinessRuleUtils() {
    }

    public static void validateInboundCreatable(Relic relic) {
        requireRelicExists(relic, "文物入库");
        if (!"TO_BE_INBOUND".equals(relic.getCurrentStatus())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不允许发起文物入库");
        }
    }

    public static void validateInboundApprovable(RelicInboundOrder order, List<Relic> relics) {
        requireInboundOrderExists(order);
        if (!"PENDING".equals(order.getStatus())) {
            throw new BusinessException("当前入库单不是待审批状态，无法执行入库审批");
        }
        validateInboundRelics(relics, "入库审批", "INBOUND_PENDING");
    }

    public static void validateInboundCompletable(RelicInboundOrder order, List<Relic> relics) {
        validateInboundApprovable(order, relics);
    }

    public static void validateOutboundCreatable(Relic relic) {
        requireRelicExists(relic, "文物出库");
        if (!"IN_STOCK".equals(relic.getCurrentStatus())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不允许发起文物出库");
        }
        if (!StringUtils.hasText(relic.getStorageLocationCode())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 缺少馆内库位信息，无法发起文物出库");
        }
    }

    public static void validateTransferCreatable(Relic relic, String targetLocationCode) {
        requireRelicExists(relic, "馆内转存");
        if (!"IN_STOCK".equals(relic.getCurrentStatus())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不允许发起馆内转存");
        }
        if (!StringUtils.hasText(relic.getStorageLocationCode())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 缺少当前馆内库位，无法发起馆内转存");
        }
        if (!StringUtils.hasText(targetLocationCode)) {
            throw new BusinessException("目标库位不能为空");
        }
        if (targetLocationCode.equals(relic.getStorageLocationCode())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 的转存目标库位不能与当前库位相同");
        }
    }

    public static void validateRepairCreatable(Relic relic, boolean hasActiveTask) {
        requireRelicExists(relic, "修复申请");
        if (!"IN_STOCK".equals(relic.getCurrentStatus())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不允许发起修复申请");
        }
        if (!StringUtils.hasText(relic.getPreservationStatusCode())
            || !REPAIRABLE_PRESERVATION_CODES.contains(relic.getPreservationStatusCode())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 当前保存状态不属于待修复范围");
        }
        if (hasActiveTask) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 已存在进行中的修复任务");
        }
    }

    public static void validateRepairLogAddable(RepairTask task, Relic relic, String progressStatus) {
        requireRepairTaskExists(task);
        requireRelicExists(relic, "修复日志");
        if (!REPAIR_LOGGABLE_TASK_STATUSES.contains(task.getTaskStatus())) {
            throw new BusinessException("当前修复任务状态不允许新增修复日志");
        }
        if (!REPAIR_LOG_PROGRESS_STATUSES.contains(progressStatus)) {
            throw new BusinessException("不支持的修复进度状态");
        }
        if (REPAIR_ACCEPTANCE_STATUS_WAITING.equals(task.getAcceptanceStatus())) {
            throw new BusinessException("当前修复任务已申请验收，不能继续记录修复日志");
        }
        if ("COMPLETED".equals(task.getTaskStatus()) && !"COMPLETED".equals(progressStatus)) {
            throw new BusinessException("已完成的修复任务仅允许补充已完成日志");
        }
        if ("APPROVED".equals(task.getTaskStatus())) {
            if (!List.of("IN_STOCK", "IN_REPAIR").contains(relic.getCurrentStatus())) {
                throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不允许开始记录修复日志");
            }
            return;
        }
        if (!"IN_REPAIR".equals(relic.getCurrentStatus())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不是修复中，无法继续记录修复日志");
        }
    }

    public static void validateRepairAcceptanceAppliable(RepairTask task, Relic relic) {
        requireRepairTaskExists(task);
        requireRelicExists(relic, "申请修复验收");
        if (!"COMPLETED".equals(task.getTaskStatus())) {
            throw new BusinessException("当前修复任务未完成，不能申请验收");
        }
        if (!REPAIR_ACCEPTANCE_STATUS_UNACCEPTED.equals(task.getAcceptanceStatus())) {
            throw new BusinessException("当前修复任务不能重复申请验收");
        }
        if (!"IN_REPAIR".equals(relic.getCurrentStatus())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不是修复中，无法申请验收");
        }
    }

    public static void validateInventoryTaskCreatable(String locationCode, List<Relic> relics, boolean hasActiveTask) {
        if (!StringUtils.hasText(locationCode)) {
            throw new BusinessException("盘点库位不能为空");
        }
        if (hasActiveTask) {
            throw new BusinessException("当前库位已存在未完成盘点任务，请先完成现有任务");
        }
        if (relics == null || relics.isEmpty()) {
            throw new BusinessException("当前库位暂无可纳入盘点的在库文物");
        }
    }

    public static void validateInventoryTaskDetailUpdatable(InventoryTask task,
                                                            InventoryTaskDetail detail,
                                                            Long taskId,
                                                            Integer actualQuantity) {
        requireInventoryTaskExists(task);
        if (!INVENTORY_EDITABLE_TASK_STATUSES.contains(task.getTaskStatus())) {
            throw new BusinessException("当前盘点任务状态不允许修改明细");
        }
        if (detail == null || !taskId.equals(detail.getTaskId())) {
            throw new BusinessException("盘点任务明细不存在");
        }
        if (detail.getSystemQuantity() == null) {
            throw new BusinessException("盘点任务明细缺少系统数量，无法更新");
        }
        if (actualQuantity != null && actualQuantity < 0) {
            throw new BusinessException("盘点实际数量不能小于 0");
        }
    }

    public static void validateInventoryTaskSubmittable(InventoryTask task, List<InventoryTaskDetail> details) {
        requireInventoryTaskExists(task);
        if (!INVENTORY_SUBMITTABLE_TASK_STATUSES.contains(task.getTaskStatus())) {
            throw new BusinessException("当前盘点任务状态不允许提交");
        }
        if (details == null || details.isEmpty()) {
            throw new BusinessException("当前盘点任务缺少明细，无法提交");
        }
        boolean hasPending = details.stream()
            .anyMatch(detail -> detail == null || !StringUtils.hasText(detail.getResultStatus()) || "PENDING".equals(detail.getResultStatus()));
        if (hasPending) {
            throw new BusinessException("仍存在未录入的盘点明细，无法提交盘点任务");
        }
    }

    public static void validateOutboundApprovable(RelicOutboundOrder order, List<Relic> relics) {
        requireOutboundOrderExists(order);
        if (!"PENDING".equals(order.getApproveStatus())) {
            throw new BusinessException("当前出库单不是待审批状态，无法执行审批通过");
        }
        validateOutboundRelics(relics, "审批通过", "OUTBOUND_PENDING");
    }

    public static void validateOutboundRejectable(RelicOutboundOrder order, List<Relic> relics) {
        requireOutboundOrderExists(order);
        if (!"PENDING".equals(order.getApproveStatus())) {
            throw new BusinessException("当前出库单不是待审批状态，无法执行审批驳回");
        }
        validateOutboundRelics(relics, "审批驳回", "OUTBOUND_PENDING");
    }

    public static void validateOutboundReturnable(RelicOutboundOrder order, List<Relic> relics) {
        requireOutboundOrderExists(order);
        if (!"APPROVED".equals(order.getApproveStatus())) {
            throw new BusinessException("当前出库单不是已审批通过状态，无法执行归还登记");
        }
        validateOutboundRelics(relics, "归还登记", "OUT_STOCK");
    }

    public static void validateRepairReviewable(RepairTask task,
                                                Relic relic,
                                                String approveResult) {
        requireRepairTaskExists(task);
        requireRelicExists(relic, "修复审批");
        if (!"APPLIED".equals(task.getTaskStatus())) {
            throw new BusinessException("当前修复任务不是待审批状态，无法执行审批");
        }
        if (!REPAIR_REVIEW_RESULTS.contains(approveResult)) {
            throw new BusinessException("不支持的修复审批结果");
        }
        if ("APPROVED".equals(approveResult)) {
            if (!"IN_STOCK".equals(relic.getCurrentStatus())) {
                throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不是在库，无法审批通过修复申请");
            }
            if (!StringUtils.hasText(relic.getPreservationStatusCode())
                || !REPAIRABLE_PRESERVATION_CODES.contains(relic.getPreservationStatusCode())) {
                throw new BusinessException(resolveRelicIdentity(relic) + " 当前保存状态不属于待修复范围，无法审批通过");
            }
            if (false) {
                throw new BusinessException("审批通过修复申请时必须填写修复方案标题和方案内容");
            }
        }
    }

    public static void validateRepairAcceptable(RepairTask task,
                                                Relic relic,
                                                String acceptanceResult,
                                                String acceptanceRemark,
                                                String preservationStatusCode,
                                                String storageLocationCode) {
        requireRepairTaskExists(task);
        requireRelicExists(relic, "修复验收");
        if (!"COMPLETED".equals(task.getTaskStatus())
            || !REPAIR_ACCEPTANCE_STATUS_WAITING.equals(task.getAcceptanceStatus())) {
            throw new BusinessException("当前修复任务不是等待验收状态，无法执行验收");
        }
        if (!REPAIR_ACCEPTANCE_RESULTS.contains(acceptanceResult)) {
            throw new BusinessException("不支持的修复验收结果");
        }
        if (!"IN_REPAIR".equals(relic.getCurrentStatus())) {
            throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态不是修复中，无法执行修复验收");
        }
        if ("PASS".equals(acceptanceResult)) {
            if (!StringUtils.hasText(preservationStatusCode)) {
                throw new BusinessException("修复验收通过时必须填写修复后的保存状态");
            }
            if (!StringUtils.hasText(storageLocationCode)) {
                throw new BusinessException("修复验收通过时必须填写回库库位");
            }
            return;
        }
        if (!StringUtils.hasText(acceptanceRemark)) {
            throw new BusinessException("驳回修复验收时必须填写备注原因");
        }
    }

    private static void validateInboundRelics(List<Relic> relics, String actionName, String requiredStatus) {
        if (relics == null || relics.isEmpty()) {
            throw new BusinessException("入库单缺少文物明细，无法执行" + actionName);
        }
        for (Relic relic : relics) {
            requireRelicExists(relic, actionName);
            if (!requiredStatus.equals(relic.getCurrentStatus())) {
                throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态与" + actionName + "不匹配");
            }
        }
    }

    private static void validateOutboundRelics(List<Relic> relics, String actionName, String requiredStatus) {
        if (relics == null || relics.isEmpty()) {
            throw new BusinessException("当前出库单缺少文物明细，无法执行" + actionName);
        }
        for (Relic relic : relics) {
            requireRelicExists(relic, actionName);
            if (!requiredStatus.equals(relic.getCurrentStatus())) {
                throw new BusinessException(resolveRelicIdentity(relic) + " 当前状态与" + actionName + "不匹配");
            }
        }
    }

    private static void requireInboundOrderExists(RelicInboundOrder order) {
        if (order == null) {
            throw new BusinessException("入库单不存在");
        }
    }

    private static void requireOutboundOrderExists(RelicOutboundOrder order) {
        if (order == null) {
            throw new BusinessException("出库单不存在");
        }
    }

    private static void requireInventoryTaskExists(InventoryTask task) {
        if (task == null) {
            throw new BusinessException("盘点任务不存在");
        }
    }

    private static void requireRepairTaskExists(RepairTask task) {
        if (task == null) {
            throw new BusinessException("修复任务不存在");
        }
    }

    private static void requireRelicExists(Relic relic, String actionName) {
        if (relic == null) {
            throw new BusinessException(actionName + "关联的文物不存在");
        }
    }

    private static String resolveRelicIdentity(Relic relic) {
        if (relic == null) {
            return "该文物";
        }
        if (StringUtils.hasText(relic.getRelicNo()) && StringUtils.hasText(relic.getName())) {
            return relic.getRelicNo() + " / " + relic.getName();
        }
        if (StringUtils.hasText(relic.getName())) {
            return relic.getName();
        }
        if (StringUtils.hasText(relic.getRelicNo())) {
            return relic.getRelicNo();
        }
        return "该文物";
    }
}

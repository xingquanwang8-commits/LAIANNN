package com.mhmp.common.util;

import com.mhmp.common.exception.BusinessException;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.entity.RepairTask;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

class RelicBusinessRuleUtilsTest {

    @Test
    void validateInboundCompletableShouldPassWhenOrderAndRelicMatch() {
        RelicInboundOrder order = new RelicInboundOrder();
        order.setStatus("COMPLETED");

        Relic relic = buildRelic("REL-2026-001", "青铜鼎", "OUT_STOCK", "LOC_A", "COMPLETE");

        assertDoesNotThrow(() -> RelicBusinessRuleUtils.validateInboundCompletable(order, List.of(relic)));
    }

    @Test
    void validateInboundCompletableShouldThrowWhenOrderStatusInvalid() {
        RelicInboundOrder order = new RelicInboundOrder();
        order.setStatus("CREATED");

        Relic relic = buildRelic("REL-2026-001", "青铜鼎", "OUT_STOCK", "LOC_A", "COMPLETE");

        assertThrows(BusinessException.class,
            () -> RelicBusinessRuleUtils.validateInboundCompletable(order, List.of(relic)));
    }

    @Test
    void validateRepairLogAddableShouldThrowWhenCompletedTaskWritesInProgressLog() {
        RepairTask task = new RepairTask();
        task.setTaskStatus("COMPLETED");
        task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_UNACCEPTED);

        Relic relic = buildRelic("REL-2026-002", "彩绘木俑", "IN_REPAIR", "LOC_B", "PHYSICAL_DAMAGE");

        assertThrows(BusinessException.class,
            () -> RelicBusinessRuleUtils.validateRepairLogAddable(task, relic, "IN_PROGRESS"));
    }

    @Test
    void validateInventoryTaskSubmittableShouldThrowWhenPendingDetailExists() {
        InventoryTask task = new InventoryTask();
        task.setTaskStatus("IN_PROGRESS");

        InventoryTaskDetail pendingDetail = new InventoryTaskDetail();
        pendingDetail.setResultStatus("PENDING");

        assertThrows(BusinessException.class,
            () -> RelicBusinessRuleUtils.validateInventoryTaskSubmittable(task, List.of(pendingDetail)));
    }

    @Test
    void validateRepairAcceptableShouldThrowWhenPassWithoutStorageLocation() {
        RepairTask task = new RepairTask();
        task.setTaskStatus("COMPLETED");
        task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_WAITING);

        Relic relic = buildRelic("REL-2026-003", "壁画残片", "IN_REPAIR", "LOC_C", "PHYSICAL_DAMAGE");

        assertThrows(BusinessException.class,
            () -> RelicBusinessRuleUtils.validateRepairAcceptable(task, relic, "PASS", "通过", "BASIC_COMPLETE", ""));
    }

    private Relic buildRelic(String relicNo,
                             String name,
                             String currentStatus,
                             String storageLocationCode,
                             String preservationStatusCode) {
        Relic relic = new Relic();
        relic.setRelicNo(relicNo);
        relic.setName(name);
        relic.setCurrentStatus(currentStatus);
        relic.setStorageLocationCode(storageLocationCode);
        relic.setPreservationStatusCode(preservationStatusCode);
        return relic;
    }
}

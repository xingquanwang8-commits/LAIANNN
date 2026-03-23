package com.mhmp.vo;

import lombok.Data;

@Data
public class DashboardSummaryVO {

    private Long totalRelicCount;
    private Long inStockRelicCount;
    private Long outboundPendingCount;
    private Long repairPendingCount;
    private Long repairingCount;
    private Long inventoryRunningCount;
}

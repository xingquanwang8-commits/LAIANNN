package com.mhmp.vo;

import lombok.Data;

@Data
public class InventorySummaryVO {

    private Long totalCount;
    private Long inStockCount;
    private Long outboundPendingCount;
    private Long outStockCount;
    private Long inRepairCount;
}

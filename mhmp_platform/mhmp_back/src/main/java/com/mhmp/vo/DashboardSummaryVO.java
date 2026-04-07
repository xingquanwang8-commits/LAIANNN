package com.mhmp.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class DashboardSummaryVO {

    private Long totalRelicCount;
    private Long inStockRelicCount;
    private Long outboundPendingCount;
    private Long outboundReturnPendingCount;
    private Long repairPendingCount;
    private Long repairAcceptancePendingCount;
    private Long repairingCount;
    private Long inventoryRunningCount;
    private List<DashboardStatusSliceVO> statusDistribution = new ArrayList<>();
}

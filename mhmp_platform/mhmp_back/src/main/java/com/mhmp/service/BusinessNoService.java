package com.mhmp.service;

public interface BusinessNoService {

    String nextRelicNo();

    String nextInboundOrderNo();

    String nextInboundBatchNo();

    String nextOutboundOrderNo();

    String nextInventoryTaskNo();

    String nextRepairTaskNo();

    String nextRepairPlanNo();

    String nextRepairLogNo();

    String nextRepairAcceptanceNo();

    String nextRelicCategoryValue();

    String nextRelicMaterialValue();
}

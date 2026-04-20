package com.mhmp.service;

public interface BusinessNoService {

    String nextRelicNo();

    String nextInboundOrderNo();

    String nextInboundBatchNo();

    String nextOutboundOrderNo();

    String nextInventoryTaskNo();

    String nextTransferTaskNo();

    String nextRepairTaskNo();

    String nextRepairLogNo();

    String nextRepairAcceptanceNo();

    String nextRelicCategoryValue();

    String nextRelicMaterialValue();
}

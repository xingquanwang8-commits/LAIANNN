package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.entity.RepairTask;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.service.DashboardService;
import com.mhmp.vo.DashboardSummaryVO;
import org.springframework.stereotype.Service;

@Service
public class DashboardServiceImpl implements DashboardService {

    private final RelicMapper relicMapper;
    private final RelicOutboundOrderMapper relicOutboundOrderMapper;
    private final RepairTaskMapper repairTaskMapper;
    private final InventoryTaskMapper inventoryTaskMapper;

    public DashboardServiceImpl(RelicMapper relicMapper,
                                RelicOutboundOrderMapper relicOutboundOrderMapper,
                                RepairTaskMapper repairTaskMapper,
                                InventoryTaskMapper inventoryTaskMapper) {
        this.relicMapper = relicMapper;
        this.relicOutboundOrderMapper = relicOutboundOrderMapper;
        this.repairTaskMapper = repairTaskMapper;
        this.inventoryTaskMapper = inventoryTaskMapper;
    }

    @Override
    public DashboardSummaryVO summary() {
        DashboardSummaryVO vo = new DashboardSummaryVO();
        vo.setTotalRelicCount(relicMapper.selectCount(null));
        vo.setInStockRelicCount(relicMapper.selectCount(
            Wrappers.<Relic>lambdaQuery().eq(Relic::getCurrentStatus, "IN_STOCK")
        ));
        vo.setOutboundPendingCount(relicOutboundOrderMapper.selectCount(
            Wrappers.<RelicOutboundOrder>lambdaQuery().eq(RelicOutboundOrder::getApproveStatus, "PENDING")
        ));
        vo.setRepairPendingCount(repairTaskMapper.selectCount(
            Wrappers.<RepairTask>lambdaQuery().eq(RepairTask::getTaskStatus, "APPLIED")
        ));
        vo.setRepairingCount(repairTaskMapper.selectCount(
            Wrappers.<RepairTask>lambdaQuery().eq(RepairTask::getTaskStatus, "IN_PROGRESS")
        ));
        vo.setInventoryRunningCount(inventoryTaskMapper.selectCount(
            Wrappers.<InventoryTask>lambdaQuery().eq(InventoryTask::getTaskStatus, "IN_PROGRESS")
        ));
        return vo;
    }
}

package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.common.util.RelicBusinessRuleUtils;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.entity.RepairTask;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.service.DashboardService;
import com.mhmp.vo.DashboardStatusSliceVO;
import com.mhmp.vo.DashboardSummaryVO;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

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
        vo.setOutboundReturnPendingCount(relicOutboundOrderMapper.selectCount(
            Wrappers.<RelicOutboundOrder>lambdaQuery().eq(RelicOutboundOrder::getApproveStatus, "APPROVED")
        ));
        vo.setRepairPendingCount(repairTaskMapper.selectCount(
            Wrappers.<RepairTask>lambdaQuery().eq(RepairTask::getTaskStatus, "APPLIED")
        ));
        vo.setRepairAcceptancePendingCount(repairTaskMapper.selectCount(
            Wrappers.<RepairTask>lambdaQuery()
                .eq(RepairTask::getTaskStatus, "COMPLETED")
                .eq(RepairTask::getAcceptanceStatus, RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_WAITING)
        ));
        vo.setRepairingCount(repairTaskMapper.selectCount(
            Wrappers.<RepairTask>lambdaQuery().eq(RepairTask::getTaskStatus, "IN_PROGRESS")
        ));
        vo.setInventoryRunningCount(inventoryTaskMapper.selectCount(
            Wrappers.<InventoryTask>lambdaQuery().eq(InventoryTask::getTaskStatus, "IN_PROGRESS")
        ));
        vo.setStatusDistribution(buildStatusDistribution());
        return vo;
    }

    private List<DashboardStatusSliceVO> buildStatusDistribution() {
        Map<String, Long> statusCountMap = relicMapper.selectList(
                Wrappers.<Relic>query().select("current_status")
            ).stream()
            .map(Relic::getCurrentStatus)
            .filter(StringUtils::hasText)
            .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

        List<DashboardStatusSliceVO> slices = new ArrayList<>();
        List<String> preferredOrder = List.of("IN_STOCK", "INBOUND_PENDING", "OUTBOUND_PENDING", "IN_REPAIR", "OUT_STOCK");
        for (String status : preferredOrder) {
            Long count = statusCountMap.remove(status);
            if (count != null && count > 0) {
                slices.add(createStatusSlice(status, count));
            }
        }
        statusCountMap.entrySet().stream()
            .sorted(Map.Entry.comparingByKey())
            .forEach(entry -> slices.add(createStatusSlice(entry.getKey(), entry.getValue())));
        return slices;
    }

    private DashboardStatusSliceVO createStatusSlice(String status, Long count) {
        DashboardStatusSliceVO slice = new DashboardStatusSliceVO();
        slice.setStatus(status);
        slice.setCount(count);
        return slice;
    }
}

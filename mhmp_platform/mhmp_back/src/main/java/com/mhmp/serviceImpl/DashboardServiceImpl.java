package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.common.util.RelicBusinessRuleUtils;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.entity.RepairTask;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.service.DashboardService;
import com.mhmp.vo.DashboardHomeVO;
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
    private final RelicInboundOrderMapper relicInboundOrderMapper;
    private final RelicOutboundOrderMapper relicOutboundOrderMapper;
    private final RepairTaskMapper repairTaskMapper;
    private final InventoryTaskMapper inventoryTaskMapper;

    public DashboardServiceImpl(RelicMapper relicMapper,
                                RelicInboundOrderMapper relicInboundOrderMapper,
                                RelicOutboundOrderMapper relicOutboundOrderMapper,
                                RepairTaskMapper repairTaskMapper,
                                InventoryTaskMapper inventoryTaskMapper) {
        this.relicMapper = relicMapper;
        this.relicInboundOrderMapper = relicInboundOrderMapper;
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
        vo.setInboundPendingCount(relicInboundOrderMapper.selectCount(
            Wrappers.<RelicInboundOrder>lambdaQuery().eq(RelicInboundOrder::getStatus, "PENDING")
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

    @Override
    public DashboardHomeVO home() {
        DashboardHomeVO vo = new DashboardHomeVO();
        vo.setBadge("MHMP Operations Hub");
        vo.setTitle("博物馆文物综合管理平台");
        vo.setDescription("本系统围绕博物馆文物全生命周期管理建设，覆盖馆藏建档、库存流转、盘点核验、修复闭环、角色权限和操作留痕等核心业务，便于日常管理、业务演示和毕业答辩讲解。");
        vo.setCards(List.of(
            createHomeCard("01", "文物档案统一管理", "集中维护文物基础信息、图片资料、鉴定报告、保存状态、库位和相关附件。"),
            createHomeCard("02", "库存流转闭环", "支持入库、出库、归还、馆内转存和盘点任务，保证文物流向清晰可追踪。"),
            createHomeCard("03", "修复过程可追溯", "覆盖修复申请、审批、过程记录、验收和历史归档，便于演示完整业务链路。"),
            createHomeCard("04", "权限与日志联动", "基于角色、菜单和按钮权限控制功能入口，并通过操作日志记录关键业务行为。")
        ));
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
        List<String> preferredOrder = List.of("TO_BE_INBOUND", "INBOUND_PENDING", "IN_STOCK", "OUTBOUND_PENDING", "IN_REPAIR", "OUT_STOCK");
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

    private DashboardHomeVO.HomeCardVO createHomeCard(String orderNo, String title, String description) {
        DashboardHomeVO.HomeCardVO card = new DashboardHomeVO.HomeCardVO();
        card.setOrderNo(orderNo);
        card.setTitle(title);
        card.setDescription(description);
        return card;
    }
}

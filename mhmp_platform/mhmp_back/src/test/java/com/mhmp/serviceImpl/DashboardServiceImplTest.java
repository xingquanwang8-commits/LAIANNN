package com.mhmp.serviceImpl;

import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.vo.DashboardSummaryVO;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DashboardServiceImplTest {

    @Mock
    private RelicMapper relicMapper;
    @Mock
    private RelicInboundOrderMapper relicInboundOrderMapper;
    @Mock
    private RelicOutboundOrderMapper relicOutboundOrderMapper;
    @Mock
    private RepairTaskMapper repairTaskMapper;
    @Mock
    private InventoryTaskMapper inventoryTaskMapper;

    @Test
    void summaryShouldCountWaitingAcceptanceTasks() {
        DashboardServiceImpl service = new DashboardServiceImpl(
            relicMapper,
            relicInboundOrderMapper,
            relicOutboundOrderMapper,
            repairTaskMapper,
            inventoryTaskMapper
        );

        when(relicMapper.selectCount(any())).thenReturn(12L, 9L);
        when(relicInboundOrderMapper.selectCount(any())).thenReturn(7L);
        when(relicOutboundOrderMapper.selectCount(any())).thenReturn(2L, 1L);
        when(repairTaskMapper.selectCount(any())).thenReturn(3L, 4L, 5L);
        when(inventoryTaskMapper.selectCount(any())).thenReturn(6L);
        when(relicMapper.selectList(any())).thenReturn(List.of(
            buildRelic("IN_STOCK"),
            buildRelic("INBOUND_PENDING"),
            buildRelic("OUT_STOCK")
        ));

        DashboardSummaryVO summary = service.summary();

        assertEquals(7L, summary.getInboundPendingCount());
        assertEquals(4L, summary.getRepairAcceptancePendingCount());
        assertEquals("INBOUND_PENDING", summary.getStatusDistribution().get(0).getStatus());
        assertEquals("IN_STOCK", summary.getStatusDistribution().get(1).getStatus());
    }

    private Relic buildRelic(String currentStatus) {
        Relic relic = new Relic();
        relic.setCurrentStatus(currentStatus);
        return relic;
    }
}

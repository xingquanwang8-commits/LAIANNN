package com.mhmp.serviceImpl;

import com.mhmp.entity.Relic;
import com.mhmp.entity.RepairTask;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicAttachmentMapper;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.SysDictItemMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.vo.RelicDetailVO;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RelicServiceImplTest {

    @Mock
    private RelicMapper relicMapper;
    @Mock
    private RelicAttachmentMapper relicAttachmentMapper;
    @Mock
    private RelicInboundDetailMapper relicInboundDetailMapper;
    @Mock
    private RelicInboundOrderMapper relicInboundOrderMapper;
    @Mock
    private RelicOutboundDetailMapper relicOutboundDetailMapper;
    @Mock
    private RelicOutboundOrderMapper relicOutboundOrderMapper;
    @Mock
    private InventoryTaskDetailMapper inventoryTaskDetailMapper;
    @Mock
    private InventoryTaskMapper inventoryTaskMapper;
    @Mock
    private RepairTaskMapper repairTaskMapper;
    @Mock
    private RepairLogMapper repairLogMapper;
    @Mock
    private RepairAcceptanceMapper repairAcceptanceMapper;
    @Mock
    private SysDictItemMapper sysDictItemMapper;
    @Mock
    private BusinessNoService businessNoService;

    @Test
    void detailShouldExposeWaitingAcceptanceTaskInPendingBusinessesAndTimeline() {
        RelicServiceImpl service = new RelicServiceImpl(
            relicMapper,
            relicAttachmentMapper,
            relicInboundDetailMapper,
            relicInboundOrderMapper,
            relicOutboundDetailMapper,
            relicOutboundOrderMapper,
            inventoryTaskDetailMapper,
            inventoryTaskMapper,
            repairTaskMapper,
            repairLogMapper,
            repairAcceptanceMapper,
            sysDictItemMapper,
            businessNoService
        );

        Relic relic = new Relic();
        relic.setId(1L);
        relic.setRelicNo("REL-2026-100");
        relic.setName("青铜镜");
        relic.setCurrentStatus("IN_REPAIR");
        relic.setCreateTime(LocalDateTime.now().minusDays(20));

        RepairTask task = new RepairTask();
        task.setId(10L);
        task.setRelicId(1L);
        task.setTaskNo("REP-2026-100");
        task.setApplyReason("镜面病害修复");
        task.setTaskStatus("COMPLETED");
        task.setAcceptanceStatus("WAITING");
        task.setApplyTime(LocalDateTime.now().minusDays(10));
        task.setEndTime(LocalDateTime.now().minusDays(1));

        when(relicMapper.selectById(1L)).thenReturn(relic);
        when(relicAttachmentMapper.selectList(any())).thenReturn(List.of());
        when(relicInboundDetailMapper.selectList(any())).thenReturn(List.of());
        when(relicOutboundDetailMapper.selectList(any())).thenReturn(List.of());
        when(inventoryTaskDetailMapper.selectList(any())).thenReturn(List.of());
        when(repairTaskMapper.selectList(any())).thenReturn(List.of(task));
        when(repairLogMapper.selectList(any())).thenReturn(List.of());
        when(repairAcceptanceMapper.selectList(any())).thenReturn(List.of());

        RelicDetailVO detail = service.detail(1L);

        assertEquals(1, detail.getPendingBusinesses().size());
        assertEquals("REPAIR_ACCEPTANCE", detail.getPendingBusinesses().get(0).getBusinessType());
        assertEquals("WAITING", detail.getPendingBusinesses().get(0).getStatus());
        assertTrue(detail.getBusinessTimeline().stream().anyMatch(item ->
            "REPAIR_COMPLETE".equals(item.getEventType()) && "WAITING".equals(item.getStatus())));
        verify(relicInboundDetailMapper).selectList(any());
        verify(relicOutboundDetailMapper).selectList(any());
        verify(inventoryTaskDetailMapper).selectList(any());
        verify(repairTaskMapper).selectList(any());
    }
}

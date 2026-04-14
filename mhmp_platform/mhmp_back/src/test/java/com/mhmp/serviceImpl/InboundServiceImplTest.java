package com.mhmp.serviceImpl;

import com.mhmp.common.security.LoginUser;
import com.mhmp.dto.InboundCreateDTO;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundDetail;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.service.BusinessNoService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class InboundServiceImplTest {

    @Mock
    private RelicInboundOrderMapper relicInboundOrderMapper;
    @Mock
    private RelicInboundDetailMapper relicInboundDetailMapper;
    @Mock
    private RelicMapper relicMapper;
    @Mock
    private BusinessNoService businessNoService;

    private InboundServiceImpl inboundService;

    @BeforeEach
    void setUp() {
        inboundService = new InboundServiceImpl(
            relicInboundOrderMapper,
            relicInboundDetailMapper,
            relicMapper,
            businessNoService
        );
        LoginUser loginUser = LoginUser.builder()
            .id(101L)
            .username("admin")
            .password("secret")
            .enabled(true)
            .authorities(List.of())
            .build();
        SecurityContextHolder.getContext().setAuthentication(
            new UsernamePasswordAuthenticationToken(loginUser, null, loginUser.getAuthorities())
        );
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void createShouldMoveRelicsToInboundPending() {
        Relic relicOne = buildRelic(1L, "REL-20260408-001", "青铜簋", "TO_BE_INBOUND");
        Relic relicTwo = buildRelic(2L, "REL-20260408-002", "玉璧", "TO_BE_INBOUND");

        InboundCreateDTO dto = new InboundCreateDTO();
        dto.setSource("征集移交");
        dto.setInboundTime(LocalDateTime.of(2026, 4, 8, 10, 0));
        dto.setStorageLocationCode("LOC_B");
        dto.setRemark("待审批入库");
        dto.setRelicIds(List.of(1L, 2L));

        when(relicMapper.selectBatchIds(List.of(1L, 2L))).thenReturn(List.of(relicOne, relicTwo));
        when(businessNoService.nextInboundOrderNo()).thenReturn("IN-20260408-010");
        when(businessNoService.nextInboundBatchNo()).thenReturn("BATCH-20260408-010");

        inboundService.create(dto);

        ArgumentCaptor<RelicInboundOrder> orderCaptor = ArgumentCaptor.forClass(RelicInboundOrder.class);
        verify(relicInboundOrderMapper).insert(orderCaptor.capture());
        verify(relicInboundDetailMapper, org.mockito.Mockito.times(2)).insert(any(RelicInboundDetail.class));
        verify(relicMapper).updateById(relicOne);
        verify(relicMapper).updateById(relicTwo);

        assertEquals("PENDING", orderCaptor.getValue().getStatus());
        assertEquals("admin", orderCaptor.getValue().getHandlerName());
        assertEquals("INBOUND_PENDING", relicOne.getCurrentStatus());
        assertEquals("INBOUND_PENDING", relicTwo.getCurrentStatus());
        assertEquals("LOC_B", relicOne.getStorageLocationCode());
        assertEquals("LOC_B", relicTwo.getStorageLocationCode());
    }

    @Test
    void approveShouldMoveRelicsToInStock() {
        RelicInboundOrder order = new RelicInboundOrder();
        order.setId(1L);
        order.setStatus("PENDING");

        RelicInboundDetail detailOne = new RelicInboundDetail();
        detailOne.setOrderId(1L);
        detailOne.setRelicId(11L);
        RelicInboundDetail detailTwo = new RelicInboundDetail();
        detailTwo.setOrderId(1L);
        detailTwo.setRelicId(12L);

        Relic relicOne = buildRelic(11L, "REL-20260408-011", "木俑", "INBOUND_PENDING");
        Relic relicTwo = buildRelic(12L, "REL-20260408-012", "陶罐", "INBOUND_PENDING");

        when(relicInboundOrderMapper.selectById(1L)).thenReturn(order);
        when(relicInboundDetailMapper.selectList(any())).thenReturn(List.of(detailOne, detailTwo));
        when(relicMapper.selectBatchIds(List.of(11L, 12L))).thenReturn(List.of(relicOne, relicTwo));

        inboundService.approve(1L);

        verify(relicInboundOrderMapper).updateById(order);
        verify(relicMapper).updateById(relicOne);
        verify(relicMapper).updateById(relicTwo);

        assertEquals("APPROVED", order.getStatus());
        assertEquals("IN_STOCK", relicOne.getCurrentStatus());
        assertEquals("IN_STOCK", relicTwo.getCurrentStatus());
        verify(relicMapper, never()).selectById(11L);
        verify(relicMapper, never()).selectById(12L);
    }

    private Relic buildRelic(Long id, String relicNo, String name, String currentStatus) {
        Relic relic = new Relic();
        relic.setId(id);
        relic.setRelicNo(relicNo);
        relic.setName(name);
        relic.setCurrentStatus(currentStatus);
        relic.setStorageLocationCode("LOC_A");
        relic.setPreservationStatusCode("BASIC_COMPLETE");
        return relic;
    }
}

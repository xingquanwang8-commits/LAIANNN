package com.mhmp.serviceImpl;

import com.mhmp.common.security.LoginUser;
import com.mhmp.dto.OutboundApproveDTO;
import com.mhmp.dto.OutboundReturnDTO;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicOutboundDetail;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.service.BusinessNoService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
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
class OutboundServiceImplTest {

    @Mock
    private RelicOutboundOrderMapper relicOutboundOrderMapper;
    @Mock
    private RelicOutboundDetailMapper relicOutboundDetailMapper;
    @Mock
    private RelicMapper relicMapper;
    @Mock
    private BusinessNoService businessNoService;

    private OutboundServiceImpl outboundService;

    @BeforeEach
    void setUp() {
        outboundService = new OutboundServiceImpl(
            relicOutboundOrderMapper,
            relicOutboundDetailMapper,
            relicMapper,
            businessNoService
        );
        LoginUser loginUser = LoginUser.builder()
            .id(101L)
            .username("approver")
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
    void approveShouldUpdateOrderAndRelicStatus() {
        RelicOutboundOrder order = new RelicOutboundOrder();
        order.setId(1L);
        order.setApproveStatus("PENDING");

        RelicOutboundDetail detail = new RelicOutboundDetail();
        detail.setOrderId(1L);
        detail.setRelicId(11L);

        Relic relic = new Relic();
        relic.setId(11L);
        relic.setRelicNo("REL-2026-010");
        relic.setName("bronze");
        relic.setCurrentStatus("OUTBOUND_PENDING");

        when(relicOutboundOrderMapper.selectById(1L)).thenReturn(order);
        when(relicOutboundDetailMapper.selectList(any())).thenReturn(List.of(detail));
        when(relicMapper.selectBatchIds(any())).thenReturn(List.of(relic));

        OutboundApproveDTO dto = new OutboundApproveDTO();
        dto.setApproveRemark("approved");
        outboundService.approve(1L, dto);

        assertEquals("APPROVED", order.getApproveStatus());
        assertEquals("OUT_STOCK", relic.getCurrentStatus());
        verify(relicOutboundOrderMapper).updateById(order);
        verify(relicMapper).updateById(relic);
        verify(relicMapper, never()).selectById(11L);
    }

    @Test
    void returnOrderShouldUpdateOrderAndRelicStatus() {
        RelicOutboundOrder order = new RelicOutboundOrder();
        order.setId(2L);
        order.setApproveStatus("APPROVED");

        RelicOutboundDetail detail = new RelicOutboundDetail();
        detail.setOrderId(2L);
        detail.setRelicId(12L);

        Relic relic = new Relic();
        relic.setId(12L);
        relic.setRelicNo("REL-2026-011");
        relic.setName("pottery");
        relic.setCurrentStatus("OUT_STOCK");

        when(relicOutboundOrderMapper.selectById(2L)).thenReturn(order);
        when(relicOutboundDetailMapper.selectList(any())).thenReturn(List.of(detail));
        when(relicMapper.selectBatchIds(any())).thenReturn(List.of(relic));

        OutboundReturnDTO dto = new OutboundReturnDTO();
        dto.setReturnTime(LocalDateTime.now());
        dto.setRemark("returned");
        outboundService.returnOrder(2L, dto);

        assertEquals("RETURNED", order.getApproveStatus());
        assertEquals("IN_STOCK", relic.getCurrentStatus());
        verify(relicOutboundOrderMapper).updateById(order);
        verify(relicMapper).updateById(relic);
        verify(relicMapper, never()).selectById(12L);
    }
}

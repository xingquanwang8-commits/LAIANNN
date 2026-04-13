package com.mhmp.serviceImpl;

import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.security.LoginUser;
import com.mhmp.dto.RepairAcceptanceDTO;
import com.mhmp.dto.RepairApproveDTO;
import com.mhmp.entity.RepairAcceptance;
import com.mhmp.entity.RepairPlan;
import com.mhmp.entity.RepairTask;
import com.mhmp.entity.Relic;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairPlanMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicAttachmentMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.SysUserMapper;
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
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RepairServiceImplTest {

    @Mock
    private RepairTaskMapper repairTaskMapper;
    @Mock
    private RepairPlanMapper repairPlanMapper;
    @Mock
    private RepairLogMapper repairLogMapper;
    @Mock
    private RepairAcceptanceMapper repairAcceptanceMapper;
    @Mock
    private RelicMapper relicMapper;
    @Mock
    private RelicAttachmentMapper relicAttachmentMapper;
    @Mock
    private SysUserMapper sysUserMapper;
    @Mock
    private BusinessNoService businessNoService;

    private RepairServiceImpl repairService;

    @BeforeEach
    void setUp() {
        repairService = new RepairServiceImpl(
            repairTaskMapper,
            repairPlanMapper,
            repairLogMapper,
            repairAcceptanceMapper,
            relicMapper,
            relicAttachmentMapper,
            sysUserMapper,
            businessNoService
        );
        LoginUser loginUser = LoginUser.builder()
            .id(102L)
            .username("researcher")
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
    void approveShouldOnlyUpdateTaskWhenApproved() {
        RepairTask task = new RepairTask();
        task.setId(1L);
        task.setRelicId(20L);
        task.setApplyUserId(201L);
        task.setTaskStatus("APPLIED");
        task.setAcceptanceStatus("UNACCEPTED");

        Relic relic = new Relic();
        relic.setId(20L);
        relic.setRelicNo("REL-2026-020");
        relic.setName("scroll");
        relic.setCurrentStatus("IN_STOCK");
        relic.setPreservationStatusCode("PHYSICAL_DAMAGE");

        when(repairTaskMapper.selectById(1L)).thenReturn(task);
        when(relicMapper.selectById(20L)).thenReturn(relic);

        RepairApproveDTO dto = new RepairApproveDTO();
        dto.setApproveResult("APPROVED");
        dto.setApproveRemark("ok");

        repairService.approve(1L, dto);

        verify(repairTaskMapper).updateById(task);
        verify(repairPlanMapper, never()).insert(any(RepairPlan.class));
        verify(repairPlanMapper, never()).updateById(any(RepairPlan.class));

        assertEquals("APPROVED", task.getTaskStatus());
        assertEquals("UNACCEPTED", task.getAcceptanceStatus());
    }

    @Test
    void applyAcceptanceShouldMoveTaskToWaitingStatus() {
        RepairTask task = new RepairTask();
        task.setId(1L);
        task.setRelicId(21L);
        task.setTaskStatus("COMPLETED");
        task.setAcceptanceStatus("UNACCEPTED");

        Relic relic = new Relic();
        relic.setId(21L);
        relic.setRelicNo("REL-2026-021");
        relic.setName("vase");
        relic.setCurrentStatus("IN_REPAIR");

        when(repairTaskMapper.selectById(1L)).thenReturn(task);
        when(relicMapper.selectById(21L)).thenReturn(relic);

        repairService.applyAcceptance(1L);

        verify(repairTaskMapper).updateById(task);
        assertEquals("COMPLETED", task.getTaskStatus());
        assertEquals("WAITING", task.getAcceptanceStatus());
    }

    @Test
    void acceptShouldReturnRelicToStockWhenPassed() {
        RepairTask task = new RepairTask();
        task.setId(2L);
        task.setRelicId(21L);
        task.setTaskStatus("COMPLETED");
        task.setAcceptanceStatus("WAITING");

        Relic relic = new Relic();
        relic.setId(21L);
        relic.setRelicNo("REL-2026-021");
        relic.setName("vase");
        relic.setCurrentStatus("IN_REPAIR");
        relic.setPreservationStatusCode("PHYSICAL_DAMAGE");
        relic.setStorageLocationCode("LOC_R");

        when(repairTaskMapper.selectById(2L)).thenReturn(task);
        when(relicMapper.selectById(21L)).thenReturn(relic);
        when(repairAcceptanceMapper.selectOne(any())).thenReturn(null);
        when(businessNoService.nextRepairAcceptanceNo()).thenReturn("ACC-20260408-001");

        RepairAcceptanceDTO dto = new RepairAcceptanceDTO();
        dto.setAcceptanceResult("PASS");
        dto.setAcceptanceTime(LocalDateTime.now());
        dto.setAcceptanceRemark("pass");
        dto.setPreservationStatusCode("BASIC_COMPLETE");
        dto.setStorageLocationCode("LOC_A");

        repairService.accept(2L, dto);

        ArgumentCaptor<RepairAcceptance> acceptanceCaptor = ArgumentCaptor.forClass(RepairAcceptance.class);
        verify(repairAcceptanceMapper).insert(acceptanceCaptor.capture());
        verify(repairTaskMapper).updateById(task);
        verify(relicMapper).updateById(relic);

        assertEquals("ACCEPTED", task.getTaskStatus());
        assertEquals("SUCCESS", task.getAcceptanceStatus());
        assertEquals("IN_STOCK", relic.getCurrentStatus());
        assertEquals("BASIC_COMPLETE", relic.getPreservationStatusCode());
        assertEquals("LOC_A", relic.getStorageLocationCode());
        assertEquals("ACC-20260408-001", acceptanceCaptor.getValue().getAcceptanceNo());
    }

    @Test
    void acceptShouldThrowWhenRejectedWithoutRemark() {
        RepairTask task = new RepairTask();
        task.setId(3L);
        task.setRelicId(22L);
        task.setTaskStatus("COMPLETED");
        task.setAcceptanceStatus("WAITING");

        Relic relic = new Relic();
        relic.setId(22L);
        relic.setRelicNo("REL-2026-022");
        relic.setName("screen");
        relic.setCurrentStatus("IN_REPAIR");

        when(repairTaskMapper.selectById(3L)).thenReturn(task);
        when(relicMapper.selectById(22L)).thenReturn(relic);

        RepairAcceptanceDTO dto = new RepairAcceptanceDTO();
        dto.setAcceptanceResult("REJECTED");
        dto.setAcceptanceTime(LocalDateTime.now());
        dto.setAcceptanceRemark("");

        assertThrows(BusinessException.class, () -> repairService.accept(3L, dto));
    }

    @Test
    void acceptShouldReturnTaskToRepairWhenRejected() {
        RepairTask task = new RepairTask();
        task.setId(4L);
        task.setRelicId(23L);
        task.setTaskStatus("COMPLETED");
        task.setAcceptanceStatus("WAITING");
        task.setEndTime(LocalDateTime.now().minusDays(1));

        Relic relic = new Relic();
        relic.setId(23L);
        relic.setRelicNo("REL-2026-023");
        relic.setName("bronze mirror");
        relic.setCurrentStatus("IN_REPAIR");

        when(repairTaskMapper.selectById(4L)).thenReturn(task);
        when(relicMapper.selectById(23L)).thenReturn(relic);
        when(repairAcceptanceMapper.selectOne(any())).thenReturn(null);
        when(businessNoService.nextRepairAcceptanceNo()).thenReturn("ACC-20260408-002");

        RepairAcceptanceDTO dto = new RepairAcceptanceDTO();
        dto.setAcceptanceResult("REJECTED");
        dto.setAcceptanceTime(LocalDateTime.now());
        dto.setAcceptanceRemark("存在拼接缝隙，需要继续修复");

        repairService.accept(4L, dto);

        verify(repairTaskMapper).updateById(task);
        verify(relicMapper).updateById(relic);
        assertEquals("IN_PROGRESS", task.getTaskStatus());
        assertEquals("REJECTED", task.getAcceptanceStatus());
        assertNull(task.getEndTime());
        assertEquals("IN_REPAIR", relic.getCurrentStatus());
    }
}

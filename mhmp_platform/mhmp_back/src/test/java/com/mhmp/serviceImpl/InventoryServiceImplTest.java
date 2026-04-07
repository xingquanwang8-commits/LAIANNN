package com.mhmp.serviceImpl;

import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.security.LoginUser;
import com.mhmp.dto.InventoryTaskDetailUpdateDTO;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.service.BusinessNoService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class InventoryServiceImplTest {

    @Mock
    private RelicMapper relicMapper;
    @Mock
    private InventoryTaskMapper inventoryTaskMapper;
    @Mock
    private InventoryTaskDetailMapper inventoryTaskDetailMapper;
    @Mock
    private BusinessNoService businessNoService;

    private InventoryServiceImpl inventoryService;

    @BeforeEach
    void setUp() {
        inventoryService = new InventoryServiceImpl(relicMapper, inventoryTaskMapper, inventoryTaskDetailMapper, businessNoService);
        LoginUser loginUser = LoginUser.builder()
            .id(100L)
            .username("tester")
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
    void updateTaskDetailShouldSwitchTaskToInProgressAndCalculateDiff() {
        InventoryTask task = new InventoryTask();
        task.setId(1L);
        task.setTaskStatus("CREATED");

        InventoryTaskDetail detail = new InventoryTaskDetail();
        detail.setId(2L);
        detail.setTaskId(1L);
        detail.setSystemQuantity(1);
        detail.setResultStatus("PENDING");

        InventoryTaskDetailUpdateDTO updateDTO = new InventoryTaskDetailUpdateDTO();
        updateDTO.setActualQuantity(0);
        updateDTO.setDiffRemark("missing");

        when(inventoryTaskMapper.selectById(1L)).thenReturn(task);
        when(inventoryTaskDetailMapper.selectById(2L)).thenReturn(detail);

        inventoryService.updateTaskDetail(1L, 2L, updateDTO);

        assertEquals("IN_PROGRESS", task.getTaskStatus());
        assertEquals(Integer.valueOf(0), detail.getActualQuantity());
        assertEquals(Integer.valueOf(-1), detail.getDiffQuantity());
        assertEquals("DIFF_FOUND", detail.getResultStatus());
        verify(inventoryTaskDetailMapper).updateById(detail);
        verify(inventoryTaskMapper).updateById(task);
    }

    @Test
    void updateTaskDetailShouldRejectNegativeActualQuantity() {
        InventoryTask task = new InventoryTask();
        task.setId(1L);
        task.setTaskStatus("IN_PROGRESS");

        InventoryTaskDetail detail = new InventoryTaskDetail();
        detail.setId(2L);
        detail.setTaskId(1L);
        detail.setSystemQuantity(1);

        InventoryTaskDetailUpdateDTO updateDTO = new InventoryTaskDetailUpdateDTO();
        updateDTO.setActualQuantity(-1);

        when(inventoryTaskMapper.selectById(1L)).thenReturn(task);
        when(inventoryTaskDetailMapper.selectById(2L)).thenReturn(detail);

        assertThrows(BusinessException.class, () -> inventoryService.updateTaskDetail(1L, 2L, updateDTO));
        verify(inventoryTaskDetailMapper, never()).updateById(detail);
        verify(inventoryTaskMapper, never()).updateById(task);
    }
}

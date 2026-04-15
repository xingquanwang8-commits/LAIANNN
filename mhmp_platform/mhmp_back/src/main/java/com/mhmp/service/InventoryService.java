package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.InventoryQueryPageDTO;
import com.mhmp.dto.InventoryTaskCreateDTO;
import com.mhmp.dto.InventoryTaskDetailUpdateDTO;
import com.mhmp.dto.InventoryTaskPageQueryDTO;
import com.mhmp.vo.InventorySummaryVO;
import com.mhmp.vo.InventoryTaskDetailVO;
import com.mhmp.vo.InventoryTaskListVO;
import com.mhmp.vo.InventoryTaskPrincipalVO;
import com.mhmp.vo.RelicListVO;

import java.util.List;

public interface InventoryService {

    InventorySummaryVO summary();

    PageResponse<RelicListVO> queryPage(InventoryQueryPageDTO queryDTO);

    PageResponse<InventoryTaskListVO> taskPage(InventoryTaskPageQueryDTO queryDTO);

    InventoryTaskDetailVO taskDetail(Long id);

    List<InventoryTaskPrincipalVO> taskPrincipals();

    Long createTask(InventoryTaskCreateDTO createDTO);

    void updateTaskDetail(Long taskId, Long detailId, InventoryTaskDetailUpdateDTO updateDTO);

    void submitTask(Long taskId);
}

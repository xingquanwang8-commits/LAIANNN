package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.TransferTaskBatchCreateDTO;
import com.mhmp.dto.TransferTaskConfirmDTO;
import com.mhmp.dto.TransferTaskCreateDTO;
import com.mhmp.dto.TransferTaskPageQueryDTO;
import com.mhmp.vo.TransferTaskDetailVO;
import com.mhmp.vo.TransferTaskListVO;
import com.mhmp.vo.TransferTaskPrincipalVO;

import java.util.List;

public interface TransferTaskService {

    List<TransferTaskPrincipalVO> taskPrincipals();

    Long createTask(TransferTaskCreateDTO createDTO);

    List<Long> createBatchTasks(TransferTaskBatchCreateDTO createDTO);

    PageResponse<TransferTaskListVO> myTaskPage(TransferTaskPageQueryDTO queryDTO);

    TransferTaskDetailVO taskDetail(Long id);

    void confirmTask(Long id, TransferTaskConfirmDTO confirmDTO);
}

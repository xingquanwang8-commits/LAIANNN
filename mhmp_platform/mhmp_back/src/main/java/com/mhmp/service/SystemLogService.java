package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.LogPageQueryDTO;
import com.mhmp.vo.OperationLogDetailVO;
import com.mhmp.vo.OperationLogListVO;

public interface SystemLogService {

    PageResponse<OperationLogListVO> page(LogPageQueryDTO queryDTO);

    OperationLogDetailVO detail(Long id);
}

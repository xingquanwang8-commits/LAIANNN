package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.OutboundApproveDTO;
import com.mhmp.dto.OutboundCreateDTO;
import com.mhmp.dto.OutboundPageQueryDTO;
import com.mhmp.dto.OutboundReturnDTO;
import com.mhmp.vo.OutboundDetailVO;
import com.mhmp.vo.OutboundListVO;

public interface OutboundService {

    PageResponse<OutboundListVO> page(OutboundPageQueryDTO queryDTO);

    OutboundDetailVO detail(Long id);

    Long create(OutboundCreateDTO createDTO);

    void approve(Long id, OutboundApproveDTO approveDTO);

    void reject(Long id, OutboundApproveDTO approveDTO);

    void returnOrder(Long id, OutboundReturnDTO returnDTO);
}

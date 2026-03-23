package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.InboundCreateDTO;
import com.mhmp.dto.InboundPageQueryDTO;
import com.mhmp.vo.InboundDetailVO;
import com.mhmp.vo.InboundListVO;

public interface InboundService {

    PageResponse<InboundListVO> page(InboundPageQueryDTO queryDTO);

    InboundDetailVO detail(Long id);

    Long create(InboundCreateDTO createDTO);
}

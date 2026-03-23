package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.RelicPageQueryDTO;
import com.mhmp.dto.RelicSaveDTO;
import com.mhmp.vo.RelicAttachmentVO;
import com.mhmp.vo.RelicDetailVO;
import com.mhmp.vo.RelicListVO;

import java.util.List;

public interface RelicService {

    PageResponse<RelicListVO> page(RelicPageQueryDTO queryDTO);

    RelicDetailVO detail(Long id);

    Long create(RelicSaveDTO saveDTO);

    void update(Long id, RelicSaveDTO saveDTO);

    void delete(Long id);

    List<RelicAttachmentVO> listAttachments(Long relicId);
}

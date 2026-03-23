package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.DictImportDTO;
import com.mhmp.dto.DictItemSaveDTO;
import com.mhmp.dto.DictTypePageQueryDTO;
import com.mhmp.dto.DictTypeSaveDTO;
import com.mhmp.vo.DictItemVO;
import com.mhmp.vo.DictTypeVO;

import java.util.List;

public interface DictService {

    List<DictTypeVO> listTypes();

    List<DictItemVO> listItemsByType(String dictTypeCode);

    List<DictItemVO> listAllItemsByType(String dictTypeCode);

    PageResponse<DictTypeVO> pageTypes(DictTypePageQueryDTO queryDTO);

    Long createType(DictTypeSaveDTO saveDTO);

    void updateType(Long id, DictTypeSaveDTO saveDTO);

    void deleteType(Long id);

    Long createItem(DictItemSaveDTO saveDTO);

    void updateItem(Long id, DictItemSaveDTO saveDTO);

    void deleteItem(Long id);

    void importItems(DictImportDTO importDTO);
}

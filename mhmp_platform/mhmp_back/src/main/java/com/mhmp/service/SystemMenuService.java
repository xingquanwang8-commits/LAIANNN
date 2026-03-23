package com.mhmp.service;

import com.mhmp.dto.MenuSaveDTO;
import com.mhmp.vo.SystemMenuTreeVO;

import java.util.List;

public interface SystemMenuService {

    List<SystemMenuTreeVO> tree();

    SystemMenuTreeVO detail(Long id);

    Long create(MenuSaveDTO saveDTO);

    void update(Long id, MenuSaveDTO saveDTO);

    void delete(Long id);
}

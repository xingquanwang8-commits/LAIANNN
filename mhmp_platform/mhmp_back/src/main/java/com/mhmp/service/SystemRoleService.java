package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.RolePageQueryDTO;
import com.mhmp.dto.RoleSaveDTO;
import com.mhmp.vo.RoleDetailVO;
import com.mhmp.vo.RoleListVO;

import java.util.List;

public interface SystemRoleService {

    PageResponse<RoleListVO> page(RolePageQueryDTO queryDTO);

    List<RoleListVO> listAll();

    RoleDetailVO detail(Long id);

    Long create(RoleSaveDTO saveDTO);

    void update(Long id, RoleSaveDTO saveDTO);

    void delete(Long id);

    void updateStatus(Long id, String status);

    void grantMenus(Long id, List<Long> menuIds);
}

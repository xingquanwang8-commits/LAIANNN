package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.UserPageQueryDTO;
import com.mhmp.dto.UserSaveDTO;
import com.mhmp.vo.UserDetailVO;
import com.mhmp.vo.UserListVO;

public interface SystemUserService {

    PageResponse<UserListVO> page(UserPageQueryDTO queryDTO);

    UserDetailVO detail(Long id);

    Long create(UserSaveDTO saveDTO);

    void update(Long id, UserSaveDTO saveDTO);

    void delete(Long id);

    void updateStatus(Long id, String status);
}

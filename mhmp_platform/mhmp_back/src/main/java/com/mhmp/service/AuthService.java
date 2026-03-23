package com.mhmp.service;

import com.mhmp.common.security.LoginUser;
import com.mhmp.dto.LoginDTO;
import com.mhmp.vo.CurrentUserVO;
import com.mhmp.vo.LoginVO;
import com.mhmp.vo.MenuVO;

import java.util.List;

public interface AuthService {

    LoginVO login(LoginDTO loginDTO);

    void logout(String token);

    CurrentUserVO getCurrentUser();

    List<MenuVO> getCurrentMenus();

    LoginUser loadLoginUserByUsername(String username);
}

package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.R;
import com.mhmp.common.security.JwtAuthenticationFilter;
import com.mhmp.dto.LoginDTO;
import com.mhmp.service.AuthService;
import com.mhmp.vo.CurrentUserVO;
import com.mhmp.vo.LoginVO;
import com.mhmp.vo.MenuVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    @OperationLog(module = "Auth", businessType = "LOGIN", description = "User login")
    public R<LoginVO> login(@Valid @RequestBody LoginDTO loginDTO) {
        return R.success(authService.login(loginDTO));
    }

    @PostMapping("/logout")
    @OperationLog(module = "Auth", businessType = "LOGOUT", description = "User logout")
    public R<Void> logout(HttpServletRequest request) {
        authService.logout(JwtAuthenticationFilter.resolveToken(request));
        return R.success();
    }

    @GetMapping("/current-user")
    public R<CurrentUserVO> currentUser() {
        return R.success(authService.getCurrentUser());
    }

    @GetMapping("/menus")
    public R<List<MenuVO>> menus() {
        return R.success(authService.getCurrentMenus());
    }
}

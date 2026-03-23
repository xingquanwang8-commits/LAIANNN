package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.Result;
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
    public Result<LoginVO> login(@Valid @RequestBody LoginDTO loginDTO) {
        return Result.success(authService.login(loginDTO));
    }

    @PostMapping("/logout")
    @OperationLog(module = "Auth", businessType = "LOGOUT", description = "User logout")
    public Result<Void> logout(HttpServletRequest request) {
        authService.logout(JwtAuthenticationFilter.resolveToken(request));
        return Result.success();
    }

    @GetMapping("/current-user")
    public Result<CurrentUserVO> currentUser() {
        return Result.success(authService.getCurrentUser());
    }

    @GetMapping("/menus")
    public Result<List<MenuVO>> menus() {
        return Result.success(authService.getCurrentMenus());
    }
}

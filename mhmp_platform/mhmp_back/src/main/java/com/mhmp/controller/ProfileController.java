package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.R;
import com.mhmp.common.security.JwtAuthenticationFilter;
import com.mhmp.dto.PasswordUpdateDTO;
import com.mhmp.dto.ProfileUpdateDTO;
import com.mhmp.service.ProfileService;
import com.mhmp.vo.ProfileVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/profile")
public class ProfileController {

    private final ProfileService profileService;

    public ProfileController(ProfileService profileService) {
        this.profileService = profileService;
    }

    @GetMapping
    @PreAuthorize("hasAuthority('profile:view')")
    public R<ProfileVO> profile() {
        return R.success(profileService.getProfile());
    }

    @PutMapping
    @PreAuthorize("hasAuthority('profile:view')")
    @OperationLog(module = "个人中心", businessType = "UPDATE", description = "更新个人资料")
    public R<Void> updateProfile(@RequestBody ProfileUpdateDTO updateDTO) {
        profileService.updateProfile(updateDTO);
        return R.success();
    }

    @PutMapping("/password")
    @PreAuthorize("hasAuthority('profile:view')")
    @OperationLog(module = "个人中心", businessType = "UPDATE", description = "修改个人密码")
    public R<Void> updatePassword(HttpServletRequest request, @Valid @RequestBody PasswordUpdateDTO updateDTO) {
        profileService.updatePassword(JwtAuthenticationFilter.resolveToken(request), updateDTO);
        return R.success();
    }
}

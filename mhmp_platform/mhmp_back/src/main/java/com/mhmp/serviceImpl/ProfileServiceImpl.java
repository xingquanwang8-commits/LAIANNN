package com.mhmp.serviceImpl;

import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.security.RedisSessionService;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.PasswordUpdateDTO;
import com.mhmp.dto.ProfileUpdateDTO;
import com.mhmp.entity.SysUser;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.service.ProfileService;
import com.mhmp.vo.ProfileVO;
import org.springframework.beans.BeanUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class ProfileServiceImpl implements ProfileService {

    private final SysUserMapper sysUserMapper;
    private final PasswordEncoder passwordEncoder;
    private final RedisSessionService redisSessionService;

    public ProfileServiceImpl(SysUserMapper sysUserMapper,
                              PasswordEncoder passwordEncoder,
                              RedisSessionService redisSessionService) {
        this.sysUserMapper = sysUserMapper;
        this.passwordEncoder = passwordEncoder;
        this.redisSessionService = redisSessionService;
    }

    @Override
    public ProfileVO getProfile() {
        SysUser user = getCurrentUser();
        ProfileVO vo = new ProfileVO();
        BeanUtils.copyProperties(user, vo);
        vo.setRoles(sysUserMapper.selectRoleCodesByUserId(user.getId()));
        return vo;
    }

    @Override
    public void updateProfile(ProfileUpdateDTO updateDTO) {
        SysUser user = getCurrentUser();
        user.setNickName(updateDTO.getNickName());
        user.setRealName(updateDTO.getRealName());
        user.setPhone(updateDTO.getPhone());
        user.setEmail(updateDTO.getEmail());
        user.setGender(updateDTO.getGender());
        user.setAvatarUrl(updateDTO.getAvatarUrl());
        user.setRemark(updateDTO.getRemark());
        user.setUpdateBy(user.getId());
        sysUserMapper.updateById(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePassword(String token, PasswordUpdateDTO updateDTO) {
        SysUser user = getCurrentUser();
        if (!passwordEncoder.matches(updateDTO.getOldPassword(), user.getPassword())) {
            throw new BusinessException("Old password is incorrect");
        }
        user.setPassword(passwordEncoder.encode(updateDTO.getNewPassword()));
        user.setUpdateBy(user.getId());
        sysUserMapper.updateById(user);
        if (StringUtils.hasText(token)) {
            redisSessionService.deleteToken(token);
        }
    }

    private SysUser getCurrentUser() {
        Long userId = SecurityUtils.getUserId();
        SysUser user = userId == null ? null : sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(401, "Current user is not logged in");
        }
        return user;
    }
}

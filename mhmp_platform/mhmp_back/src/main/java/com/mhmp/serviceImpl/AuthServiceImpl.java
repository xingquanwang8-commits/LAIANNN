package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.security.JwtProperties;
import com.mhmp.common.security.JwtTokenProvider;
import com.mhmp.common.security.LoginUser;
import com.mhmp.common.security.RedisSessionService;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.LoginDTO;
import com.mhmp.entity.SysMenu;
import com.mhmp.entity.SysUser;
import com.mhmp.mapper.SysMenuMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.service.AuthService;
import com.mhmp.vo.CurrentUserVO;
import com.mhmp.vo.LoginVO;
import com.mhmp.vo.MenuVO;
import org.springframework.beans.BeanUtils;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class AuthServiceImpl implements AuthService {

    private final SysUserMapper sysUserMapper;
    private final SysMenuMapper sysMenuMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final JwtProperties jwtProperties;
    private final RedisSessionService redisSessionService;

    public AuthServiceImpl(SysUserMapper sysUserMapper,
                           SysMenuMapper sysMenuMapper,
                           PasswordEncoder passwordEncoder,
                           JwtTokenProvider jwtTokenProvider,
                           JwtProperties jwtProperties,
                           RedisSessionService redisSessionService) {
        this.sysUserMapper = sysUserMapper;
        this.sysMenuMapper = sysMenuMapper;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
        this.jwtProperties = jwtProperties;
        this.redisSessionService = redisSessionService;
    }

    @Override
    public LoginVO login(LoginDTO loginDTO) {
        SysUser user = sysUserMapper.findByUsername(loginDTO.getUsername());
        if (user == null || !"ENABLED".equals(user.getStatus())) {
            throw new BusinessException(401, "用户名或密码错误");
        }
        if (!matchesPassword(loginDTO.getPassword(), user.getPassword())) {
            throw new BusinessException(401, "用户名或密码错误");
        }
        user.setLastLoginTime(LocalDateTime.now());
        user.setUpdateBy(user.getId());
        sysUserMapper.updateById(user);

        String token = jwtTokenProvider.generateToken(user.getId(), user.getUsername());
        redisSessionService.saveToken(token, user.getId());
        return LoginVO.builder()
            .token(token)
            .tokenType("Bearer")
            .expireSeconds(jwtProperties.getExpireSeconds())
            .build();
    }

    @Override
    public void logout(String token) {
        if (StringUtils.hasText(token)) {
            redisSessionService.deleteToken(token);
        }
    }

    @Override
    public CurrentUserVO getCurrentUser() {
        LoginUser loginUser = requireLoginUser();
        SysUser user = sysUserMapper.selectById(loginUser.getId());
        if (user == null) {
            throw new BusinessException(401, "当前登录用户不存在");
        }
        CurrentUserVO vo = new CurrentUserVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickName(user.getNickName());
        vo.setRealName(user.getRealName());
        vo.setAvatarUrl(user.getAvatarUrl());
        vo.setRoles(sysUserMapper.selectRoleCodesByUserId(user.getId()));
        vo.setPermissions(sysUserMapper.selectPermissionCodesByUserId(user.getId()));
        return vo;
    }

    @Override
    public List<MenuVO> getCurrentMenus() {
        Long userId = requireLoginUser().getId();
        List<SysMenu> menuList = sysMenuMapper.selectMenusByUserId(userId)
            .stream()
            .filter(menu -> !"BUTTON".equals(menu.getMenuType()))
            .filter(menu -> Objects.equals(menu.getVisible(), 1))
            .toList();

        Map<Long, MenuVO> menuMap = new LinkedHashMap<>();
        for (SysMenu menu : menuList) {
            MenuVO menuVO = new MenuVO();
            BeanUtils.copyProperties(menu, menuVO);
            menuMap.put(menuVO.getId(), menuVO);
        }

        List<MenuVO> roots = new ArrayList<>();
        for (MenuVO menu : menuMap.values()) {
            if (menu.getParentId() == null || menu.getParentId() == 0L || !menuMap.containsKey(menu.getParentId())) {
                roots.add(menu);
            } else {
                menuMap.get(menu.getParentId()).getChildren().add(menu);
            }
        }
        sortMenus(roots);
        return roots;
    }

    @Override
    public LoginUser loadLoginUserByUsername(String username) {
        SysUser user = sysUserMapper.findByUsername(username);
        if (user == null || !"ENABLED".equals(user.getStatus())) {
            throw new BusinessException(401, "用户不存在或已禁用");
        }
        List<String> permissions = sysUserMapper.selectPermissionCodesByUserId(user.getId());
        return LoginUser.builder()
            .id(user.getId())
            .username(user.getUsername())
            .password(user.getPassword())
            .enabled("ENABLED".equals(user.getStatus()))
            .authorities(CollectionUtils.isEmpty(permissions) ? List.of() : permissions.stream()
                .filter(StringUtils::hasText)
                .map(SimpleGrantedAuthority::new)
                .toList())
            .build();
    }

    private LoginUser requireLoginUser() {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (loginUser == null) {
            throw new BusinessException(401, "未登录或登录已过期");
        }
        return loginUser;
    }

    private void sortMenus(List<MenuVO> menus) {
        menus.sort(Comparator.comparing(MenuVO::getSortNo, Comparator.nullsLast(Integer::compareTo)));
        for (MenuVO menu : menus) {
            sortMenus(menu.getChildren());
        }
    }

    private boolean matchesPassword(String rawPassword, String encodedPassword) {
        if (!StringUtils.hasText(encodedPassword)) {
            return false;
        }
        if (passwordEncoder.matches(rawPassword, encodedPassword)) {
            return true;
        }
        if (encodedPassword.startsWith("$2y$")) {
            return passwordEncoder.matches(rawPassword, "$2a$" + encodedPassword.substring(4));
        }
        return false;
    }
}

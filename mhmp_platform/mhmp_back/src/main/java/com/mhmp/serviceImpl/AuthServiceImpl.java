package com.mhmp.serviceImpl;

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
import java.util.Set;

@Service
public class AuthServiceImpl implements AuthService {

    private static final Map<String, String> MENU_NAME_OVERRIDES = Map.ofEntries(
        Map.entry("/relic/list", "文物列表"),
        Map.entry("/relic/create", "新增文物"),
        Map.entry("/relic/transfer", "馆内转存"),
        Map.entry("/inventory/inbound", "文物入库"),
        Map.entry("/inventory/outbound/apply", "文物出库"),
        Map.entry("/inventory/query", "库存查询"),
        Map.entry("/inventory/outbound/approve", "出库审批"),
        Map.entry("/inventory/task", "盘点任务"),
        Map.entry("/repair/apply", "待修复文物"),
        Map.entry("/repair/process", "我的修复"),
        Map.entry("/repair/history", "已修复"),
        Map.entry("/profile", "个人中心")
    );

    private static final Map<String, String> MENU_PATH_ICON_OVERRIDES = Map.ofEntries(
        Map.entry("/dashboard", "House"),
        Map.entry("/profile", "UserFilled")
    );

    private static final Map<String, String> MENU_NAME_ICON_OVERRIDES = Map.ofEntries(
        Map.entry("系统管理", "Setting"),
        Map.entry("个人中心", "UserFilled")
    );

    private static final Set<String> VIRTUAL_GROUP_NAMES = Set.of("文物管理", "库存管理", "修复管理");
    private static final Set<String> REDUNDANT_GROUP_PATHS = Set.of("/relic", "/inventory", "/repair");

    private static final List<MenuGroupDefinition> MENU_GROUP_DEFINITIONS = List.of(
        new MenuGroupDefinition(-101L, "文物管理", "Collection", 30, List.of(
            new MenuItemDefinition("/relic/list", "文物列表", "relic:list:view", "Tickets"),
            new MenuItemDefinition("/relic/create", "新增文物", "relic:add", "EditPen"),
            new MenuItemDefinition("/inventory/inbound", "文物入库", "inventory:inbound:view", "Upload"),
            new MenuItemDefinition("/inventory/outbound/apply", "文物出库", "inventory:outbound:apply:view", "Download"),
            new MenuItemDefinition("/relic/transfer", "馆内转存", "relic:edit", "RefreshRight")
        )),
        new MenuGroupDefinition(-102L, "库存管理", "Box", 40, List.of(
            new MenuItemDefinition("/inventory/query", "库存查询", "inventory:query:view", "Search"),
            new MenuItemDefinition("/inventory/outbound/approve", "出库审批", "inventory:outbound:approve:view", "CircleCheck"),
            new MenuItemDefinition("/inventory/task", "盘点任务", "inventory:task:view", "Checked")
        )),
        new MenuGroupDefinition(-103L, "修复管理", "Operation", 50, List.of(
            new MenuItemDefinition("/repair/apply", "待修复文物", "repair:apply:view", "Clock"),
            new MenuItemDefinition("/repair/approve", "修复审批", "repair:approve:view", "Document"),
            new MenuItemDefinition("/repair/process", "我的修复", "repair:process:view", "Files"),
            new MenuItemDefinition("/repair/acceptance", "修复验收", "repair:acceptance:view", "Select"),
            new MenuItemDefinition("/repair/history", "已修复", "repair:history:view", "DocumentCopy")
        ))
    );

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
            throw new BusinessException(401, "Username or password is incorrect");
        }
        if (!matchesPassword(loginDTO.getPassword(), user.getPassword())) {
            throw new BusinessException(401, "Username or password is incorrect");
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
            throw new BusinessException(401, "Current user does not exist");
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
        Set<String> permissionSet = Set.copyOf(sysUserMapper.selectPermissionCodesByUserId(userId));
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
        return buildVirtualGroups(normalizeMenus(roots), permissionSet);
    }

    @Override
    public LoginUser loadLoginUserByUsername(String username) {
        SysUser user = sysUserMapper.findByUsername(username);
        if (user == null || !"ENABLED".equals(user.getStatus())) {
            throw new BusinessException(401, "User does not exist or has been disabled");
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
            throw new BusinessException(401, "Not logged in or session expired");
        }
        return loginUser;
    }

    private void sortMenus(List<MenuVO> menus) {
        menus.sort(Comparator.comparing(MenuVO::getSortNo, Comparator.nullsLast(Integer::compareTo)));
        for (MenuVO menu : menus) {
            sortMenus(menu.getChildren());
        }
    }

    private List<MenuVO> normalizeMenus(List<MenuVO> menus) {
        return menus.stream()
            .map(this::normalizeMenu)
            .filter(Objects::nonNull)
            .toList();
    }

    private MenuVO normalizeMenu(MenuVO menu) {
        menu.setChildren(new ArrayList<>(normalizeMenus(menu.getChildren())));
        String normalizedPath = normalizePath(menu.getPath());
        if (MENU_NAME_OVERRIDES.containsKey(normalizedPath)) {
            menu.setMenuName(MENU_NAME_OVERRIDES.get(normalizedPath));
        }
        if (MENU_PATH_ICON_OVERRIDES.containsKey(normalizedPath)) {
            menu.setIcon(MENU_PATH_ICON_OVERRIDES.get(normalizedPath));
        }
        if (MENU_NAME_ICON_OVERRIDES.containsKey(menu.getMenuName())) {
            menu.setIcon(MENU_NAME_ICON_OVERRIDES.get(menu.getMenuName()));
        }
        if (!StringUtils.hasText(menu.getPath()) && menu.getChildren().isEmpty() && !StringUtils.hasText(menu.getMenuName())) {
            return null;
        }
        return menu;
    }

    private List<MenuVO> buildVirtualGroups(List<MenuVO> menus, Set<String> permissionSet) {
        Map<String, MenuVO> leafMenuMap = new LinkedHashMap<>();
        collectLeafMenus(menus, leafMenuMap);

        Set<String> groupedPaths = MENU_GROUP_DEFINITIONS.stream()
            .flatMap(definition -> definition.items().stream().map(MenuItemDefinition::path))
            .collect(java.util.stream.Collectors.toSet());

        List<MenuVO> result = new ArrayList<>();
        for (MenuVO menu : menus) {
            MenuVO pruned = pruneGroupedMenu(menu, groupedPaths);
            if (pruned != null) {
                result.add(pruned);
            }
        }

        for (MenuGroupDefinition definition : MENU_GROUP_DEFINITIONS) {
            List<MenuVO> children = new ArrayList<>();
            int childSort = 1;
            for (MenuItemDefinition item : definition.items()) {
                MenuVO source = leafMenuMap.get(item.path());
                if (source != null) {
                    MenuVO child = cloneLeafMenu(source);
                    child.setMenuName(item.menuName());
                    child.setIcon(item.icon());
                    child.setSortNo(childSort++);
                    children.add(child);
                    continue;
                }
                if (!permissionSet.contains(item.permissionCode())) {
                    continue;
                }
                MenuVO child = new MenuVO();
                child.setId(definition.id() * 10 - childSort);
                child.setParentId(definition.id());
                child.setMenuName(item.menuName());
                child.setMenuType("MENU");
                child.setPath(item.path());
                child.setIcon(item.icon());
                child.setSortNo(childSort++);
                child.setVisible(1);
                children.add(child);
            }
            if (children.isEmpty()) {
                continue;
            }
            MenuVO group = new MenuVO();
            group.setId(definition.id());
            group.setParentId(0L);
            group.setMenuName(definition.menuName());
            group.setMenuType("CATA");
            group.setSortNo(definition.sortNo());
            group.setVisible(1);
            group.setIcon(definition.icon());
            group.setChildren(new ArrayList<>(children));
            result.add(group);
        }

        sortMenus(result);
        return result;
    }

    private void collectLeafMenus(List<MenuVO> menus, Map<String, MenuVO> leafMenuMap) {
        for (MenuVO menu : menus) {
            if (StringUtils.hasText(menu.getPath()) && menu.getChildren().isEmpty()) {
                leafMenuMap.put(normalizePath(menu.getPath()), menu);
            }
            collectLeafMenus(menu.getChildren(), leafMenuMap);
        }
    }

    private MenuVO pruneGroupedMenu(MenuVO menu, Set<String> groupedPaths) {
        String normalizedPath = normalizePath(menu.getPath());
        if (StringUtils.hasText(menu.getPath()) && menu.getChildren().isEmpty() && groupedPaths.contains(normalizedPath)) {
            return null;
        }

        MenuVO cloned = cloneMenu(menu);
        List<MenuVO> children = menu.getChildren().stream()
            .map(child -> pruneGroupedMenu(child, groupedPaths))
            .filter(Objects::nonNull)
            .toList();
        cloned.setChildren(new ArrayList<>(children));

        if (!StringUtils.hasText(cloned.getPath()) && cloned.getChildren().isEmpty()) {
            return null;
        }
        if (cloned.getChildren().isEmpty()
            && (VIRTUAL_GROUP_NAMES.contains(cloned.getMenuName()) || REDUNDANT_GROUP_PATHS.contains(normalizedPath))) {
            return null;
        }
        return cloned;
    }

    private MenuVO cloneLeafMenu(MenuVO menu) {
        MenuVO cloned = cloneMenu(menu);
        cloned.setChildren(new ArrayList<>());
        return cloned;
    }

    private MenuVO cloneMenu(MenuVO menu) {
        MenuVO cloned = new MenuVO();
        BeanUtils.copyProperties(menu, cloned);
        cloned.setChildren(new ArrayList<>());
        return cloned;
    }

    private String normalizePath(String path) {
        if (!StringUtils.hasText(path)) {
            return "";
        }
        return path.startsWith("/") ? path : "/" + path;
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

    private record MenuGroupDefinition(Long id,
                                       String menuName,
                                       String icon,
                                       Integer sortNo,
                                       List<MenuItemDefinition> items) {
    }

    private record MenuItemDefinition(String path,
                                      String menuName,
                                      String permissionCode,
                                      String icon) {
    }
}

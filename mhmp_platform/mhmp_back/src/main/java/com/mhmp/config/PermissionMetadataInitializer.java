package com.mhmp.config;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.entity.SysMenu;
import com.mhmp.entity.SysRole;
import com.mhmp.entity.SysRoleMenu;
import com.mhmp.entity.SysUser;
import com.mhmp.mapper.SysMenuMapper;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysRoleMenuMapper;
import com.mhmp.mapper.SysUserMapper;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Component
@ConditionalOnProperty(prefix = "mhmp.startup", name = "init-enabled", havingValue = "true")
@Order(-1)
public class PermissionMetadataInitializer implements ApplicationRunner {

    private static final List<ButtonPermissionDefinition> BUTTON_DEFINITIONS = List.of(
        new ButtonPermissionDefinition("sys:role", "角色新增", "sys:role:add", "sys:role:add", 2, "角色管理新增权限"),
        new ButtonPermissionDefinition("sys:role", "角色编辑", "sys:role:edit", "sys:role:edit", 3, "角色管理编辑权限"),
        new ButtonPermissionDefinition("sys:role", "角色状态", "sys:role:status", "sys:role:status", 4, "角色管理状态变更权限"),
        new ButtonPermissionDefinition("sys:role", "角色删除", "sys:role:delete", "sys:role:delete", 5, "角色管理删除权限"),
        new ButtonPermissionDefinition("sys:menu", "菜单编辑", "sys:menu:edit", "sys:menu:edit", 2, "菜单管理编辑权限"),
        new ButtonPermissionDefinition("sys:menu", "菜单删除", "sys:menu:delete", "sys:menu:delete", 3, "菜单管理删除权限"),
        new ButtonPermissionDefinition("inventory:inbound", "入库审批", "inventory:inbound:approve", "inventory:inbound:approve", 0, "文物入库审批权限"),
        new ButtonPermissionDefinition("inventory:task", "盘点任务新增", "inventory:task:add", "inventory:task:add", 0, "盘点任务创建权限")
    );

    private static final Map<String, List<String>> DEFAULT_ROLE_PERMISSIONS = Map.of(
        "admin", List.of(
            "sys:role:add",
            "sys:role:edit",
            "sys:role:status",
            "sys:role:delete",
            "sys:menu:edit",
            "sys:menu:delete",
            "inventory:inbound:approve",
            "inventory:task:add"
        ),
        "researcher", List.of(
            "inventory:task:add",
            "inventory:inbound:approve"
        )
    );

    private final SysMenuMapper sysMenuMapper;
    private final SysRoleMapper sysRoleMapper;
    private final SysRoleMenuMapper sysRoleMenuMapper;
    private final SysUserMapper sysUserMapper;

    public PermissionMetadataInitializer(SysMenuMapper sysMenuMapper,
                                         SysRoleMapper sysRoleMapper,
                                         SysRoleMenuMapper sysRoleMenuMapper,
                                         SysUserMapper sysUserMapper) {
        this.sysMenuMapper = sysMenuMapper;
        this.sysRoleMapper = sysRoleMapper;
        this.sysRoleMenuMapper = sysRoleMenuMapper;
        this.sysUserMapper = sysUserMapper;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void run(ApplicationArguments args) {
        Long operatorId = resolveOperatorId();
        Map<String, SysMenu> menuMap = loadMenuMap();

        for (ButtonPermissionDefinition definition : BUTTON_DEFINITIONS) {
            ensureButtonMenu(definition, menuMap, operatorId);
        }

        Map<String, SysMenu> permissionMenuMap = loadPermissionMenuMap();
        for (Map.Entry<String, List<String>> entry : DEFAULT_ROLE_PERMISSIONS.entrySet()) {
            ensureRolePermissions(entry.getKey(), entry.getValue(), permissionMenuMap, operatorId);
        }
    }

    private void ensureButtonMenu(ButtonPermissionDefinition definition,
                                  Map<String, SysMenu> menuMap,
                                  Long operatorId) {
        SysMenu parent = menuMap.get(definition.parentMenuCode());
        if (parent == null) {
            return;
        }

        SysMenu entity = menuMap.get(definition.menuCode());
        boolean isNew = entity == null;
        if (isNew) {
            entity = new SysMenu();
            entity.setCreateBy(operatorId);
            entity.setCreateTime(LocalDateTime.now());
            entity.setDeleted(0);
        }

        entity.setParentId(parent.getId());
        entity.setMenuName(definition.menuName());
        entity.setMenuCode(definition.menuCode());
        entity.setMenuType("BUTTON");
        entity.setPath("");
        entity.setComponent("");
        entity.setPermissionCode(definition.permissionCode());
        entity.setSortNo(definition.sortNo());
        entity.setVisible(1);
        entity.setStatus("ENABLED");
        entity.setIcon("");
        entity.setKeepAlive(0);
        entity.setRemark(definition.remark());
        entity.setUpdateBy(operatorId);
        entity.setUpdateTime(LocalDateTime.now());

        if (isNew) {
            sysMenuMapper.insert(entity);
            menuMap.put(entity.getMenuCode(), entity);
            return;
        }
        sysMenuMapper.updateById(entity);
    }

    private void ensureRolePermissions(String roleCode,
                                       List<String> permissionCodes,
                                       Map<String, SysMenu> permissionMenuMap,
                                       Long operatorId) {
        SysRole role = sysRoleMapper.findByRoleCode(roleCode);
        if (role == null) {
            return;
        }

        Set<Long> existingMenuIds = sysRoleMenuMapper.selectMenuIdsByRoleId(role.getId()).stream()
            .collect(Collectors.toSet());

        for (String permissionCode : permissionCodes) {
            SysMenu menu = permissionMenuMap.get(permissionCode);
            if (menu == null || existingMenuIds.contains(menu.getId())) {
                continue;
            }
            SysRoleMenu relation = new SysRoleMenu();
            relation.setRoleId(role.getId());
            relation.setMenuId(menu.getId());
            relation.setCreateBy(operatorId);
            relation.setCreateTime(LocalDateTime.now());
            relation.setUpdateBy(operatorId);
            relation.setUpdateTime(LocalDateTime.now());
            relation.setDeleted(0);
            sysRoleMenuMapper.insert(relation);
        }
    }

    private Map<String, SysMenu> loadMenuMap() {
        return sysMenuMapper.selectList(
                Wrappers.<SysMenu>lambdaQuery()
                    .eq(SysMenu::getDeleted, 0)
            ).stream()
            .filter(menu -> menu.getMenuCode() != null && !menu.getMenuCode().isBlank())
            .collect(Collectors.toMap(SysMenu::getMenuCode, menu -> menu, (left, right) -> right, LinkedHashMap::new));
    }

    private Map<String, SysMenu> loadPermissionMenuMap() {
        return sysMenuMapper.selectList(
                Wrappers.<SysMenu>lambdaQuery()
                    .eq(SysMenu::getDeleted, 0)
                    .eq(SysMenu::getStatus, "ENABLED")
            ).stream()
            .filter(menu -> menu.getPermissionCode() != null && !menu.getPermissionCode().isBlank())
            .collect(Collectors.toMap(SysMenu::getPermissionCode, menu -> menu, (left, right) -> right, LinkedHashMap::new));
    }

    private Long resolveOperatorId() {
        SysUser user = sysUserMapper.selectOne(
            Wrappers.<SysUser>lambdaQuery()
                .eq(SysUser::getStatus, "ENABLED")
                .orderByAsc(SysUser::getId)
                .last("LIMIT 1")
        );
        return Objects.nonNull(user) ? user.getId() : 1L;
    }

    private record ButtonPermissionDefinition(String parentMenuCode,
                                              String menuName,
                                              String menuCode,
                                              String permissionCode,
                                              Integer sortNo,
                                              String remark) {
    }
}

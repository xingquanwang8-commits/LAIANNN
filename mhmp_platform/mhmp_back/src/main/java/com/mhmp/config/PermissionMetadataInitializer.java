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
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
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
        new ButtonPermissionDefinition("sys:role", "Role Create", "sys:role:add", "sys:role:add", 2, "Role create permission"),
        new ButtonPermissionDefinition("sys:role", "Role Update", "sys:role:edit", "sys:role:edit", 3, "Role update permission"),
        new ButtonPermissionDefinition("sys:role", "Role Status", "sys:role:status", "sys:role:status", 4, "Role status permission"),
        new ButtonPermissionDefinition("sys:role", "Role Delete", "sys:role:delete", "sys:role:delete", 5, "Role delete permission"),
        new ButtonPermissionDefinition("sys:menu", "Menu Update", "sys:menu:edit", "sys:menu:edit", 2, "Menu update permission"),
        new ButtonPermissionDefinition("sys:menu", "Menu Delete", "sys:menu:delete", "sys:menu:delete", 3, "Menu delete permission"),
        new ButtonPermissionDefinition("inventory:inbound-approve", "Inbound Approve", "inventory:inbound:approve", "inventory:inbound:approve", 1, "Inbound approval permission"),
        new ButtonPermissionDefinition("inventory:outbound-approve", "Outbound Approve", "inventory:outbound:approve", "inventory:outbound:approve", 1, "Outbound approval permission"),
        new ButtonPermissionDefinition("inventory:outbound-approve", "Outbound Reject", "inventory:outbound:reject", "inventory:outbound:reject", 2, "Outbound reject permission"),
        new ButtonPermissionDefinition("inventory:transfer", "Transfer Task Create", "inventory:transfer:add", "inventory:transfer:add", 1, "Transfer task create permission"),
        new ButtonPermissionDefinition("inventory:transfer:my", "Transfer Task Confirm", "inventory:transfer:confirm", "inventory:transfer:confirm", 1, "Transfer task confirm permission"),
        new ButtonPermissionDefinition("inventory:task", "Inventory Task Create", "inventory:task:add", "inventory:task:add", 0, "Inventory task create permission"),
        new ButtonPermissionDefinition("repair:approve", "Repair Plan Approve", "repair:plan:approve", "repair:plan:approve", 1, "Repair approval permission"),
        new ButtonPermissionDefinition("repair:acceptance", "Repair Acceptance Submit", "repair:acceptance:add", "repair:acceptance:add", 1, "Repair acceptance permission")
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
            "inventory:outbound:approve",
            "inventory:outbound:reject",
            "inventory:transfer:add",
            "inventory:transfer:confirm",
            "inventory:task:add",
            "repair:plan:approve",
            "repair:acceptance:add"
        ),
        "senior_researcher", List.of(
            "inventory:inbound:approve",
            "inventory:outbound:approve",
            "inventory:outbound:reject",
            "inventory:transfer:add",
            "inventory:task:add",
            "repair:plan:approve",
            "repair:acceptance:add"
        ),
        "researcher", List.of(
            "inventory:task:add",
            "inventory:transfer:confirm"
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
        Set<Long> managedMenuIds = BUTTON_DEFINITIONS.stream()
            .map(ButtonPermissionDefinition::permissionCode)
            .map(permissionMenuMap::get)
            .filter(Objects::nonNull)
            .map(SysMenu::getId)
            .collect(Collectors.toSet());
        for (Map.Entry<String, List<String>> entry : DEFAULT_ROLE_PERMISSIONS.entrySet()) {
            ensureRolePermissions(entry.getKey(), entry.getValue(), permissionMenuMap, managedMenuIds, operatorId);
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
                                       Set<Long> managedMenuIds,
                                       Long operatorId) {
        SysRole role = sysRoleMapper.findByRoleCode(roleCode);
        if (role == null) {
            return;
        }

        Set<Long> targetMenuIds = permissionCodes.stream()
            .map(permissionMenuMap::get)
            .filter(Objects::nonNull)
            .map(SysMenu::getId)
            .collect(Collectors.toSet());

        List<SysRoleMenu> relations = sysRoleMenuMapper.selectList(
            Wrappers.<SysRoleMenu>lambdaQuery().eq(SysRoleMenu::getRoleId, role.getId())
        );

        for (SysRoleMenu relation : relations) {
            if (!managedMenuIds.contains(relation.getMenuId())) {
                continue;
            }
            relation.setDeleted(targetMenuIds.contains(relation.getMenuId()) ? 0 : 1);
            relation.setUpdateBy(operatorId);
            relation.setUpdateTime(LocalDateTime.now());
            sysRoleMenuMapper.updateById(relation);
        }

        Set<Long> activeMenuIds = relations.stream()
            .filter(relation -> relation.getDeleted() != null && relation.getDeleted() == 0)
            .map(SysRoleMenu::getMenuId)
            .collect(Collectors.toSet());
        for (Long menuId : targetMenuIds) {
            if (activeMenuIds.contains(menuId)) {
                continue;
            }
            SysRoleMenu relation = new SysRoleMenu();
            relation.setRoleId(role.getId());
            relation.setMenuId(menuId);
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

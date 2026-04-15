package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.dto.RolePageQueryDTO;
import com.mhmp.entity.SysMenu;
import com.mhmp.entity.SysRole;
import com.mhmp.entity.SysRoleMenu;
import com.mhmp.entity.SysUserRole;
import com.mhmp.mapper.SysMenuMapper;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysRoleMenuMapper;
import com.mhmp.mapper.SysUserRoleMapper;
import com.mhmp.vo.RoleListVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SystemRoleServiceImplTest {

    @Mock
    private SysRoleMapper sysRoleMapper;
    @Mock
    private SysUserRoleMapper sysUserRoleMapper;
    @Mock
    private SysRoleMenuMapper sysRoleMenuMapper;
    @Mock
    private SysMenuMapper sysMenuMapper;

    private SystemRoleServiceImpl systemRoleService;

    @BeforeEach
    void setUp() {
        systemRoleService = new SystemRoleServiceImpl(
            sysRoleMapper,
            sysUserRoleMapper,
            sysRoleMenuMapper,
            sysMenuMapper
        );
    }

    @Test
    void pageShouldBatchLoadRelationCounts() {
        SysRole adminRole = buildRole(1L, "admin", "ADMIN");
        SysRole keeperRole = buildRole(2L, "keeper", "KEEPER");
        Page<SysRole> resultPage = new Page<>(1, 10);
        resultPage.setRecords(List.of(adminRole, keeperRole));
        resultPage.setTotal(2);

        when(sysRoleMapper.selectPage(any(Page.class), any())).thenReturn(resultPage);
        when(sysUserRoleMapper.selectList(any())).thenReturn(List.of(
            buildUserRole(1L),
            buildUserRole(1L),
            buildUserRole(2L)
        ));
        when(sysRoleMenuMapper.selectList(any())).thenReturn(List.of(
            buildRoleMenu(1L, 101L),
            buildRoleMenu(2L, 201L),
            buildRoleMenu(2L, 202L)
        ));

        RolePageQueryDTO queryDTO = new RolePageQueryDTO();
        var response = systemRoleService.page(queryDTO);

        assertEquals(2L, response.getTotal());
        assertEquals(2, response.getRecords().size());
        assertRoleCount(response.getRecords().get(0), 2, 1);
        assertRoleCount(response.getRecords().get(1), 1, 2);
        verify(sysUserRoleMapper, never()).countByRoleId(anyLong());
        verify(sysRoleMenuMapper, never()).selectMenuIdsByRoleId(anyLong());
    }

    @Test
    void grantMenusShouldReuseExistingRelationsInsteadOfReinsertingDuplicates() {
        SysRole role = buildRole(1L, "senior_researcher", "SENIOR_RESEARCHER");
        when(sysRoleMapper.selectById(1L)).thenReturn(role);
        when(sysRoleMenuMapper.selectAllByRoleId(1L)).thenReturn(List.of(
            buildRoleMenu(1L, 101L, 0),
            buildRoleMenu(1L, 102L, 0),
            buildRoleMenu(1L, 103L, 1)
        ));
        when(sysMenuMapper.selectBatchIds(List.of(101L, 103L, 104L))).thenReturn(List.of(
            buildMenu(101L),
            buildMenu(103L),
            buildMenu(104L)
        ));

        systemRoleService.grantMenus(1L, Arrays.asList(101L, 103L, 104L, 104L, null));

        verify(sysRoleMenuMapper).updateDeletedStatus(1L, 102L, 1, null);
        verify(sysRoleMenuMapper).updateDeletedStatus(1L, 103L, 0, null);
        verify(sysRoleMenuMapper, never()).delete(any());
        verify(sysRoleMenuMapper).insert(argThat((SysRoleMenu relation) ->
            relation != null
                && relation.getRoleId().equals(1L)
                && relation.getMenuId().equals(104L)
                && Integer.valueOf(0).equals(relation.getDeleted())
        ));
        verify(sysRoleMenuMapper, never()).updateDeletedStatus(eq(1L), eq(101L), any(), isNull());
    }

    private SysRole buildRole(Long id, String roleName, String roleCode) {
        SysRole role = new SysRole();
        role.setId(id);
        role.setRoleName(roleName);
        role.setRoleCode(roleCode);
        role.setStatus("ENABLED");
        return role;
    }

    private SysUserRole buildUserRole(Long roleId) {
        SysUserRole userRole = new SysUserRole();
        userRole.setRoleId(roleId);
        return userRole;
    }

    private SysRoleMenu buildRoleMenu(Long roleId, Long menuId) {
        return buildRoleMenu(roleId, menuId, 0);
    }

    private SysRoleMenu buildRoleMenu(Long roleId, Long menuId, Integer deleted) {
        SysRoleMenu roleMenu = new SysRoleMenu();
        roleMenu.setRoleId(roleId);
        roleMenu.setMenuId(menuId);
        roleMenu.setDeleted(deleted);
        return roleMenu;
    }

    private SysMenu buildMenu(Long id) {
        SysMenu menu = new SysMenu();
        menu.setId(id);
        return menu;
    }

    private void assertRoleCount(RoleListVO role, int userCount, int menuCount) {
        assertEquals(userCount, role.getUserCount());
        assertEquals(menuCount, role.getMenuCount());
    }
}

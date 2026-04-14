package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.dto.RolePageQueryDTO;
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

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
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
        SysRoleMenu roleMenu = new SysRoleMenu();
        roleMenu.setRoleId(roleId);
        roleMenu.setMenuId(menuId);
        return roleMenu;
    }

    private void assertRoleCount(RoleListVO role, int userCount, int menuCount) {
        assertEquals(userCount, role.getUserCount());
        assertEquals(menuCount, role.getMenuCount());
    }
}

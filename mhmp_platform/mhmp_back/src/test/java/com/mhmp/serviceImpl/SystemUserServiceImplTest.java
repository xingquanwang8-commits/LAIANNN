package com.mhmp.serviceImpl;

import com.mhmp.common.exception.BusinessException;
import com.mhmp.dto.UserSaveDTO;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.mapper.SysUserRoleMapper;
import com.mhmp.entity.SysUser;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SystemUserServiceImplTest {

    @Mock
    private SysUserMapper sysUserMapper;
    @Mock
    private SysRoleMapper sysRoleMapper;
    @Mock
    private SysUserRoleMapper sysUserRoleMapper;
    @Mock
    private PasswordEncoder passwordEncoder;

    private SystemUserServiceImpl systemUserService;

    @BeforeEach
    void setUp() {
        systemUserService = new SystemUserServiceImpl(
            sysUserMapper,
            sysRoleMapper,
            sysUserRoleMapper,
            passwordEncoder
        );
    }

    @Test
    void createShouldRequirePrimaryRole() {
        UserSaveDTO saveDTO = buildSaveDTO();
        saveDTO.setRoleIds(List.of());
        when(sysUserMapper.findByUsername("researcher15")).thenReturn(null);

        BusinessException exception = assertThrows(BusinessException.class, () -> systemUserService.create(saveDTO));

        assertEquals("One primary role must be selected", exception.getMessage());
        verify(sysUserMapper, never()).insert(any(SysUser.class));
    }

    @Test
    void createShouldRejectMultiplePrimaryRoles() {
        UserSaveDTO saveDTO = buildSaveDTO();
        saveDTO.setRoleIds(List.of(1L, 2L));
        when(sysUserMapper.findByUsername("researcher15")).thenReturn(null);

        BusinessException exception = assertThrows(BusinessException.class, () -> systemUserService.create(saveDTO));

        assertEquals("Each user can only bind one primary role", exception.getMessage());
        verify(sysUserMapper, never()).insert(any(SysUser.class));
    }

    private UserSaveDTO buildSaveDTO() {
        UserSaveDTO saveDTO = new UserSaveDTO();
        saveDTO.setUsername("researcher15");
        saveDTO.setPassword("123456");
        saveDTO.setNickName("测试研究员");
        saveDTO.setRealName("测试用户");
        saveDTO.setStatus("ENABLED");
        return saveDTO;
    }
}

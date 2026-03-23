package com.mhmp.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mhmp.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {

    @Select("""
        SELECT * FROM sys_user
        WHERE username = #{username} AND deleted = 0
        LIMIT 1
        """)
    SysUser findByUsername(String username);

    @Select("""
        SELECT DISTINCT r.role_code
        FROM sys_role r
        INNER JOIN sys_user_role ur ON ur.role_id = r.id AND ur.deleted = 0
        WHERE ur.user_id = #{userId}
          AND r.deleted = 0
          AND r.status = 'ENABLED'
        """)
    List<String> selectRoleCodesByUserId(Long userId);

    @Select("""
        SELECT DISTINCT m.permission_code
        FROM sys_menu m
        INNER JOIN sys_role_menu rm ON rm.menu_id = m.id AND rm.deleted = 0
        INNER JOIN sys_user_role ur ON ur.role_id = rm.role_id AND ur.deleted = 0
        WHERE ur.user_id = #{userId}
          AND m.deleted = 0
          AND m.status = 'ENABLED'
          AND m.permission_code IS NOT NULL
          AND m.permission_code <> ''
        """)
    List<String> selectPermissionCodesByUserId(Long userId);
}

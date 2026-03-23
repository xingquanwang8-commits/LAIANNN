package com.mhmp.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mhmp.entity.SysMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SysMenuMapper extends BaseMapper<SysMenu> {

    @Select("""
        SELECT DISTINCT m.*
        FROM sys_menu m
        INNER JOIN sys_role_menu rm ON rm.menu_id = m.id AND rm.deleted = 0
        INNER JOIN sys_user_role ur ON ur.role_id = rm.role_id AND ur.deleted = 0
        WHERE ur.user_id = #{userId}
          AND m.deleted = 0
          AND m.status = 'ENABLED'
        ORDER BY m.sort_no ASC, m.id ASC
        """)
    List<SysMenu> selectMenusByUserId(Long userId);
}

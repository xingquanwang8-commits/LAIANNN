package com.mhmp.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mhmp.entity.SysRoleMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface SysRoleMenuMapper extends BaseMapper<SysRoleMenu> {

    @Select("""
        SELECT menu_id
        FROM sys_role_menu
        WHERE role_id = #{roleId}
          AND deleted = 0
        ORDER BY id ASC
        """)
    List<Long> selectMenuIdsByRoleId(Long roleId);

    @Select("""
        SELECT *
        FROM sys_role_menu
        WHERE role_id = #{roleId}
        ORDER BY id ASC
        """)
    List<SysRoleMenu> selectAllByRoleId(Long roleId);

    @Select("""
        SELECT COUNT(1)
        FROM sys_role_menu
        WHERE menu_id = #{menuId}
          AND deleted = 0
        """)
    long countByMenuId(Long menuId);

    @Update("""
        UPDATE sys_role_menu
        SET deleted = #{deleted},
            update_by = #{updateBy},
            update_time = NOW()
        WHERE role_id = #{roleId}
          AND menu_id = #{menuId}
        """)
    int updateDeletedStatus(@Param("roleId") Long roleId,
                            @Param("menuId") Long menuId,
                            @Param("deleted") Integer deleted,
                            @Param("updateBy") Long updateBy);
}

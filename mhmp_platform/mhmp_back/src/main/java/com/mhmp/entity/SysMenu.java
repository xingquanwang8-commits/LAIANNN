package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_menu")
public class SysMenu extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("parent_id")
    private Long parentId;
    @TableField("menu_name")
    private String menuName;
    @TableField("menu_code")
    private String menuCode;
    @TableField("menu_type")
    private String menuType;
    private String path;
    private String component;
    @TableField("permission_code")
    private String permissionCode;
    @TableField("sort_no")
    private Integer sortNo;
    private Integer visible;
    private String status;
    private String icon;
    @TableField("keep_alive")
    private Integer keepAlive;
    private String remark;
}

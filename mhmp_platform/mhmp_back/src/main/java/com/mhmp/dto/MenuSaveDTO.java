package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MenuSaveDTO {

    private Long parentId;

    @NotBlank(message = "菜单名称不能为空")
    private String menuName;

    @NotBlank(message = "菜单编码不能为空")
    private String menuCode;

    @NotBlank(message = "菜单类型不能为空")
    private String menuType;

    private String path;

    private String component;

    private String permissionCode;

    @NotNull(message = "排序号不能为空")
    private Integer sortNo;

    private Integer visible;

    private String status;

    private String icon;

    private Integer keepAlive;

    private String remark;
}

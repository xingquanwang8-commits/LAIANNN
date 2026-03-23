package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MenuSaveDTO {

    private Long parentId;

    @NotBlank(message = "menuName is required")
    private String menuName;

    @NotBlank(message = "menuCode is required")
    private String menuCode;

    @NotBlank(message = "menuType is required")
    private String menuType;

    private String path;

    private String component;

    private String permissionCode;

    @NotNull(message = "sortNo is required")
    private Integer sortNo;

    private Integer visible;

    private String status;

    private String icon;

    private Integer keepAlive;

    private String remark;
}

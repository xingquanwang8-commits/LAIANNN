package com.mhmp.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class SystemMenuTreeVO {

    private Long id;
    private Long parentId;
    private String menuName;
    private String menuCode;
    private String menuType;
    private String path;
    private String component;
    private String permissionCode;
    private Integer sortNo;
    private Integer visible;
    private String status;
    private String icon;
    private Integer keepAlive;
    private String remark;
    private List<SystemMenuTreeVO> children = new ArrayList<>();
}

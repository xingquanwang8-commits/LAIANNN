package com.mhmp.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class MenuVO {

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
    private String icon;
    private Integer keepAlive;
    private List<MenuVO> children = new ArrayList<>();
}

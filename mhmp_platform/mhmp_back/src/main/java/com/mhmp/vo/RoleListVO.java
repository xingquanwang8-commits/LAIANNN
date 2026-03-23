package com.mhmp.vo;

import lombok.Data;

@Data
public class RoleListVO {

    private Long id;
    private String roleName;
    private String roleCode;
    private String status;
    private String remark;
    private Integer userCount;
    private Integer menuCount;
}

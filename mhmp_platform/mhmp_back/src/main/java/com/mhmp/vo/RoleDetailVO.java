package com.mhmp.vo;

import lombok.Data;

import java.util.List;

@Data
public class RoleDetailVO {

    private Long id;
    private String roleName;
    private String roleCode;
    private String status;
    private String remark;
    private List<Long> menuIds;
}

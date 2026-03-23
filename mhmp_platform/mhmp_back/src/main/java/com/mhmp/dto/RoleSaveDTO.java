package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RoleSaveDTO {

    @NotBlank(message = "roleName is required")
    private String roleName;

    @NotBlank(message = "roleCode is required")
    private String roleCode;

    private String status;

    private String remark;
}

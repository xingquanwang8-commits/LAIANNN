package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RoleStatusDTO {

    @NotBlank(message = "状态不能为空")
    private String status;
}

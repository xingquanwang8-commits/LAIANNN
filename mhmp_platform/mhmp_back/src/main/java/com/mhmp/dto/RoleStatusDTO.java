package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RoleStatusDTO {

    @NotBlank(message = "status is required")
    private String status;
}

package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UserStatusDTO {

    @NotBlank(message = "status is required")
    private String status;
}

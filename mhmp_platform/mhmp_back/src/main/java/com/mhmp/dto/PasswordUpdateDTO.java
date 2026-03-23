package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class PasswordUpdateDTO {

    @NotBlank(message = "oldPassword is required")
    private String oldPassword;

    @NotBlank(message = "newPassword is required")
    private String newPassword;
}

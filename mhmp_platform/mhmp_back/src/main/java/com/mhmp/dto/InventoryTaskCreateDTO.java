package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class InventoryTaskCreateDTO {

    @NotBlank(message = "taskName is required")
    private String taskName;

    @NotBlank(message = "locationCode is required")
    private String locationCode;

    @NotNull(message = "startTime is required")
    private LocalDateTime startTime;

    @NotBlank(message = "principalName is required")
    private String principalName;

    private String remark;
}

package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepairAcceptanceDTO {

    @NotBlank(message = "acceptanceResult is required")
    private String acceptanceResult;

    @NotNull(message = "acceptanceTime is required")
    private LocalDateTime acceptanceTime;

    private String acceptanceRemark;

    private String followUpSuggestion;

    private String preservationStatusCode;

    private String storageLocationCode;
}

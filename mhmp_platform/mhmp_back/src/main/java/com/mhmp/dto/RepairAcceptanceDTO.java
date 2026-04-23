package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepairAcceptanceDTO {

    @NotBlank(message = "验收结果不能为空")
    private String acceptanceResult;

    @NotNull(message = "验收时间不能为空")
    private LocalDateTime acceptanceTime;

    private String acceptanceRemark;

    private String followUpSuggestion;

    private String preservationStatusCode;

    private String storageLocationCode;
}

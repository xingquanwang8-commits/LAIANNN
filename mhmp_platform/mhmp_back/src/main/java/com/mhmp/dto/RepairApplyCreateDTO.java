package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class RepairApplyCreateDTO {

    @NotNull(message = "relicId is required")
    private Long relicId;

    @NotBlank(message = "applyReason is required")
    private String applyReason;

    private String remark;
}

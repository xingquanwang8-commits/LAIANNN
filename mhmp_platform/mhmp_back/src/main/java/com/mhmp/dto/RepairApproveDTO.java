package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RepairApproveDTO {

    @NotBlank(message = "approveResult is required")
    private String approveResult;

    private String approveRemark;

    private String planTitle;

    private String planContent;

    private String materials;

    private String riskNote;
}

package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RepairApproveDTO {

    @NotBlank(message = "审批结果不能为空")
    private String approveResult;

    private String approveRemark;

    private String planTitle;

    private String planContent;

    private String materials;

    private String riskNote;
}

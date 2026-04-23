package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class RepairApplyCreateDTO {

    @NotNull(message = "请选择文物")
    private Long relicId;

    @NotBlank(message = "申请原因不能为空")
    private String applyReason;

    private String remark;
}

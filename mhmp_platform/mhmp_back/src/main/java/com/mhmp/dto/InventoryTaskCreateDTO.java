package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class InventoryTaskCreateDTO {

    @NotBlank(message = "任务名称不能为空")
    private String taskName;

    @NotBlank(message = "盘点库位不能为空")
    private String locationCode;

    @NotNull(message = "开始时间不能为空")
    private LocalDateTime startTime;

    @NotNull(message = "负责人不能为空")
    private Long principalUserId;

    private String remark;
}

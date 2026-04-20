package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class TransferTaskCreateDTO {

    @NotNull(message = "文物不能为空")
    private Long relicId;

    @NotNull(message = "负责人不能为空")
    private Long principalUserId;

    @NotBlank(message = "目标库位不能为空")
    private String targetLocationCode;

    private String transferReason;
}

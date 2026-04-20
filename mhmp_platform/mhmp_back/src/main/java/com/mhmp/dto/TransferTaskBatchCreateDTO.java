package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class TransferTaskBatchCreateDTO {

    @NotEmpty(message = "请选择要转存的文物")
    private List<Long> relicIds;

    @NotNull(message = "负责人不能为空")
    private Long principalUserId;

    @NotBlank(message = "目标库位不能为空")
    private String targetLocationCode;

    private String transferReason;
}

package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class RelicBatchTransferDTO {

    @NotEmpty(message = "请选择要转存的文物")
    private List<Long> relicIds;

    @NotBlank(message = "馆内转存位置不能为空")
    private String storageLocationCode;

    private LocalDateTime transferTime;

    private String transferReason;
}

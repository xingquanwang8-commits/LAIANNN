package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RelicTransferDTO {

    @NotBlank(message = "馆内转存位置不能为空")
    private String storageLocationCode;

    private LocalDateTime transferTime;

    private String transferReason;
}

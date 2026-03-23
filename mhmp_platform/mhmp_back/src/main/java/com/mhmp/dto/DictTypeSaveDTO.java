package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class DictTypeSaveDTO {

    @NotBlank(message = "dictName is required")
    private String dictName;

    @NotBlank(message = "dictTypeCode is required")
    private String dictTypeCode;

    private String status;

    private String remark;
}

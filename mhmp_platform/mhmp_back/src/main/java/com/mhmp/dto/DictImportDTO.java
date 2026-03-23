package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class DictImportDTO {

    @NotBlank(message = "dictTypeCode is required")
    private String dictTypeCode;

    @NotBlank(message = "content is required")
    private String content;
}

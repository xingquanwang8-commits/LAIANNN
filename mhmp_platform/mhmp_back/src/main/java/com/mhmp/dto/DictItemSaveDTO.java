package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class DictItemSaveDTO {

    @NotBlank(message = "dictTypeCode is required")
    private String dictTypeCode;

    @NotBlank(message = "itemLabel is required")
    private String itemLabel;

    @NotBlank(message = "itemValue is required")
    private String itemValue;

    private Integer itemSort;

    private String status;

    private String cssClass;

    private String remark;
}

package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class DictItemSaveDTO {

    @NotBlank(message = "字典类型编码不能为空")
    private String dictTypeCode;

    @NotBlank(message = "字典项名称不能为空")
    private String itemLabel;

    @NotBlank(message = "字典项值不能为空")
    private String itemValue;

    private Integer itemSort;

    private String status;

    private String cssClass;

    private String remark;
}

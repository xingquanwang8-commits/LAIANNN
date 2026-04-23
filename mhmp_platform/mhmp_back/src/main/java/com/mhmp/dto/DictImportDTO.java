package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class DictImportDTO {

    @NotBlank(message = "字典类型编码不能为空")
    private String dictTypeCode;

    @NotBlank(message = "导入内容不能为空")
    private String content;
}

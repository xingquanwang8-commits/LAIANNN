package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RelicCategoryCreateDTO {

    @NotBlank(message = "分类名称不能为空")
    private String categoryName;
}

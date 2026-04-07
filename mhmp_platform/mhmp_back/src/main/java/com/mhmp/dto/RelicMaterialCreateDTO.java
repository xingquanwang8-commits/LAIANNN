package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RelicMaterialCreateDTO {

    @NotBlank(message = "材质名称不能为空")
    private String materialName;
}

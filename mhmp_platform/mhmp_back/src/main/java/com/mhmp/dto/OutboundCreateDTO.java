package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class OutboundCreateDTO {

    @NotBlank(message = "用途不能为空")
    private String purpose;

    @NotBlank(message = "去向不能为空")
    private String destination;

    @NotBlank(message = "经手人不能为空")
    private String handlerName;

    @NotNull(message = "申请时间不能为空")
    private LocalDateTime outboundTime;

    private String remark;

    @NotEmpty(message = "至少选择一件文物")
    private List<Long> relicIds;
}

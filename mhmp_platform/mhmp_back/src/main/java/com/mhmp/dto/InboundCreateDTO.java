package com.mhmp.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class InboundCreateDTO {

    private String batchNo;

    @jakarta.validation.constraints.NotBlank(message = "来源不能为空")
    private String source;

    private String handlerName;

    @NotNull(message = "入库时间不能为空")
    private LocalDateTime inboundTime;

    @jakarta.validation.constraints.NotBlank(message = "入库库位不能为空")
    private String storageLocationCode;

    private String remark;

    @NotEmpty(message = "请选择需要入库的文物")
    private List<Long> relicIds;
}

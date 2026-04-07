package com.mhmp.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class InboundCreateDTO {

    private String batchNo;

    @jakarta.validation.constraints.NotBlank(message = "source is required")
    private String source;

    @jakarta.validation.constraints.NotBlank(message = "handlerName is required")
    private String handlerName;

    @NotNull(message = "inboundTime is required")
    private LocalDateTime inboundTime;

    private String remark;

    @NotEmpty(message = "relicIds is required")
    private List<Long> relicIds;
}

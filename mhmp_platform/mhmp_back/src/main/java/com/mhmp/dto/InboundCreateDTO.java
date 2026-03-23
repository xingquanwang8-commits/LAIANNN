package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class InboundCreateDTO {

    @NotBlank(message = "batchNo is required")
    private String batchNo;

    @NotBlank(message = "source is required")
    private String source;

    @NotBlank(message = "handlerName is required")
    private String handlerName;

    @NotNull(message = "inboundTime is required")
    private LocalDateTime inboundTime;

    private String remark;

    @NotEmpty(message = "relicIds is required")
    private List<Long> relicIds;
}

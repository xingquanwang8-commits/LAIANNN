package com.mhmp.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class OutboundReturnDTO {

    private LocalDateTime returnTime;

    private String remark;
}

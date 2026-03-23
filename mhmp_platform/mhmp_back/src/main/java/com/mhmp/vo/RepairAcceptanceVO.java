package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepairAcceptanceVO {

    private Long id;
    private String acceptanceNo;
    private String acceptanceResult;
    private Long acceptanceBy;
    private LocalDateTime acceptanceTime;
    private String acceptanceRemark;
    private String followUpSuggestion;
}

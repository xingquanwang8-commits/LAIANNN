package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepairPlanVO {

    private Long id;
    private String planNo;
    private String planTitle;
    private String planContent;
    private String materials;
    private String riskNote;
    private String planStatus;
    private String submitterName;
    private String reviewerName;
    private LocalDateTime reviewTime;
    private String reviewRemark;
}

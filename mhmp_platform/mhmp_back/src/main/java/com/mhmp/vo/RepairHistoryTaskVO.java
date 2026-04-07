package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepairHistoryTaskVO {

    private Long id;

    private String taskNo;

    private String taskStatus;

    private String acceptanceStatus;

    private String applyReason;

    private String approveRemark;

    private LocalDateTime applyTime;

    private LocalDateTime startTime;

    private LocalDateTime endTime;
}

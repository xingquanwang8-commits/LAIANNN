package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepairTaskListVO {

    private Long id;
    private String taskNo;
    private String relicNo;
    private String relicName;
    private String taskStatus;
    private String applyUserName;
    private LocalDateTime applyTime;
    private LocalDateTime approveTime;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String remark;
}

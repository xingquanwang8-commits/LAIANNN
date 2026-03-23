package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class RepairDetailVO {

    private Long id;
    private String taskNo;
    private Long relicId;
    private String relicNo;
    private String relicName;
    private Long applyUserId;
    private String applyUserName;
    private String applyReason;
    private String taskStatus;
    private LocalDateTime applyTime;
    private Long approveBy;
    private String approveUserName;
    private LocalDateTime approveTime;
    private String approveRemark;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String remark;
    private RepairPlanVO plan;
    private List<RepairLogVO> logs;
    private RepairAcceptanceVO acceptance;
}

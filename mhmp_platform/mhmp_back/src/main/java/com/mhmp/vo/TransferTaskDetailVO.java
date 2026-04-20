package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class TransferTaskDetailVO {

    private Long id;
    private String taskNo;
    private Long relicId;
    private String relicNo;
    private String relicName;
    private String fromLocationCode;
    private String targetLocationCode;
    private String taskStatus;
    private Long assignUserId;
    private String assignUserName;
    private Long principalUserId;
    private String principalName;
    private LocalDateTime assignTime;
    private LocalDateTime completeTime;
    private String transferReason;
    private String confirmRemark;
}

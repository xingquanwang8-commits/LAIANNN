package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepairLogVO {

    private Long id;
    private String logNo;
    private String stepName;
    private String operationContent;
    private String materialsUsed;
    private String operatorName;
    private LocalDateTime logTime;
    private String progressStatus;
    private String remark;
}

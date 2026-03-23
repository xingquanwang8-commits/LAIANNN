package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class InventoryTaskListVO {

    private Long id;
    private String taskNo;
    private String taskName;
    private String locationCode;
    private String taskStatus;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String principalName;
    private String remark;
    private Integer totalCount;
    private Integer checkedCount;
    private Integer diffCount;
}

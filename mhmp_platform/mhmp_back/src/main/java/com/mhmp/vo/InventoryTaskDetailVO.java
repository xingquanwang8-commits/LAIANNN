package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class InventoryTaskDetailVO {

    private Long id;
    private String taskNo;
    private String taskName;
    private String locationCode;
    private String taskStatus;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String principalName;
    private String remark;
    private List<InventoryTaskItemVO> details;
}

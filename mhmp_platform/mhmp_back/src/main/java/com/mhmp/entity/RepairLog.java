package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("repair_log")
public class RepairLog extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("repair_task_id")
    private Long repairTaskId;

    @TableField("log_no")
    private String logNo;

    @TableField("step_name")
    private String stepName;

    @TableField("operation_content")
    private String operationContent;

    @TableField("materials_used")
    private String materialsUsed;

    @TableField("operator_name")
    private String operatorName;

    @TableField("log_time")
    private LocalDateTime logTime;

    @TableField("progress_status")
    private String progressStatus;

    private String remark;
}

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
@TableName("repair_task")
public class RepairTask extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("task_no")
    private String taskNo;

    @TableField("relic_id")
    private Long relicId;

    @TableField("relic_no")
    private String relicNo;

    @TableField("relic_name")
    private String relicName;

    @TableField("apply_user_id")
    private Long applyUserId;

    @TableField("apply_reason")
    private String applyReason;

    @TableField("task_status")
    private String taskStatus;

    @TableField("apply_time")
    private LocalDateTime applyTime;

    @TableField("approve_by")
    private Long approveBy;

    @TableField("approve_time")
    private LocalDateTime approveTime;

    @TableField("approve_remark")
    private String approveRemark;

    @TableField("start_time")
    private LocalDateTime startTime;

    @TableField("end_time")
    private LocalDateTime endTime;

    private String remark;
}

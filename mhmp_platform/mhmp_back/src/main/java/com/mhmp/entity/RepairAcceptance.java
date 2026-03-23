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
@TableName("repair_acceptance")
public class RepairAcceptance extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("repair_task_id")
    private Long repairTaskId;

    @TableField("acceptance_no")
    private String acceptanceNo;

    @TableField("acceptance_result")
    private String acceptanceResult;

    @TableField("acceptance_by")
    private Long acceptanceBy;

    @TableField("acceptance_time")
    private LocalDateTime acceptanceTime;

    @TableField("acceptance_remark")
    private String acceptanceRemark;

    @TableField("follow_up_suggestion")
    private String followUpSuggestion;
}

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
@TableName("repair_plan")
public class RepairPlan extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("repair_task_id")
    private Long repairTaskId;

    @TableField("plan_no")
    private String planNo;

    @TableField("plan_title")
    private String planTitle;

    @TableField("plan_content")
    private String planContent;

    private String materials;

    @TableField("risk_note")
    private String riskNote;

    @TableField("plan_status")
    private String planStatus;

    @TableField("submitter_name")
    private String submitterName;

    @TableField("reviewer_name")
    private String reviewerName;

    @TableField("review_time")
    private LocalDateTime reviewTime;

    @TableField("review_remark")
    private String reviewRemark;
}

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
@TableName("relic_transfer_task")
public class RelicTransferTask extends BaseEntity {

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

    @TableField("from_location_code")
    private String fromLocationCode;

    @TableField("target_location_code")
    private String targetLocationCode;

    @TableField("task_status")
    private String taskStatus;

    @TableField("assign_user_id")
    private Long assignUserId;

    @TableField("assign_user_name")
    private String assignUserName;

    @TableField("principal_user_id")
    private Long principalUserId;

    @TableField("principal_name")
    private String principalName;

    @TableField("assign_time")
    private LocalDateTime assignTime;

    @TableField("complete_time")
    private LocalDateTime completeTime;

    @TableField("transfer_reason")
    private String transferReason;

    @TableField("confirm_remark")
    private String confirmRemark;
}

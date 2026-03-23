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
@TableName("inventory_task")
public class InventoryTask extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("task_no")
    private String taskNo;

    @TableField("task_name")
    private String taskName;

    @TableField("location_code")
    private String locationCode;

    @TableField("task_status")
    private String taskStatus;

    @TableField("start_time")
    private LocalDateTime startTime;

    @TableField("end_time")
    private LocalDateTime endTime;

    @TableField("principal_name")
    private String principalName;

    private String remark;
}

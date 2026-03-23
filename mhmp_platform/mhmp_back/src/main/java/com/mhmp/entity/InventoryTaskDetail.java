package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("inventory_task_detail")
public class InventoryTaskDetail extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("task_id")
    private Long taskId;

    @TableField("relic_id")
    private Long relicId;

    @TableField("relic_no")
    private String relicNo;

    @TableField("relic_name")
    private String relicName;

    @TableField("system_quantity")
    private Integer systemQuantity;

    @TableField("actual_quantity")
    private Integer actualQuantity;

    @TableField("diff_quantity")
    private Integer diffQuantity;

    @TableField("diff_remark")
    private String diffRemark;

    @TableField("result_status")
    private String resultStatus;
}

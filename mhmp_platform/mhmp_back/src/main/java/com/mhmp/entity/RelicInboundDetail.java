package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("relic_inbound_detail")
public class RelicInboundDetail extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("order_id")
    private Long orderId;

    @TableField("relic_id")
    private Long relicId;

    @TableField("relic_no")
    private String relicNo;

    @TableField("relic_name")
    private String relicName;

    private Integer quantity;

    private String remark;
}

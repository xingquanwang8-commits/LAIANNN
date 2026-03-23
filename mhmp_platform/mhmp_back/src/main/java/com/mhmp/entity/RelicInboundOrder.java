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
@TableName("relic_inbound_order")
public class RelicInboundOrder extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("order_no")
    private String orderNo;

    @TableField("batch_no")
    private String batchNo;

    private String source;

    @TableField("handler_name")
    private String handlerName;

    @TableField("inbound_time")
    private LocalDateTime inboundTime;

    @TableField("total_count")
    private Integer totalCount;

    private String status;

    private String remark;
}

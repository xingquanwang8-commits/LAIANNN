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
@TableName("relic_outbound_order")
public class RelicOutboundOrder extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("order_no")
    private String orderNo;
    private String purpose;
    private String destination;
    @TableField("handler_name")
    private String handlerName;
    @TableField("outbound_time")
    private LocalDateTime outboundTime;
    @TableField("apply_user_id")
    private Long applyUserId;
    @TableField("approve_status")
    private String approveStatus;
    @TableField("approve_by")
    private Long approveBy;
    @TableField("approve_time")
    private LocalDateTime approveTime;
    @TableField("approve_remark")
    private String approveRemark;
    @TableField("return_time")
    private LocalDateTime returnTime;
    private String remark;
}

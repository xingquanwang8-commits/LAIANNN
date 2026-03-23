package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class OutboundListVO {

    private Long id;
    private String orderNo;
    private String purpose;
    private String destination;
    private String handlerName;
    private LocalDateTime outboundTime;
    private Long applyUserId;
    private String approveStatus;
    private Long approveBy;
    private LocalDateTime approveTime;
    private String remark;
    private Integer detailCount;
}

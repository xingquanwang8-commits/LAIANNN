package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class OutboundDetailVO {

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
    private String approveRemark;
    private LocalDateTime returnTime;
    private String remark;
    private List<OutboundDetailItemVO> details;
}

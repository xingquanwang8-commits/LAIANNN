package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class InboundListVO {

    private Long id;
    private String orderNo;
    private String batchNo;
    private String source;
    private String handlerName;
    private LocalDateTime inboundTime;
    private Integer totalCount;
    private String status;
    private String remark;
}

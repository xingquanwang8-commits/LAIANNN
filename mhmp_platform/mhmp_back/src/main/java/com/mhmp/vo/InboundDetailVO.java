package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class InboundDetailVO {

    private Long id;
    private String orderNo;
    private String batchNo;
    private String source;
    private String handlerName;
    private LocalDateTime inboundTime;
    private Integer totalCount;
    private String status;
    private String remark;
    private List<InboundDetailItemVO> details;
}

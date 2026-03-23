package com.mhmp.vo;

import lombok.Data;

@Data
public class OutboundDetailItemVO {

    private Long id;
    private Long relicId;
    private String relicNo;
    private String relicName;
    private Integer quantity;
    private String currentStatusSnapshot;
    private String remark;
}

package com.mhmp.vo;

import lombok.Data;

@Data
public class InboundDetailItemVO {

    private Long id;
    private Long relicId;
    private String relicNo;
    private String relicName;
    private Integer quantity;
    private String remark;
}

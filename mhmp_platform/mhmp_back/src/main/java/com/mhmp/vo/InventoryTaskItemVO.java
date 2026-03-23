package com.mhmp.vo;

import lombok.Data;

@Data
public class InventoryTaskItemVO {

    private Long id;
    private Long relicId;
    private String relicNo;
    private String relicName;
    private Integer systemQuantity;
    private Integer actualQuantity;
    private Integer diffQuantity;
    private String diffRemark;
    private String resultStatus;
}

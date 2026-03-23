package com.mhmp.vo;

import lombok.Data;

@Data
public class DictItemVO {

    private Long id;
    private String dictTypeCode;
    private String itemLabel;
    private String itemValue;
    private Integer itemSort;
    private String status;
    private String cssClass;
    private String remark;
}

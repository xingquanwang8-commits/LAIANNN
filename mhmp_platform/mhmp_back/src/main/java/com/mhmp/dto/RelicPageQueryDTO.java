package com.mhmp.dto;

import jakarta.validation.constraints.Min;
import lombok.Data;

@Data
public class RelicPageQueryDTO {

    @Min(value = 1, message = "页码必须大于等于 1")
    private Long pageNum = 1L;

    @Min(value = 1, message = "每页条数必须大于等于 1")
    private Long pageSize = 10L;

    private String keyword;
    private String categoryCode;
    private String materialCode;
    private String currentStatus;
    private String storageLocationCode;
}

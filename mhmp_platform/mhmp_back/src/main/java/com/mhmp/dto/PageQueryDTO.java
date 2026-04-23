package com.mhmp.dto;

import jakarta.validation.constraints.Min;
import lombok.Data;

@Data
public class PageQueryDTO {

    @Min(value = 1, message = "页码必须大于等于 1")
    private Long pageNum = 1L;

    @Min(value = 1, message = "每页条数必须大于等于 1")
    private Long pageSize = 10L;
}

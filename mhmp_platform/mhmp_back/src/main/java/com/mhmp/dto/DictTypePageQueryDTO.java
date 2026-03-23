package com.mhmp.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class DictTypePageQueryDTO extends PageQueryDTO {

    private String keyword;

    private String status;
}

package com.mhmp.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class RepairPageQueryDTO extends PageQueryDTO {

    private String keyword;

    private String taskStatus;
}

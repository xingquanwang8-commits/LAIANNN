package com.mhmp.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class InventoryTaskPageQueryDTO extends PageQueryDTO {

    private String keyword;

    private String locationCode;

    private String taskStatus;
}

package com.mhmp.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class InventoryQueryPageDTO extends PageQueryDTO {

    private String keyword;

    private String categoryCode;

    private String materialCode;

    private String storageLocationCode;

    private String preservationStatusCode;

    private String currentStatus;
}

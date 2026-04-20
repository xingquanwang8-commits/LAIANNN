package com.mhmp.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class TransferTaskPageQueryDTO extends PageQueryDTO {

    private String keyword;

    private String taskStatus;
}

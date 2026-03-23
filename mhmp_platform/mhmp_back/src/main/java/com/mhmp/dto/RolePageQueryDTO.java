package com.mhmp.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class RolePageQueryDTO extends PageQueryDTO {

    private String keyword;

    private String status;
}

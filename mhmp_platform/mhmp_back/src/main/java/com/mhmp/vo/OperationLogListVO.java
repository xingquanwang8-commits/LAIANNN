package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class OperationLogListVO {

    private Long id;
    private String username;
    private String moduleName;
    private String businessType;
    private String requestUri;
    private String requestMethod;
    private String operationStatus;
    private Long costTime;
    private LocalDateTime operationTime;
}

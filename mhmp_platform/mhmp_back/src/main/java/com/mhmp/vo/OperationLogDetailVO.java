package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class OperationLogDetailVO {

    private Long id;
    private Long userId;
    private String username;
    private String moduleName;
    private String businessType;
    private String requestUri;
    private String requestMethod;
    private String operationDesc;
    private String operationIp;
    private String operationStatus;
    private Long costTime;
    private String requestParam;
    private String responseResult;
    private LocalDateTime operationTime;
}

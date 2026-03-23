package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_operation_log")
public class SysOperationLog extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("user_id")
    private Long userId;

    private String username;

    @TableField("module_name")
    private String moduleName;

    @TableField("business_type")
    private String businessType;

    @TableField("request_uri")
    private String requestUri;

    @TableField("request_method")
    private String requestMethod;

    @TableField("operation_desc")
    private String operationDesc;

    @TableField("operation_ip")
    private String operationIp;

    @TableField("operation_status")
    private String operationStatus;

    @TableField("cost_time")
    private Long costTime;

    @TableField("request_param")
    private String requestParam;

    @TableField("response_result")
    private String responseResult;

    @TableField("operation_time")
    private LocalDateTime operationTime;
}

package com.mhmp.controller;

import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.Result;
import com.mhmp.dto.LogPageQueryDTO;
import com.mhmp.service.SystemLogService;
import com.mhmp.vo.OperationLogDetailVO;
import com.mhmp.vo.OperationLogListVO;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/system/logs")
public class SystemLogController {

    private final SystemLogService systemLogService;

    public SystemLogController(SystemLogService systemLogService) {
        this.systemLogService = systemLogService;
    }

    @GetMapping("/page")
    @PreAuthorize("hasAuthority('sys:log:view')")
    public Result<PageResponse<OperationLogListVO>> page(@Valid LogPageQueryDTO queryDTO) {
        return Result.success(systemLogService.page(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:log:view')")
    public Result<OperationLogDetailVO> detail(@PathVariable Long id) {
        return Result.success(systemLogService.detail(id));
    }
}

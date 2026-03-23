package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.Result;
import com.mhmp.dto.InboundCreateDTO;
import com.mhmp.dto.InboundPageQueryDTO;
import com.mhmp.service.InboundService;
import com.mhmp.vo.InboundDetailVO;
import com.mhmp.vo.InboundListVO;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/inbound")
public class InboundController {

    private final InboundService inboundService;

    public InboundController(InboundService inboundService) {
        this.inboundService = inboundService;
    }

    @GetMapping("/page")
    @PreAuthorize("hasAuthority('inventory:inbound:view')")
    public Result<PageResponse<InboundListVO>> page(@Valid InboundPageQueryDTO queryDTO) {
        return Result.success(inboundService.page(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('inventory:inbound:view')")
    public Result<InboundDetailVO> detail(@PathVariable Long id) {
        return Result.success(inboundService.detail(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('inventory:inbound:add')")
    @OperationLog(module = "Inbound", businessType = "INSERT", description = "Create inbound order")
    public Result<Long> create(@Valid @RequestBody InboundCreateDTO createDTO) {
        return Result.success(inboundService.create(createDTO));
    }
}

package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.R;
import com.mhmp.dto.OutboundApproveDTO;
import com.mhmp.dto.OutboundCreateDTO;
import com.mhmp.dto.OutboundPageQueryDTO;
import com.mhmp.dto.OutboundReturnDTO;
import com.mhmp.service.OutboundService;
import com.mhmp.vo.OutboundDetailVO;
import com.mhmp.vo.OutboundListVO;
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
@RequestMapping("/api/outbound")
public class OutboundController {

    private final OutboundService outboundService;

    public OutboundController(OutboundService outboundService) {
        this.outboundService = outboundService;
    }

    @GetMapping("/page")
    @PreAuthorize("hasAnyAuthority('inventory:outbound:apply:view','inventory:outbound:approve:view','inventory:outbound:return:view')")
    public R<PageResponse<OutboundListVO>> page(@Valid OutboundPageQueryDTO queryDTO) {
        return R.success(outboundService.page(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('inventory:outbound:apply:view','inventory:outbound:approve:view','inventory:outbound:return:view')")
    public R<OutboundDetailVO> detail(@PathVariable Long id) {
        return R.success(outboundService.detail(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('inventory:outbound:submit')")
    @OperationLog(module = "Outbound", businessType = "INSERT", description = "Create outbound application")
    public R<Long> create(@Valid @RequestBody OutboundCreateDTO createDTO) {
        return R.success(outboundService.create(createDTO));
    }

    @PostMapping("/approve/{id}")
    @PreAuthorize("hasAuthority('inventory:outbound:approve')")
    @OperationLog(module = "Outbound", businessType = "APPROVE", description = "Approve outbound application")
    public R<Void> approve(@PathVariable Long id, @RequestBody(required = false) OutboundApproveDTO approveDTO) {
        outboundService.approve(id, approveDTO == null ? new OutboundApproveDTO() : approveDTO);
        return R.success();
    }

    @PostMapping("/reject/{id}")
    @PreAuthorize("hasAuthority('inventory:outbound:reject')")
    @OperationLog(module = "Outbound", businessType = "REJECT", description = "Reject outbound application")
    public R<Void> reject(@PathVariable Long id, @RequestBody(required = false) OutboundApproveDTO approveDTO) {
        outboundService.reject(id, approveDTO == null ? new OutboundApproveDTO() : approveDTO);
        return R.success();
    }

    @PostMapping("/return/{id}")
    @PreAuthorize("hasAuthority('inventory:outbound:return')")
    @OperationLog(module = "Outbound", businessType = "RETURN", description = "Register relic return")
    public R<Void> returnOrder(@PathVariable Long id, @RequestBody(required = false) OutboundReturnDTO returnDTO) {
        outboundService.returnOrder(id, returnDTO == null ? new OutboundReturnDTO() : returnDTO);
        return R.success();
    }
}

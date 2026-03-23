package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.Result;
import com.mhmp.dto.RepairAcceptanceDTO;
import com.mhmp.dto.RepairApplyCreateDTO;
import com.mhmp.dto.RepairApproveDTO;
import com.mhmp.dto.RepairLogCreateDTO;
import com.mhmp.dto.RepairPageQueryDTO;
import com.mhmp.service.RepairService;
import com.mhmp.vo.RepairDetailVO;
import com.mhmp.vo.RepairTaskListVO;
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
@RequestMapping("/api/repair")
public class RepairController {

    private final RepairService repairService;

    public RepairController(RepairService repairService) {
        this.repairService = repairService;
    }

    @GetMapping("/apply/page")
    @PreAuthorize("hasAuthority('repair:apply:view')")
    public Result<PageResponse<RepairTaskListVO>> applyPage(@Valid RepairPageQueryDTO queryDTO) {
        return Result.success(repairService.applyPage(queryDTO));
    }

    @GetMapping("/approve/page")
    @PreAuthorize("hasAuthority('repair:approve:view')")
    public Result<PageResponse<RepairTaskListVO>> approvePage(@Valid RepairPageQueryDTO queryDTO) {
        return Result.success(repairService.approvePage(queryDTO));
    }

    @GetMapping("/process/page")
    @PreAuthorize("hasAuthority('repair:process:view')")
    public Result<PageResponse<RepairTaskListVO>> processPage(@Valid RepairPageQueryDTO queryDTO) {
        return Result.success(repairService.processPage(queryDTO));
    }

    @GetMapping("/acceptance/page")
    @PreAuthorize("hasAuthority('repair:acceptance:view')")
    public Result<PageResponse<RepairTaskListVO>> acceptancePage(@Valid RepairPageQueryDTO queryDTO) {
        return Result.success(repairService.acceptancePage(queryDTO));
    }

    @GetMapping("/history/page")
    @PreAuthorize("hasAuthority('repair:history:view')")
    public Result<PageResponse<RepairTaskListVO>> historyPage(@Valid RepairPageQueryDTO queryDTO) {
        return Result.success(repairService.historyPage(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('repair:apply:view','repair:approve:view','repair:process:view','repair:acceptance:view','repair:history:view')")
    public Result<RepairDetailVO> detail(@PathVariable Long id) {
        return Result.success(repairService.detail(id));
    }

    @PostMapping("/apply")
    @PreAuthorize("hasAuthority('repair:apply:submit')")
    @OperationLog(module = "Repair", businessType = "INSERT", description = "Create repair application")
    public Result<Long> createApply(@Valid @RequestBody RepairApplyCreateDTO createDTO) {
        return Result.success(repairService.createApply(createDTO));
    }

    @PostMapping("/approve/{id}")
    @PreAuthorize("hasAuthority('repair:plan:approve')")
    @OperationLog(module = "Repair", businessType = "APPROVE", description = "Approve repair plan")
    public Result<Void> approve(@PathVariable Long id, @Valid @RequestBody RepairApproveDTO approveDTO) {
        repairService.approve(id, approveDTO);
        return Result.success();
    }

    @PostMapping("/process/{id}/log")
    @PreAuthorize("hasAuthority('repair:log:add')")
    @OperationLog(module = "Repair", businessType = "UPDATE", description = "Add repair log")
    public Result<Void> addLog(@PathVariable Long id, @Valid @RequestBody RepairLogCreateDTO createDTO) {
        repairService.addLog(id, createDTO);
        return Result.success();
    }

    @PostMapping("/acceptance/{id}")
    @PreAuthorize("hasAuthority('repair:acceptance:add')")
    @OperationLog(module = "Repair", businessType = "ACCEPT", description = "Submit repair acceptance")
    public Result<Void> accept(@PathVariable Long id, @Valid @RequestBody RepairAcceptanceDTO acceptanceDTO) {
        repairService.accept(id, acceptanceDTO);
        return Result.success();
    }
}

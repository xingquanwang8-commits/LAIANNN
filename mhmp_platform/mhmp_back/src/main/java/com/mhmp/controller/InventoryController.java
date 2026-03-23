package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.Result;
import com.mhmp.dto.InventoryQueryPageDTO;
import com.mhmp.dto.InventoryTaskCreateDTO;
import com.mhmp.dto.InventoryTaskDetailUpdateDTO;
import com.mhmp.dto.InventoryTaskPageQueryDTO;
import com.mhmp.service.InventoryService;
import com.mhmp.vo.InventorySummaryVO;
import com.mhmp.vo.InventoryTaskDetailVO;
import com.mhmp.vo.InventoryTaskListVO;
import com.mhmp.vo.RelicListVO;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    private final InventoryService inventoryService;

    public InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    @GetMapping("/query/summary")
    @PreAuthorize("hasAuthority('inventory:query:view')")
    public Result<InventorySummaryVO> summary() {
        return Result.success(inventoryService.summary());
    }

    @GetMapping("/query/page")
    @PreAuthorize("hasAuthority('inventory:query:view')")
    public Result<PageResponse<RelicListVO>> queryPage(@Valid InventoryQueryPageDTO queryDTO) {
        return Result.success(inventoryService.queryPage(queryDTO));
    }

    @GetMapping("/tasks/page")
    @PreAuthorize("hasAuthority('inventory:task:view')")
    public Result<PageResponse<InventoryTaskListVO>> taskPage(@Valid InventoryTaskPageQueryDTO queryDTO) {
        return Result.success(inventoryService.taskPage(queryDTO));
    }

    @GetMapping("/tasks/{id}")
    @PreAuthorize("hasAuthority('inventory:task:view')")
    public Result<InventoryTaskDetailVO> taskDetail(@PathVariable Long id) {
        return Result.success(inventoryService.taskDetail(id));
    }

    @PostMapping("/tasks")
    @PreAuthorize("hasAuthority('inventory:task:view')")
    @OperationLog(module = "Inventory Task", businessType = "INSERT", description = "Create inventory task")
    public Result<Long> createTask(@Valid @RequestBody InventoryTaskCreateDTO createDTO) {
        return Result.success(inventoryService.createTask(createDTO));
    }

    @PutMapping("/tasks/{taskId}/details/{detailId}")
    @PreAuthorize("hasAuthority('inventory:task:submit')")
    @OperationLog(module = "Inventory Task", businessType = "UPDATE", description = "Update inventory detail")
    public Result<Void> updateTaskDetail(@PathVariable Long taskId,
                                         @PathVariable Long detailId,
                                         @RequestBody(required = false) InventoryTaskDetailUpdateDTO updateDTO) {
        inventoryService.updateTaskDetail(taskId, detailId,
            updateDTO == null ? new InventoryTaskDetailUpdateDTO() : updateDTO);
        return Result.success();
    }

    @PostMapping("/tasks/{taskId}/submit")
    @PreAuthorize("hasAuthority('inventory:task:submit')")
    @OperationLog(module = "Inventory Task", businessType = "SUBMIT", description = "Submit inventory task")
    public Result<Void> submitTask(@PathVariable Long taskId) {
        inventoryService.submitTask(taskId);
        return Result.success();
    }
}

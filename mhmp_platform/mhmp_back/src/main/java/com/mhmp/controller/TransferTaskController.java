package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.R;
import com.mhmp.dto.TransferTaskBatchCreateDTO;
import com.mhmp.dto.TransferTaskConfirmDTO;
import com.mhmp.dto.TransferTaskCreateDTO;
import com.mhmp.dto.TransferTaskPageQueryDTO;
import com.mhmp.service.TransferTaskService;
import com.mhmp.vo.TransferTaskDetailVO;
import com.mhmp.vo.TransferTaskListVO;
import com.mhmp.vo.TransferTaskPrincipalVO;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Validated
@RestController
@RequestMapping("/api/inventory/transfer-tasks")
public class TransferTaskController {

    private final TransferTaskService transferTaskService;

    public TransferTaskController(TransferTaskService transferTaskService) {
        this.transferTaskService = transferTaskService;
    }

    @GetMapping("/principals")
    @PreAuthorize("hasAuthority('inventory:transfer:add')")
    public R<List<TransferTaskPrincipalVO>> taskPrincipals() {
        return R.success(transferTaskService.taskPrincipals());
    }

    @PostMapping
    @PreAuthorize("hasAuthority('inventory:transfer:add')")
    @OperationLog(module = "Transfer Task", businessType = "INSERT", description = "Create transfer task")
    public R<Long> createTask(@Valid @RequestBody TransferTaskCreateDTO createDTO) {
        return R.success(transferTaskService.createTask(createDTO));
    }

    @PostMapping("/batch")
    @PreAuthorize("hasAuthority('inventory:transfer:add')")
    @OperationLog(module = "Transfer Task", businessType = "INSERT", description = "Batch create transfer tasks")
    public R<List<Long>> createBatchTasks(@Valid @RequestBody TransferTaskBatchCreateDTO createDTO) {
        return R.success(transferTaskService.createBatchTasks(createDTO));
    }

    @GetMapping("/my/page")
    @PreAuthorize("hasAuthority('inventory:transfer:my:view')")
    public R<PageResponse<TransferTaskListVO>> myTaskPage(@Valid TransferTaskPageQueryDTO queryDTO) {
        return R.success(transferTaskService.myTaskPage(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('inventory:transfer:view','inventory:transfer:my:view')")
    public R<TransferTaskDetailVO> taskDetail(@PathVariable Long id) {
        return R.success(transferTaskService.taskDetail(id));
    }

    @PostMapping("/{id}/confirm")
    @PreAuthorize("hasAuthority('inventory:transfer:confirm')")
    @OperationLog(module = "Transfer Task", businessType = "UPDATE", description = "Confirm transfer task")
    public R<Void> confirmTask(@PathVariable Long id, @Valid @RequestBody TransferTaskConfirmDTO confirmDTO) {
        transferTaskService.confirmTask(id, confirmDTO);
        return R.success();
    }
}

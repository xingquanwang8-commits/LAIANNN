package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.R;
import com.mhmp.dto.RelicBatchTransferDTO;
import com.mhmp.dto.RelicCategoryCreateDTO;
import com.mhmp.dto.RelicMaterialCreateDTO;
import com.mhmp.dto.RelicPageQueryDTO;
import com.mhmp.dto.RelicSaveDTO;
import com.mhmp.dto.RelicTransferDTO;
import com.mhmp.service.RelicService;
import com.mhmp.vo.RelicAttachmentVO;
import com.mhmp.vo.RelicDetailVO;
import com.mhmp.vo.RelicListVO;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Validated
@RestController
@RequestMapping("/api/relic")
public class RelicController {

    private final RelicService relicService;

    public RelicController(RelicService relicService) {
        this.relicService = relicService;
    }

    @GetMapping("/page")
    @PreAuthorize("hasAnyAuthority('relic:list:view','relic:view')")
    public R<PageResponse<RelicListVO>> page(@Valid RelicPageQueryDTO queryDTO) {
        return R.success(relicService.page(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('relic:detail:view','relic:view','relic:list:view')")
    public R<RelicDetailVO> detail(@PathVariable Long id) {
        return R.success(relicService.detail(id));
    }

    @GetMapping("/{id}/attachments")
    @PreAuthorize("hasAnyAuthority('relic:detail:view','relic:view','relic:list:view')")
    public R<List<RelicAttachmentVO>> attachments(@PathVariable Long id) {
        return R.success(relicService.listAttachments(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('relic:add')")
    @OperationLog(module = "Relic", businessType = "INSERT", description = "Create relic")
    public R<Long> create(@Valid @RequestBody RelicSaveDTO saveDTO) {
        return R.success(relicService.create(saveDTO));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('relic:edit')")
    @OperationLog(module = "Relic", businessType = "UPDATE", description = "Update relic")
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody RelicSaveDTO saveDTO) {
        relicService.update(id, saveDTO);
        return R.success();
    }

    @PostMapping("/categories")
    @PreAuthorize("hasAnyAuthority('relic:add','relic:edit')")
    @OperationLog(module = "Relic", businessType = "INSERT", description = "Create relic category")
    public R<String> createCategory(@Valid @RequestBody RelicCategoryCreateDTO createDTO) {
        return R.success(relicService.createCategory(createDTO.getCategoryName()));
    }

    @PostMapping("/materials")
    @PreAuthorize("hasAnyAuthority('relic:add','relic:edit')")
    @OperationLog(module = "Relic", businessType = "INSERT", description = "Create relic material")
    public R<String> createMaterial(@Valid @RequestBody RelicMaterialCreateDTO createDTO) {
        return R.success(relicService.createMaterial(createDTO.getMaterialName()));
    }

    @PostMapping("/{id}/transfer")
    @PreAuthorize("hasAuthority('relic:edit')")
    @OperationLog(module = "Relic", businessType = "UPDATE", description = "Transfer relic location")
    public R<Void> transfer(@PathVariable Long id, @Valid @RequestBody RelicTransferDTO transferDTO) {
        relicService.transfer(id, transferDTO);
        return R.success();
    }

    @PostMapping("/transfer/batch")
    @PreAuthorize("hasAuthority('relic:edit')")
    @OperationLog(module = "Relic", businessType = "UPDATE", description = "Batch transfer relic location")
    public R<Void> batchTransfer(@Valid @RequestBody RelicBatchTransferDTO transferDTO) {
        relicService.batchTransfer(transferDTO);
        return R.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('relic:delete')")
    @OperationLog(module = "Relic", businessType = "DELETE", description = "Delete relic")
    public R<Void> delete(@PathVariable Long id) {
        relicService.delete(id);
        return R.success();
    }
}

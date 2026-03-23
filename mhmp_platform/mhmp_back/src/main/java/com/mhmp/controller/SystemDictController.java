package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.Result;
import com.mhmp.dto.DictImportDTO;
import com.mhmp.dto.DictItemSaveDTO;
import com.mhmp.dto.DictTypePageQueryDTO;
import com.mhmp.dto.DictTypeSaveDTO;
import com.mhmp.service.DictService;
import com.mhmp.vo.DictItemVO;
import com.mhmp.vo.DictTypeVO;
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
@RequestMapping("/api/system/dicts")
public class SystemDictController {

    private final DictService dictService;

    public SystemDictController(DictService dictService) {
        this.dictService = dictService;
    }

    @GetMapping("/types/page")
    @PreAuthorize("hasAuthority('sys:dict:view')")
    public Result<PageResponse<DictTypeVO>> pageTypes(@Valid DictTypePageQueryDTO queryDTO) {
        return Result.success(dictService.pageTypes(queryDTO));
    }

    @PostMapping("/types")
    @PreAuthorize("hasAuthority('sys:dict:view')")
    @OperationLog(module = "字典管理", businessType = "INSERT", description = "新增字典类型")
    public Result<Long> createType(@Valid @RequestBody DictTypeSaveDTO saveDTO) {
        return Result.success("新增成功", dictService.createType(saveDTO));
    }

    @PutMapping("/types/{id}")
    @PreAuthorize("hasAuthority('sys:dict:view')")
    @OperationLog(module = "字典管理", businessType = "UPDATE", description = "编辑字典类型")
    public Result<Void> updateType(@PathVariable Long id, @Valid @RequestBody DictTypeSaveDTO saveDTO) {
        dictService.updateType(id, saveDTO);
        return Result.success();
    }

    @DeleteMapping("/types/{id}")
    @PreAuthorize("hasAuthority('sys:dict:view')")
    @OperationLog(module = "字典管理", businessType = "DELETE", description = "删除字典类型")
    public Result<Void> deleteType(@PathVariable Long id) {
        dictService.deleteType(id);
        return Result.success();
    }

    @GetMapping("/{dictTypeCode}/items")
    @PreAuthorize("hasAuthority('sys:dict:view')")
    public Result<List<DictItemVO>> allItems(@PathVariable String dictTypeCode) {
        return Result.success(dictService.listAllItemsByType(dictTypeCode));
    }

    @PostMapping("/items")
    @PreAuthorize("hasAuthority('sys:dict:view')")
    @OperationLog(module = "字典管理", businessType = "INSERT", description = "新增字典项")
    public Result<Long> createItem(@Valid @RequestBody DictItemSaveDTO saveDTO) {
        return Result.success("新增成功", dictService.createItem(saveDTO));
    }

    @PutMapping("/items/{id}")
    @PreAuthorize("hasAuthority('sys:dict:view')")
    @OperationLog(module = "字典管理", businessType = "UPDATE", description = "编辑字典项")
    public Result<Void> updateItem(@PathVariable Long id, @Valid @RequestBody DictItemSaveDTO saveDTO) {
        dictService.updateItem(id, saveDTO);
        return Result.success();
    }

    @DeleteMapping("/items/{id}")
    @PreAuthorize("hasAuthority('sys:dict:view')")
    @OperationLog(module = "字典管理", businessType = "DELETE", description = "删除字典项")
    public Result<Void> deleteItem(@PathVariable Long id) {
        dictService.deleteItem(id);
        return Result.success();
    }

    @PostMapping("/import")
    @PreAuthorize("hasAuthority('sys:dict:import')")
    @OperationLog(module = "字典管理", businessType = "IMPORT", description = "导入字典项")
    public Result<Void> importItems(@Valid @RequestBody DictImportDTO importDTO) {
        dictService.importItems(importDTO);
        return Result.success();
    }
}

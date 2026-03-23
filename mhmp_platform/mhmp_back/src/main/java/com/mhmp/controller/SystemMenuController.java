package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.Result;
import com.mhmp.dto.MenuSaveDTO;
import com.mhmp.service.SystemMenuService;
import com.mhmp.vo.SystemMenuTreeVO;
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
@RequestMapping("/api/system/menus")
public class SystemMenuController {

    private final SystemMenuService systemMenuService;

    public SystemMenuController(SystemMenuService systemMenuService) {
        this.systemMenuService = systemMenuService;
    }

    @GetMapping("/tree")
    @PreAuthorize("hasAuthority('sys:menu:view')")
    public Result<List<SystemMenuTreeVO>> tree() {
        return Result.success(systemMenuService.tree());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:menu:view')")
    public Result<SystemMenuTreeVO> detail(@PathVariable Long id) {
        return Result.success(systemMenuService.detail(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('sys:menu:add')")
    @OperationLog(module = "菜单管理", businessType = "INSERT", description = "新增菜单")
    public Result<Long> create(@Valid @RequestBody MenuSaveDTO saveDTO) {
        return Result.success("新增成功", systemMenuService.create(saveDTO));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:menu:add')")
    @OperationLog(module = "菜单管理", businessType = "UPDATE", description = "编辑菜单")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody MenuSaveDTO saveDTO) {
        systemMenuService.update(id, saveDTO);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:menu:add')")
    @OperationLog(module = "菜单管理", businessType = "DELETE", description = "删除菜单")
    public Result<Void> delete(@PathVariable Long id) {
        systemMenuService.delete(id);
        return Result.success();
    }
}

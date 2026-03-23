package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.Result;
import com.mhmp.dto.RoleGrantMenuDTO;
import com.mhmp.dto.RolePageQueryDTO;
import com.mhmp.dto.RoleSaveDTO;
import com.mhmp.dto.RoleStatusDTO;
import com.mhmp.service.SystemRoleService;
import com.mhmp.vo.RoleDetailVO;
import com.mhmp.vo.RoleListVO;
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
@RequestMapping("/api/system/roles")
public class SystemRoleController {

    private final SystemRoleService systemRoleService;

    public SystemRoleController(SystemRoleService systemRoleService) {
        this.systemRoleService = systemRoleService;
    }

    @GetMapping("/page")
    @PreAuthorize("hasAuthority('sys:role:view')")
    public Result<PageResponse<RoleListVO>> page(@Valid RolePageQueryDTO queryDTO) {
        return Result.success(systemRoleService.page(queryDTO));
    }

    @GetMapping("/list")
    @PreAuthorize("hasAuthority('sys:role:view')")
    public Result<List<RoleListVO>> list() {
        return Result.success(systemRoleService.listAll());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:role:view')")
    public Result<RoleDetailVO> detail(@PathVariable Long id) {
        return Result.success(systemRoleService.detail(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('sys:role:view')")
    @OperationLog(module = "角色管理", businessType = "INSERT", description = "新增角色")
    public Result<Long> create(@Valid @RequestBody RoleSaveDTO saveDTO) {
        return Result.success("新增成功", systemRoleService.create(saveDTO));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:role:view')")
    @OperationLog(module = "角色管理", businessType = "UPDATE", description = "编辑角色")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody RoleSaveDTO saveDTO) {
        systemRoleService.update(id, saveDTO);
        return Result.success();
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasAuthority('sys:role:view')")
    @OperationLog(module = "角色管理", businessType = "UPDATE", description = "修改角色状态")
    public Result<Void> updateStatus(@PathVariable Long id, @Valid @RequestBody RoleStatusDTO statusDTO) {
        systemRoleService.updateStatus(id, statusDTO.getStatus());
        return Result.success();
    }

    @PutMapping("/{id}/menus")
    @PreAuthorize("hasAuthority('sys:role:assign')")
    @OperationLog(module = "角色管理", businessType = "UPDATE", description = "角色授权菜单")
    public Result<Void> grantMenus(@PathVariable Long id, @RequestBody RoleGrantMenuDTO grantMenuDTO) {
        systemRoleService.grantMenus(id, grantMenuDTO == null ? List.of() : grantMenuDTO.getMenuIds());
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:role:view')")
    @OperationLog(module = "角色管理", businessType = "DELETE", description = "删除角色")
    public Result<Void> delete(@PathVariable Long id) {
        systemRoleService.delete(id);
        return Result.success();
    }
}

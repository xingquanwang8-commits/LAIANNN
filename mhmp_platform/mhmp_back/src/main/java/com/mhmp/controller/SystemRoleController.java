package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.R;
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
    public R<PageResponse<RoleListVO>> page(@Valid RolePageQueryDTO queryDTO) {
        return R.success(systemRoleService.page(queryDTO));
    }

    @GetMapping("/list")
    @PreAuthorize("hasAuthority('sys:role:view')")
    public R<List<RoleListVO>> list() {
        return R.success(systemRoleService.listAll());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:role:view')")
    public R<RoleDetailVO> detail(@PathVariable Long id) {
        return R.success(systemRoleService.detail(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('sys:role:add')")
    @OperationLog(module = "角色管理", businessType = "INSERT", description = "新增角色")
    public R<Long> create(@Valid @RequestBody RoleSaveDTO saveDTO) {
        return R.success("新增成功", systemRoleService.create(saveDTO));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:role:edit')")
    @OperationLog(module = "角色管理", businessType = "UPDATE", description = "编辑角色")
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody RoleSaveDTO saveDTO) {
        systemRoleService.update(id, saveDTO);
        return R.success();
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasAuthority('sys:role:status')")
    @OperationLog(module = "角色管理", businessType = "UPDATE", description = "修改角色状态")
    public R<Void> updateStatus(@PathVariable Long id, @Valid @RequestBody RoleStatusDTO statusDTO) {
        systemRoleService.updateStatus(id, statusDTO.getStatus());
        return R.success();
    }

    @PutMapping("/{id}/menus")
    @PreAuthorize("hasAuthority('sys:role:assign')")
    @OperationLog(module = "角色管理", businessType = "UPDATE", description = "角色授权菜单")
    public R<Void> grantMenus(@PathVariable Long id, @RequestBody RoleGrantMenuDTO grantMenuDTO) {
        systemRoleService.grantMenus(id, grantMenuDTO == null ? List.of() : grantMenuDTO.getMenuIds());
        return R.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:role:delete')")
    @OperationLog(module = "角色管理", businessType = "DELETE", description = "删除角色")
    public R<Void> delete(@PathVariable Long id) {
        systemRoleService.delete(id);
        return R.success();
    }
}

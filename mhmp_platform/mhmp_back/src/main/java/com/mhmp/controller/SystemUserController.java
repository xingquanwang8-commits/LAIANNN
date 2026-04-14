package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.R;
import com.mhmp.dto.UserPageQueryDTO;
import com.mhmp.dto.UserSaveDTO;
import com.mhmp.dto.UserStatusDTO;
import com.mhmp.service.SystemUserService;
import com.mhmp.vo.UserDetailVO;
import com.mhmp.vo.UserListVO;
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

@Validated
@RestController
@RequestMapping("/api/system/users")
public class SystemUserController {

    private final SystemUserService systemUserService;

    public SystemUserController(SystemUserService systemUserService) {
        this.systemUserService = systemUserService;
    }

    @GetMapping("/page")
    @PreAuthorize("hasAuthority('sys:user:view')")
    public R<PageResponse<UserListVO>> page(@Valid UserPageQueryDTO queryDTO) {
        return R.success(systemUserService.page(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:user:view')")
    public R<UserDetailVO> detail(@PathVariable Long id) {
        return R.success(systemUserService.detail(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('sys:user:add')")
    @OperationLog(module = "用户管理", businessType = "INSERT", description = "新增用户")
    public R<Long> create(@Valid @RequestBody UserSaveDTO saveDTO) {
        return R.success("新增成功", systemUserService.create(saveDTO));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:user:edit')")
    @OperationLog(module = "用户管理", businessType = "UPDATE", description = "编辑用户")
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody UserSaveDTO saveDTO) {
        systemUserService.update(id, saveDTO);
        return R.success();
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasAuthority('sys:user:edit')")
    @OperationLog(module = "用户管理", businessType = "UPDATE", description = "修改用户状态")
    public R<Void> updateStatus(@PathVariable Long id, @Valid @RequestBody UserStatusDTO statusDTO) {
        systemUserService.updateStatus(id, statusDTO.getStatus());
        return R.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('sys:user:delete')")
    @OperationLog(module = "用户管理", businessType = "DELETE", description = "删除用户")
    public R<Void> delete(@PathVariable Long id) {
        systemUserService.delete(id);
        return R.success();
    }
}

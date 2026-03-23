package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.UserPageQueryDTO;
import com.mhmp.dto.UserSaveDTO;
import com.mhmp.entity.SysRole;
import com.mhmp.entity.SysUser;
import com.mhmp.entity.SysUserRole;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.mapper.SysUserRoleMapper;
import com.mhmp.service.SystemUserService;
import com.mhmp.vo.UserDetailVO;
import com.mhmp.vo.UserListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class SystemUserServiceImpl implements SystemUserService {

    private final SysUserMapper sysUserMapper;
    private final SysRoleMapper sysRoleMapper;
    private final SysUserRoleMapper sysUserRoleMapper;
    private final PasswordEncoder passwordEncoder;

    public SystemUserServiceImpl(SysUserMapper sysUserMapper,
                                 SysRoleMapper sysRoleMapper,
                                 SysUserRoleMapper sysUserRoleMapper,
                                 PasswordEncoder passwordEncoder) {
        this.sysUserMapper = sysUserMapper;
        this.sysRoleMapper = sysRoleMapper;
        this.sysUserRoleMapper = sysUserRoleMapper;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public PageResponse<UserListVO> page(UserPageQueryDTO queryDTO) {
        Set<Long> scopedUserIds = findUserIdsByRole(queryDTO.getRoleId());
        if (queryDTO.getRoleId() != null && scopedUserIds.isEmpty()) {
            return new PageResponse<>(0L, queryDTO.getPageNum(), queryDTO.getPageSize(), List.of());
        }
        Page<SysUser> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<SysUser> resultPage = sysUserMapper.selectPage(page,
            Wrappers.<SysUser>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(SysUser::getUsername, queryDTO.getKeyword())
                        .or().like(SysUser::getRealName, queryDTO.getKeyword())
                        .or().like(SysUser::getNickName, queryDTO.getKeyword())
                        .or().like(SysUser::getPhone, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getStatus()), SysUser::getStatus, queryDTO.getStatus())
                .in(queryDTO.getRoleId() != null, SysUser::getId, scopedUserIds.isEmpty() ? List.of(-1L) : scopedUserIds)
                .orderByDesc(SysUser::getUpdateTime)
                .orderByDesc(SysUser::getId)
        );
        List<UserListVO> records = buildUserList(resultPage.getRecords());
        return PageResponse.of(resultPage, records);
    }

    @Override
    public UserDetailVO detail(Long id) {
        SysUser user = getUserOrThrow(id);
        UserDetailVO vo = new UserDetailVO();
        BeanUtils.copyProperties(user, vo);
        vo.setRoleIds(sysUserRoleMapper.selectRoleIdsByUserId(id));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(UserSaveDTO saveDTO) {
        if (sysUserMapper.findByUsername(saveDTO.getUsername()) != null) {
            throw new BusinessException("Username already exists");
        }
        List<SysRole> roles = validateRoles(saveDTO.getRoleIds());
        SysUser entity = new SysUser();
        fillUser(entity, saveDTO);
        entity.setPassword(passwordEncoder.encode(StringUtils.hasText(saveDTO.getPassword()) ? saveDTO.getPassword() : "123456"));
        entity.setDeleted(0);
        entity.setCreateBy(SecurityUtils.getUserId());
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysUserMapper.insert(entity);
        syncRoles(entity.getId(), roles);
        return entity.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Long id, UserSaveDTO saveDTO) {
        SysUser entity = getUserOrThrow(id);
        SysUser duplicate = sysUserMapper.findByUsername(saveDTO.getUsername());
        if (duplicate != null && !Objects.equals(duplicate.getId(), id)) {
            throw new BusinessException("Username already exists");
        }
        if (Objects.equals(SecurityUtils.getUserId(), id) && "DISABLED".equals(saveDTO.getStatus())) {
            throw new BusinessException("Current user cannot be disabled");
        }
        List<SysRole> roles = validateRoles(saveDTO.getRoleIds());
        fillUser(entity, saveDTO);
        if (StringUtils.hasText(saveDTO.getPassword())) {
            entity.setPassword(passwordEncoder.encode(saveDTO.getPassword()));
        }
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysUserMapper.updateById(entity);
        syncRoles(id, roles);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        if (Objects.equals(SecurityUtils.getUserId(), id)) {
            throw new BusinessException("Current user cannot be deleted");
        }
        getUserOrThrow(id);
        sysUserRoleMapper.delete(Wrappers.<SysUserRole>lambdaQuery().eq(SysUserRole::getUserId, id));
        sysUserMapper.deleteById(id);
    }

    @Override
    public void updateStatus(Long id, String status) {
        SysUser user = getUserOrThrow(id);
        if (Objects.equals(SecurityUtils.getUserId(), id) && "DISABLED".equals(status)) {
            throw new BusinessException("Current user cannot be disabled");
        }
        user.setStatus(status);
        user.setUpdateBy(SecurityUtils.getUserId());
        sysUserMapper.updateById(user);
    }

    private SysUser getUserOrThrow(Long id) {
        SysUser user = sysUserMapper.selectById(id);
        if (user == null) {
            throw new BusinessException("User does not exist");
        }
        return user;
    }

    private void fillUser(SysUser entity, UserSaveDTO saveDTO) {
        entity.setUsername(saveDTO.getUsername());
        entity.setNickName(saveDTO.getNickName());
        entity.setRealName(saveDTO.getRealName());
        entity.setPhone(saveDTO.getPhone());
        entity.setEmail(saveDTO.getEmail());
        entity.setGender(saveDTO.getGender());
        entity.setAvatarUrl(saveDTO.getAvatarUrl());
        entity.setStatus(StringUtils.hasText(saveDTO.getStatus()) ? saveDTO.getStatus() : "ENABLED");
        entity.setRemark(saveDTO.getRemark());
    }

    private List<SysRole> validateRoles(List<Long> roleIds) {
        if (CollectionUtils.isEmpty(roleIds)) {
            return List.of();
        }
        List<SysRole> roles = sysRoleMapper.selectBatchIds(roleIds.stream().distinct().toList());
        if (roles.size() != roleIds.stream().distinct().count()) {
            throw new BusinessException("Selected roles contain invalid data");
        }
        return roles;
    }

    private void syncRoles(Long userId, List<SysRole> roles) {
        sysUserRoleMapper.delete(Wrappers.<SysUserRole>lambdaQuery().eq(SysUserRole::getUserId, userId));
        Long currentUserId = SecurityUtils.getUserId();
        for (SysRole role : roles) {
            SysUserRole relation = new SysUserRole();
            relation.setUserId(userId);
            relation.setRoleId(role.getId());
            relation.setCreateBy(currentUserId);
            relation.setUpdateBy(currentUserId);
            relation.setDeleted(0);
            sysUserRoleMapper.insert(relation);
        }
    }

    private Set<Long> findUserIdsByRole(Long roleId) {
        if (roleId == null) {
            return Collections.emptySet();
        }
        return sysUserRoleMapper.selectList(
                Wrappers.<SysUserRole>lambdaQuery().eq(SysUserRole::getRoleId, roleId)
            ).stream()
            .map(SysUserRole::getUserId)
            .collect(Collectors.toSet());
    }

    private List<UserListVO> buildUserList(List<SysUser> users) {
        if (CollectionUtils.isEmpty(users)) {
            return List.of();
        }
        Map<Long, List<SysRole>> roleMap = loadRoleMap(users.stream().map(SysUser::getId).toList());
        List<UserListVO> result = new ArrayList<>();
        for (SysUser user : users) {
            UserListVO vo = new UserListVO();
            BeanUtils.copyProperties(user, vo);
            List<SysRole> roles = roleMap.getOrDefault(user.getId(), List.of());
            vo.setRoleIds(roles.stream().map(SysRole::getId).toList());
            vo.setRoleNames(roles.stream().map(SysRole::getRoleName).toList());
            result.add(vo);
        }
        return result;
    }

    private Map<Long, List<SysRole>> loadRoleMap(Collection<Long> userIds) {
        List<SysUserRole> relations = sysUserRoleMapper.selectList(
            Wrappers.<SysUserRole>lambdaQuery().in(SysUserRole::getUserId, userIds)
        );
        if (relations.isEmpty()) {
            return Map.of();
        }
        Map<Long, SysRole> roleMap = sysRoleMapper.selectBatchIds(
                relations.stream().map(SysUserRole::getRoleId).distinct().toList()
            ).stream()
            .collect(Collectors.toMap(SysRole::getId, role -> role));
        Map<Long, List<SysRole>> result = new LinkedHashMap<>();
        for (SysUserRole relation : relations) {
            result.computeIfAbsent(relation.getUserId(), key -> new ArrayList<>());
            SysRole role = roleMap.get(relation.getRoleId());
            if (role != null) {
                result.get(relation.getUserId()).add(role);
            }
        }
        return result;
    }
}

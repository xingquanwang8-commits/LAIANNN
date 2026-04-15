package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.RolePageQueryDTO;
import com.mhmp.dto.RoleSaveDTO;
import com.mhmp.entity.SysMenu;
import com.mhmp.entity.SysRole;
import com.mhmp.entity.SysRoleMenu;
import com.mhmp.entity.SysUserRole;
import com.mhmp.mapper.SysMenuMapper;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysRoleMenuMapper;
import com.mhmp.mapper.SysUserRoleMapper;
import com.mhmp.service.SystemRoleService;
import com.mhmp.vo.RoleDetailVO;
import com.mhmp.vo.RoleListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class SystemRoleServiceImpl implements SystemRoleService {

    private final SysRoleMapper sysRoleMapper;
    private final SysUserRoleMapper sysUserRoleMapper;
    private final SysRoleMenuMapper sysRoleMenuMapper;
    private final SysMenuMapper sysMenuMapper;

    public SystemRoleServiceImpl(SysRoleMapper sysRoleMapper,
                                 SysUserRoleMapper sysUserRoleMapper,
                                 SysRoleMenuMapper sysRoleMenuMapper,
                                 SysMenuMapper sysMenuMapper) {
        this.sysRoleMapper = sysRoleMapper;
        this.sysUserRoleMapper = sysUserRoleMapper;
        this.sysRoleMenuMapper = sysRoleMenuMapper;
        this.sysMenuMapper = sysMenuMapper;
    }

    @Override
    public PageResponse<RoleListVO> page(RolePageQueryDTO queryDTO) {
        Page<SysRole> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<SysRole> resultPage = sysRoleMapper.selectPage(page,
            Wrappers.<SysRole>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(SysRole::getRoleName, queryDTO.getKeyword())
                        .or().like(SysRole::getRoleCode, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getStatus()), SysRole::getStatus, queryDTO.getStatus())
                .orderByAsc(SysRole::getId)
        );
        Map<Long, RoleRelationStats> relationStatsMap = loadRelationStats(resultPage.getRecords().stream()
            .map(SysRole::getId)
            .toList());
        List<RoleListVO> records = resultPage.getRecords().stream()
            .map(role -> toListVO(role, relationStatsMap))
            .toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public List<RoleListVO> listAll() {
        List<SysRole> roles = sysRoleMapper.selectList(
            Wrappers.<SysRole>lambdaQuery().orderByAsc(SysRole::getId)
        );
        Map<Long, RoleRelationStats> relationStatsMap = loadRelationStats(roles.stream()
            .map(SysRole::getId)
            .toList());
        return roles.stream()
            .map(role -> toListVO(role, relationStatsMap))
            .toList();
    }

    @Override
    public RoleDetailVO detail(Long id) {
        SysRole role = getRoleOrThrow(id);
        RoleDetailVO vo = new RoleDetailVO();
        BeanUtils.copyProperties(role, vo);
        vo.setMenuIds(sysRoleMenuMapper.selectMenuIdsByRoleId(id));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(RoleSaveDTO saveDTO) {
        if (sysRoleMapper.findByRoleCode(saveDTO.getRoleCode()) != null) {
            throw new BusinessException("Role code already exists");
        }
        SysRole entity = new SysRole();
        fillRole(entity, saveDTO);
        entity.setDeleted(0);
        entity.setCreateBy(SecurityUtils.getUserId());
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysRoleMapper.insert(entity);
        return entity.getId();
    }

    @Override
    public void update(Long id, RoleSaveDTO saveDTO) {
        SysRole entity = getRoleOrThrow(id);
        SysRole duplicate = sysRoleMapper.findByRoleCode(saveDTO.getRoleCode());
        if (duplicate != null && !Objects.equals(duplicate.getId(), id)) {
            throw new BusinessException("Role code already exists");
        }
        fillRole(entity, saveDTO);
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysRoleMapper.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        getRoleOrThrow(id);
        if (sysUserRoleMapper.countByRoleId(id) > 0) {
            throw new BusinessException("Role is still assigned to users");
        }
        sysRoleMenuMapper.delete(Wrappers.<SysRoleMenu>lambdaQuery().eq(SysRoleMenu::getRoleId, id));
        sysRoleMapper.deleteById(id);
    }

    @Override
    public void updateStatus(Long id, String status) {
        SysRole entity = getRoleOrThrow(id);
        entity.setStatus(status);
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysRoleMapper.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void grantMenus(Long id, List<Long> menuIds) {
        getRoleOrThrow(id);
        List<Long> targetMenuIds = CollectionUtils.isEmpty(menuIds)
            ? List.of()
            : menuIds.stream()
                .filter(Objects::nonNull)
                .distinct()
                .toList();
        validateMenus(targetMenuIds);
        Long currentUserId = SecurityUtils.getUserId();
        Set<Long> targetMenuIdSet = new LinkedHashSet<>(targetMenuIds);
        // sys_role_menu uses logical deletion and a unique(role_id, menu_id) key, so grant updates
        // must reactivate existing rows instead of delete-then-insert.
        Map<Long, SysRoleMenu> existingRelationMap = sysRoleMenuMapper.selectAllByRoleId(id).stream()
            .collect(Collectors.toMap(SysRoleMenu::getMenuId, relation -> relation, (left, right) -> left));

        for (SysRoleMenu relation : existingRelationMap.values()) {
            int nextDeleted = targetMenuIdSet.contains(relation.getMenuId()) ? 0 : 1;
            int currentDeleted = relation.getDeleted() == null ? 0 : relation.getDeleted();
            if (currentDeleted == nextDeleted) {
                continue;
            }
            sysRoleMenuMapper.updateDeletedStatus(id, relation.getMenuId(), nextDeleted, currentUserId);
        }

        for (Long menuId : targetMenuIdSet) {
            if (existingRelationMap.containsKey(menuId)) {
                continue;
            }
            SysRoleMenu relation = new SysRoleMenu();
            relation.setRoleId(id);
            relation.setMenuId(menuId);
            relation.setCreateBy(currentUserId);
            relation.setUpdateBy(currentUserId);
            relation.setDeleted(0);
            sysRoleMenuMapper.insert(relation);
        }
    }

    // 角色列表只需要统计值，批量加载关联关系即可避免逐角色重复查询。
    private Map<Long, RoleRelationStats> loadRelationStats(List<Long> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) {
            return Collections.emptyMap();
        }
        Map<Long, Long> userCountMap = sysUserRoleMapper.selectList(
                Wrappers.<SysUserRole>lambdaQuery()
                    .in(SysUserRole::getRoleId, roleIds)
            ).stream()
            .collect(Collectors.groupingBy(SysUserRole::getRoleId, Collectors.counting()));
        Map<Long, Long> menuCountMap = sysRoleMenuMapper.selectList(
                Wrappers.<SysRoleMenu>lambdaQuery()
                    .in(SysRoleMenu::getRoleId, roleIds)
            ).stream()
            .collect(Collectors.groupingBy(SysRoleMenu::getRoleId, Collectors.counting()));
        return roleIds.stream().distinct().collect(Collectors.toMap(
            roleId -> roleId,
            roleId -> new RoleRelationStats(
                Math.toIntExact(userCountMap.getOrDefault(roleId, 0L)),
                Math.toIntExact(menuCountMap.getOrDefault(roleId, 0L))
            )
        ));
    }

    private RoleListVO toListVO(SysRole entity, Map<Long, RoleRelationStats> relationStatsMap) {
        RoleListVO vo = new RoleListVO();
        BeanUtils.copyProperties(entity, vo);
        RoleRelationStats stats = relationStatsMap.getOrDefault(entity.getId(), RoleRelationStats.EMPTY);
        vo.setUserCount(stats.userCount());
        vo.setMenuCount(stats.menuCount());
        return vo;
    }

    private void fillRole(SysRole entity, RoleSaveDTO saveDTO) {
        entity.setRoleName(saveDTO.getRoleName());
        entity.setRoleCode(saveDTO.getRoleCode());
        entity.setStatus(StringUtils.hasText(saveDTO.getStatus()) ? saveDTO.getStatus() : "ENABLED");
        entity.setRemark(saveDTO.getRemark());
    }

    private SysRole getRoleOrThrow(Long id) {
        SysRole role = sysRoleMapper.selectById(id);
        if (role == null) {
            throw new BusinessException("Role does not exist");
        }
        return role;
    }

    private void validateMenus(List<Long> menuIds) {
        if (CollectionUtils.isEmpty(menuIds)) {
            return;
        }
        Map<Long, SysMenu> menuMap = sysMenuMapper.selectBatchIds(menuIds.stream().distinct().toList())
            .stream()
            .collect(Collectors.toMap(SysMenu::getId, menu -> menu));
        if (menuMap.size() != menuIds.stream().distinct().count()) {
            throw new BusinessException("Selected menus contain invalid data");
        }
    }

    private record RoleRelationStats(int userCount, int menuCount) {

        private static final RoleRelationStats EMPTY = new RoleRelationStats(0, 0);
    }
}

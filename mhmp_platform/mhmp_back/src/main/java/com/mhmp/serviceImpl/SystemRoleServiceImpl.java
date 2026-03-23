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

import java.util.List;
import java.util.Map;
import java.util.Objects;
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
        List<RoleListVO> records = resultPage.getRecords().stream().map(this::toListVO).toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public List<RoleListVO> listAll() {
        return sysRoleMapper.selectList(
                Wrappers.<SysRole>lambdaQuery().orderByAsc(SysRole::getId)
            ).stream()
            .map(this::toListVO)
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
        validateMenus(menuIds);
        sysRoleMenuMapper.delete(Wrappers.<SysRoleMenu>lambdaQuery().eq(SysRoleMenu::getRoleId, id));
        if (CollectionUtils.isEmpty(menuIds)) {
            return;
        }
        Long currentUserId = SecurityUtils.getUserId();
        for (Long menuId : menuIds.stream().distinct().toList()) {
            SysRoleMenu relation = new SysRoleMenu();
            relation.setRoleId(id);
            relation.setMenuId(menuId);
            relation.setCreateBy(currentUserId);
            relation.setUpdateBy(currentUserId);
            relation.setDeleted(0);
            sysRoleMenuMapper.insert(relation);
        }
    }

    private RoleListVO toListVO(SysRole entity) {
        RoleListVO vo = new RoleListVO();
        BeanUtils.copyProperties(entity, vo);
        vo.setUserCount(Math.toIntExact(sysUserRoleMapper.countByRoleId(entity.getId())));
        vo.setMenuCount(sysRoleMenuMapper.selectMenuIdsByRoleId(entity.getId()).size());
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
}

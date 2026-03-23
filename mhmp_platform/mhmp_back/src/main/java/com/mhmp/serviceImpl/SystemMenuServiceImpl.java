package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.MenuSaveDTO;
import com.mhmp.entity.SysMenu;
import com.mhmp.mapper.SysMenuMapper;
import com.mhmp.mapper.SysRoleMenuMapper;
import com.mhmp.service.SystemMenuService;
import com.mhmp.vo.SystemMenuTreeVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class SystemMenuServiceImpl implements SystemMenuService {

    private final SysMenuMapper sysMenuMapper;
    private final SysRoleMenuMapper sysRoleMenuMapper;

    public SystemMenuServiceImpl(SysMenuMapper sysMenuMapper, SysRoleMenuMapper sysRoleMenuMapper) {
        this.sysMenuMapper = sysMenuMapper;
        this.sysRoleMenuMapper = sysRoleMenuMapper;
    }

    @Override
    public List<SystemMenuTreeVO> tree() {
        List<SysMenu> menus = sysMenuMapper.selectList(
            Wrappers.<SysMenu>lambdaQuery()
                .orderByAsc(SysMenu::getSortNo)
                .orderByAsc(SysMenu::getId)
        );
        return buildTree(menus);
    }

    @Override
    public SystemMenuTreeVO detail(Long id) {
        SysMenu menu = getMenuOrThrow(id);
        SystemMenuTreeVO vo = new SystemMenuTreeVO();
        BeanUtils.copyProperties(menu, vo);
        return vo;
    }

    @Override
    public Long create(MenuSaveDTO saveDTO) {
        ensureMenuCodeUnique(saveDTO.getMenuCode(), null);
        SysMenu entity = new SysMenu();
        fillMenu(entity, saveDTO);
        entity.setDeleted(0);
        entity.setCreateBy(SecurityUtils.getUserId());
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysMenuMapper.insert(entity);
        return entity.getId();
    }

    @Override
    public void update(Long id, MenuSaveDTO saveDTO) {
        SysMenu entity = getMenuOrThrow(id);
        if (Objects.equals(id, saveDTO.getParentId())) {
            throw new BusinessException("Parent menu cannot be self");
        }
        ensureMenuCodeUnique(saveDTO.getMenuCode(), id);
        fillMenu(entity, saveDTO);
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysMenuMapper.updateById(entity);
    }

    @Override
    public void delete(Long id) {
        getMenuOrThrow(id);
        long childCount = sysMenuMapper.selectCount(
            Wrappers.<SysMenu>lambdaQuery().eq(SysMenu::getParentId, id)
        );
        if (childCount > 0) {
            throw new BusinessException("Menu still has child nodes");
        }
        if (sysRoleMenuMapper.countByMenuId(id) > 0) {
            throw new BusinessException("Menu is still assigned to roles");
        }
        sysMenuMapper.deleteById(id);
    }

    private void fillMenu(SysMenu entity, MenuSaveDTO saveDTO) {
        entity.setParentId(saveDTO.getParentId() == null ? 0L : saveDTO.getParentId());
        entity.setMenuName(saveDTO.getMenuName());
        entity.setMenuCode(saveDTO.getMenuCode());
        entity.setMenuType(saveDTO.getMenuType());
        entity.setPath(saveDTO.getPath());
        entity.setComponent(saveDTO.getComponent());
        entity.setPermissionCode(saveDTO.getPermissionCode());
        entity.setSortNo(saveDTO.getSortNo());
        entity.setVisible(saveDTO.getVisible() == null ? 1 : saveDTO.getVisible());
        entity.setStatus(StringUtils.hasText(saveDTO.getStatus()) ? saveDTO.getStatus() : "ENABLED");
        entity.setIcon(saveDTO.getIcon());
        entity.setKeepAlive(saveDTO.getKeepAlive() == null ? 0 : saveDTO.getKeepAlive());
        entity.setRemark(saveDTO.getRemark());
    }

    private void ensureMenuCodeUnique(String menuCode, Long excludeId) {
        SysMenu duplicate = sysMenuMapper.selectOne(
            Wrappers.<SysMenu>lambdaQuery().eq(SysMenu::getMenuCode, menuCode).last("LIMIT 1")
        );
        if (duplicate != null && !Objects.equals(duplicate.getId(), excludeId)) {
            throw new BusinessException("Menu code already exists");
        }
    }

    private SysMenu getMenuOrThrow(Long id) {
        SysMenu menu = sysMenuMapper.selectById(id);
        if (menu == null) {
            throw new BusinessException("Menu does not exist");
        }
        return menu;
    }

    private List<SystemMenuTreeVO> buildTree(List<SysMenu> menus) {
        Map<Long, SystemMenuTreeVO> menuMap = new LinkedHashMap<>();
        for (SysMenu menu : menus) {
            SystemMenuTreeVO vo = new SystemMenuTreeVO();
            BeanUtils.copyProperties(menu, vo);
            menuMap.put(vo.getId(), vo);
        }
        List<SystemMenuTreeVO> roots = new ArrayList<>();
        for (SystemMenuTreeVO vo : menuMap.values()) {
            if (vo.getParentId() == null || vo.getParentId() == 0L || !menuMap.containsKey(vo.getParentId())) {
                roots.add(vo);
            } else {
                menuMap.get(vo.getParentId()).getChildren().add(vo);
            }
        }
        return roots;
    }
}

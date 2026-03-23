package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.DictImportDTO;
import com.mhmp.dto.DictItemSaveDTO;
import com.mhmp.dto.DictTypePageQueryDTO;
import com.mhmp.dto.DictTypeSaveDTO;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.entity.SysDictItem;
import com.mhmp.entity.SysDictType;
import com.mhmp.mapper.SysDictItemMapper;
import com.mhmp.mapper.SysDictTypeMapper;
import com.mhmp.service.DictService;
import com.mhmp.vo.DictItemVO;
import com.mhmp.vo.DictTypeVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;

@Service
public class DictServiceImpl implements DictService {

    private final SysDictTypeMapper sysDictTypeMapper;
    private final SysDictItemMapper sysDictItemMapper;

    public DictServiceImpl(SysDictTypeMapper sysDictTypeMapper, SysDictItemMapper sysDictItemMapper) {
        this.sysDictTypeMapper = sysDictTypeMapper;
        this.sysDictItemMapper = sysDictItemMapper;
    }

    @Override
    public List<DictTypeVO> listTypes() {
        return sysDictTypeMapper.selectList(
                Wrappers.<SysDictType>lambdaQuery()
                    .eq(SysDictType::getStatus, "ENABLED")
                    .orderByAsc(SysDictType::getId)
            ).stream()
            .map(this::toTypeVO)
            .toList();
    }

    @Override
    public List<DictItemVO> listItemsByType(String dictTypeCode) {
        return sysDictItemMapper.selectList(
                Wrappers.<SysDictItem>lambdaQuery()
                    .eq(SysDictItem::getDictTypeCode, dictTypeCode)
                    .eq(SysDictItem::getStatus, "ENABLED")
                    .orderByAsc(SysDictItem::getItemSort)
                    .orderByAsc(SysDictItem::getId)
            ).stream()
            .map(this::toItemVO)
            .toList();
    }

    @Override
    public List<DictItemVO> listAllItemsByType(String dictTypeCode) {
        ensureTypeExists(dictTypeCode);
        return sysDictItemMapper.selectList(
                Wrappers.<SysDictItem>lambdaQuery()
                    .eq(SysDictItem::getDictTypeCode, dictTypeCode)
                    .orderByAsc(SysDictItem::getItemSort)
                    .orderByAsc(SysDictItem::getId)
            ).stream()
            .map(this::toItemVO)
            .toList();
    }

    @Override
    public PageResponse<DictTypeVO> pageTypes(DictTypePageQueryDTO queryDTO) {
        Page<SysDictType> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<SysDictType> resultPage = sysDictTypeMapper.selectPage(page,
            Wrappers.<SysDictType>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(SysDictType::getDictName, queryDTO.getKeyword())
                        .or().like(SysDictType::getDictTypeCode, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getStatus()), SysDictType::getStatus, queryDTO.getStatus())
                .orderByAsc(SysDictType::getId)
        );
        return PageResponse.of(resultPage, resultPage.getRecords().stream().map(this::toTypeVO).toList());
    }

    @Override
    public Long createType(DictTypeSaveDTO saveDTO) {
        ensureTypeCodeUnique(saveDTO.getDictTypeCode(), null);
        SysDictType entity = new SysDictType();
        fillType(entity, saveDTO);
        entity.setDeleted(0);
        entity.setCreateBy(SecurityUtils.getUserId());
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysDictTypeMapper.insert(entity);
        return entity.getId();
    }

    @Override
    public void updateType(Long id, DictTypeSaveDTO saveDTO) {
        SysDictType entity = getTypeOrThrow(id);
        ensureTypeCodeUnique(saveDTO.getDictTypeCode(), id);
        fillType(entity, saveDTO);
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysDictTypeMapper.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteType(Long id) {
        SysDictType entity = getTypeOrThrow(id);
        sysDictItemMapper.delete(Wrappers.<SysDictItem>lambdaQuery().eq(SysDictItem::getDictTypeCode, entity.getDictTypeCode()));
        sysDictTypeMapper.deleteById(id);
    }

    @Override
    public Long createItem(DictItemSaveDTO saveDTO) {
        ensureTypeExists(saveDTO.getDictTypeCode());
        ensureItemValueUnique(saveDTO.getDictTypeCode(), saveDTO.getItemValue(), null);
        SysDictItem entity = new SysDictItem();
        fillItem(entity, saveDTO);
        entity.setDeleted(0);
        entity.setCreateBy(SecurityUtils.getUserId());
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysDictItemMapper.insert(entity);
        return entity.getId();
    }

    @Override
    public void updateItem(Long id, DictItemSaveDTO saveDTO) {
        SysDictItem entity = getItemOrThrow(id);
        ensureTypeExists(saveDTO.getDictTypeCode());
        ensureItemValueUnique(saveDTO.getDictTypeCode(), saveDTO.getItemValue(), id);
        fillItem(entity, saveDTO);
        entity.setUpdateBy(SecurityUtils.getUserId());
        sysDictItemMapper.updateById(entity);
    }

    @Override
    public void deleteItem(Long id) {
        getItemOrThrow(id);
        sysDictItemMapper.deleteById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void importItems(DictImportDTO importDTO) {
        ensureTypeExists(importDTO.getDictTypeCode());
        List<String> lines = Arrays.stream(importDTO.getContent().split("\\r?\\n"))
            .map(String::trim)
            .filter(StringUtils::hasText)
            .toList();
        if (lines.isEmpty()) {
            throw new BusinessException("Import content cannot be empty");
        }
        for (String line : lines) {
            String[] parts = line.split(",");
            if (parts.length < 2) {
                throw new BusinessException("Each line must contain at least itemLabel,itemValue");
            }
            DictItemSaveDTO dto = new DictItemSaveDTO();
            dto.setDictTypeCode(importDTO.getDictTypeCode());
            dto.setItemLabel(parts[0].trim());
            dto.setItemValue(parts[1].trim());
            dto.setItemSort(parts.length > 2 && StringUtils.hasText(parts[2]) ? Integer.parseInt(parts[2].trim()) : 0);
            dto.setStatus(parts.length > 3 && StringUtils.hasText(parts[3]) ? parts[3].trim() : "ENABLED");
            dto.setCssClass(parts.length > 4 ? parts[4].trim() : null);
            dto.setRemark(parts.length > 5 ? parts[5].trim() : null);
            SysDictItem existing = sysDictItemMapper.selectOne(
                Wrappers.<SysDictItem>lambdaQuery()
                    .eq(SysDictItem::getDictTypeCode, dto.getDictTypeCode())
                    .eq(SysDictItem::getItemValue, dto.getItemValue())
                    .last("LIMIT 1")
            );
            if (existing == null) {
                createItem(dto);
            } else {
                fillItem(existing, dto);
                existing.setUpdateBy(SecurityUtils.getUserId());
                sysDictItemMapper.updateById(existing);
            }
        }
    }

    private DictTypeVO toTypeVO(SysDictType entity) {
        DictTypeVO vo = new DictTypeVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private DictItemVO toItemVO(SysDictItem entity) {
        DictItemVO vo = new DictItemVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private void fillType(SysDictType entity, DictTypeSaveDTO saveDTO) {
        entity.setDictName(saveDTO.getDictName());
        entity.setDictTypeCode(saveDTO.getDictTypeCode());
        entity.setStatus(StringUtils.hasText(saveDTO.getStatus()) ? saveDTO.getStatus() : "ENABLED");
        entity.setRemark(saveDTO.getRemark());
    }

    private void fillItem(SysDictItem entity, DictItemSaveDTO saveDTO) {
        entity.setDictTypeCode(saveDTO.getDictTypeCode());
        entity.setItemLabel(saveDTO.getItemLabel());
        entity.setItemValue(saveDTO.getItemValue());
        entity.setItemSort(saveDTO.getItemSort() == null ? 0 : saveDTO.getItemSort());
        entity.setStatus(StringUtils.hasText(saveDTO.getStatus()) ? saveDTO.getStatus() : "ENABLED");
        entity.setCssClass(saveDTO.getCssClass());
        entity.setRemark(saveDTO.getRemark());
    }

    private SysDictType getTypeOrThrow(Long id) {
        SysDictType entity = sysDictTypeMapper.selectById(id);
        if (entity == null) {
            throw new BusinessException("Dictionary type does not exist");
        }
        return entity;
    }

    private SysDictItem getItemOrThrow(Long id) {
        SysDictItem entity = sysDictItemMapper.selectById(id);
        if (entity == null) {
            throw new BusinessException("Dictionary item does not exist");
        }
        return entity;
    }

    private void ensureTypeExists(String dictTypeCode) {
        long count = sysDictTypeMapper.selectCount(
            Wrappers.<SysDictType>lambdaQuery().eq(SysDictType::getDictTypeCode, dictTypeCode)
        );
        if (count == 0) {
            throw new BusinessException("Dictionary type does not exist");
        }
    }

    private void ensureTypeCodeUnique(String dictTypeCode, Long excludeId) {
        SysDictType duplicate = sysDictTypeMapper.selectOne(
            Wrappers.<SysDictType>lambdaQuery().eq(SysDictType::getDictTypeCode, dictTypeCode).last("LIMIT 1")
        );
        if (duplicate != null && !Objects.equals(duplicate.getId(), excludeId)) {
            throw new BusinessException("Dictionary type code already exists");
        }
    }

    private void ensureItemValueUnique(String dictTypeCode, String itemValue, Long excludeId) {
        SysDictItem duplicate = sysDictItemMapper.selectOne(
            Wrappers.<SysDictItem>lambdaQuery()
                .eq(SysDictItem::getDictTypeCode, dictTypeCode)
                .eq(SysDictItem::getItemValue, itemValue)
                .last("LIMIT 1")
        );
        if (duplicate != null && !Objects.equals(duplicate.getId(), excludeId)) {
            throw new BusinessException("Dictionary item value already exists");
        }
    }
}

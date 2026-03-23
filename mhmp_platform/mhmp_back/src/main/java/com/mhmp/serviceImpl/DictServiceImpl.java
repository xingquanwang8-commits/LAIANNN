package com.mhmp.serviceImpl;

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

import java.util.List;

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
}

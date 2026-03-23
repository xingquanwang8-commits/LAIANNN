package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.RelicPageQueryDTO;
import com.mhmp.dto.RelicSaveDTO;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicAttachment;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.entity.RelicInboundDetail;
import com.mhmp.entity.RelicOutboundDetail;
import com.mhmp.entity.RepairTask;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicAttachmentMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.service.RelicService;
import com.mhmp.vo.RelicAttachmentVO;
import com.mhmp.vo.RelicDetailVO;
import com.mhmp.vo.RelicListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class RelicServiceImpl implements RelicService {

    private final RelicMapper relicMapper;
    private final RelicAttachmentMapper relicAttachmentMapper;
    private final RelicInboundDetailMapper relicInboundDetailMapper;
    private final RelicOutboundDetailMapper relicOutboundDetailMapper;
    private final InventoryTaskDetailMapper inventoryTaskDetailMapper;
    private final RepairTaskMapper repairTaskMapper;

    public RelicServiceImpl(RelicMapper relicMapper,
                            RelicAttachmentMapper relicAttachmentMapper,
                            RelicInboundDetailMapper relicInboundDetailMapper,
                            RelicOutboundDetailMapper relicOutboundDetailMapper,
                            InventoryTaskDetailMapper inventoryTaskDetailMapper,
                            RepairTaskMapper repairTaskMapper) {
        this.relicMapper = relicMapper;
        this.relicAttachmentMapper = relicAttachmentMapper;
        this.relicInboundDetailMapper = relicInboundDetailMapper;
        this.relicOutboundDetailMapper = relicOutboundDetailMapper;
        this.inventoryTaskDetailMapper = inventoryTaskDetailMapper;
        this.repairTaskMapper = repairTaskMapper;
    }

    @Override
    public PageResponse<RelicListVO> page(RelicPageQueryDTO queryDTO) {
        Page<Relic> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<Relic> resultPage = relicMapper.selectPage(page,
            Wrappers.<Relic>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(Relic::getRelicNo, queryDTO.getKeyword())
                        .or()
                        .like(Relic::getName, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getCategoryCode()), Relic::getCategoryCode, queryDTO.getCategoryCode())
                .eq(StringUtils.hasText(queryDTO.getMaterialCode()), Relic::getMaterialCode, queryDTO.getMaterialCode())
                .eq(StringUtils.hasText(queryDTO.getPreservationStatusCode()), Relic::getPreservationStatusCode, queryDTO.getPreservationStatusCode())
                .eq(StringUtils.hasText(queryDTO.getCurrentStatus()), Relic::getCurrentStatus, queryDTO.getCurrentStatus())
                .eq(StringUtils.hasText(queryDTO.getStorageLocationCode()), Relic::getStorageLocationCode, queryDTO.getStorageLocationCode())
                .orderByDesc(Relic::getUpdateTime)
                .orderByDesc(Relic::getId)
        );
        List<RelicListVO> records = resultPage.getRecords().stream().map(this::toListVO).toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public RelicDetailVO detail(Long id) {
        Relic relic = getRelicOrThrow(id);
        RelicDetailVO vo = new RelicDetailVO();
        BeanUtils.copyProperties(relic, vo);
        vo.setAttachments(listAttachments(id));
        return vo;
    }

    @Override
    public Long create(RelicSaveDTO saveDTO) {
        long count = relicMapper.selectCount(
            Wrappers.<Relic>lambdaQuery().eq(Relic::getRelicNo, saveDTO.getRelicNo())
        );
        if (count > 0) {
            throw new BusinessException("文物编号已存在");
        }
        Relic relic = new Relic();
        fillRelic(relic, saveDTO);
        relic.setCreateBy(SecurityUtils.getUserId());
        relic.setUpdateBy(SecurityUtils.getUserId());
        relic.setDeleted(0);
        relicMapper.insert(relic);
        return relic.getId();
    }

    @Override
    public void update(Long id, RelicSaveDTO saveDTO) {
        Relic relic = getRelicOrThrow(id);
        long duplicateCount = relicMapper.selectCount(
            Wrappers.<Relic>lambdaQuery()
                .eq(Relic::getRelicNo, saveDTO.getRelicNo())
                .ne(Relic::getId, id)
        );
        if (duplicateCount > 0) {
            throw new BusinessException("文物编号已存在");
        }
        fillRelic(relic, saveDTO);
        relic.setUpdateBy(SecurityUtils.getUserId());
        relicMapper.updateById(relic);
    }

    @Override
    public void delete(Long id) {
        Relic relic = getRelicOrThrow(id);
        validateRelicCanDelete(id);
        relicMapper.deleteById(relic.getId());
    }

    @Override
    public List<RelicAttachmentVO> listAttachments(Long relicId) {
        return relicAttachmentMapper.selectList(
                Wrappers.<RelicAttachment>lambdaQuery()
                    .eq(RelicAttachment::getRelicId, relicId)
                    .orderByAsc(RelicAttachment::getId)
            ).stream()
            .map(this::toAttachmentVO)
            .toList();
    }

    private Relic getRelicOrThrow(Long id) {
        Relic relic = relicMapper.selectById(id);
        if (relic == null) {
            throw new BusinessException("文物不存在");
        }
        return relic;
    }

    private void fillRelic(Relic relic, RelicSaveDTO saveDTO) {
        relic.setRelicNo(saveDTO.getRelicNo());
        relic.setName(saveDTO.getName());
        relic.setCategoryCode(saveDTO.getCategoryCode());
        relic.setMaterialCode(saveDTO.getMaterialCode());
        relic.setEra(saveDTO.getEra());
        relic.setSource(saveDTO.getSource());
        relic.setStorageLocationCode(saveDTO.getStorageLocationCode());
        relic.setPreservationStatusCode(saveDTO.getPreservationStatusCode());
        relic.setCurrentStatus(saveDTO.getCurrentStatus());
        relic.setProtectionLevel(saveDTO.getProtectionLevel());
        relic.setStorageCondition(saveDTO.getStorageCondition());
        relic.setAttentionNote(saveDTO.getAttentionNote());
        relic.setDescription(saveDTO.getDescription());
        relic.setNote(saveDTO.getNote());
        relic.setImageUrl(saveDTO.getImageUrl());
        relic.setAppraisalReportUrl(saveDTO.getAppraisalReportUrl());
    }

    private void validateRelicCanDelete(Long relicId) {
        long inboundCount = relicInboundDetailMapper.selectCount(
            Wrappers.<RelicInboundDetail>lambdaQuery().eq(RelicInboundDetail::getRelicId, relicId)
        );
        long outboundCount = relicOutboundDetailMapper.selectCount(
            Wrappers.<RelicOutboundDetail>lambdaQuery().eq(RelicOutboundDetail::getRelicId, relicId)
        );
        long inventoryCount = inventoryTaskDetailMapper.selectCount(
            Wrappers.<InventoryTaskDetail>lambdaQuery().eq(InventoryTaskDetail::getRelicId, relicId)
        );
        long repairCount = repairTaskMapper.selectCount(
            Wrappers.<RepairTask>lambdaQuery().eq(RepairTask::getRelicId, relicId)
        );
        if (inboundCount + outboundCount + inventoryCount + repairCount > 0) {
            throw new BusinessException("This relic has related business records and cannot be deleted");
        }
    }

    private RelicListVO toListVO(Relic entity) {
        RelicListVO vo = new RelicListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private RelicAttachmentVO toAttachmentVO(RelicAttachment entity) {
        RelicAttachmentVO vo = new RelicAttachmentVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }
}

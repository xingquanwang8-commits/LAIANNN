package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.OrderNoUtils;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.InboundCreateDTO;
import com.mhmp.dto.InboundPageQueryDTO;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundDetail;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.service.InboundService;
import com.mhmp.vo.InboundDetailItemVO;
import com.mhmp.vo.InboundDetailVO;
import com.mhmp.vo.InboundListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class InboundServiceImpl implements InboundService {

    private final RelicInboundOrderMapper relicInboundOrderMapper;
    private final RelicInboundDetailMapper relicInboundDetailMapper;
    private final RelicMapper relicMapper;

    public InboundServiceImpl(RelicInboundOrderMapper relicInboundOrderMapper,
                              RelicInboundDetailMapper relicInboundDetailMapper,
                              RelicMapper relicMapper) {
        this.relicInboundOrderMapper = relicInboundOrderMapper;
        this.relicInboundDetailMapper = relicInboundDetailMapper;
        this.relicMapper = relicMapper;
    }

    @Override
    public PageResponse<InboundListVO> page(InboundPageQueryDTO queryDTO) {
        Page<RelicInboundOrder> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<RelicInboundOrder> resultPage = relicInboundOrderMapper.selectPage(page,
            Wrappers.<RelicInboundOrder>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(RelicInboundOrder::getOrderNo, queryDTO.getKeyword())
                        .or().like(RelicInboundOrder::getBatchNo, queryDTO.getKeyword())
                        .or().like(RelicInboundOrder::getSource, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getStatus()), RelicInboundOrder::getStatus, queryDTO.getStatus())
                .orderByDesc(RelicInboundOrder::getInboundTime)
                .orderByDesc(RelicInboundOrder::getId)
        );
        List<InboundListVO> records = resultPage.getRecords().stream().map(this::toListVO).toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public InboundDetailVO detail(Long id) {
        RelicInboundOrder order = getOrderOrThrow(id);
        InboundDetailVO vo = new InboundDetailVO();
        BeanUtils.copyProperties(order, vo);
        vo.setDetails(relicInboundDetailMapper.selectList(
                Wrappers.<RelicInboundDetail>lambdaQuery()
                    .eq(RelicInboundDetail::getOrderId, id)
                    .orderByAsc(RelicInboundDetail::getId)
            ).stream()
            .map(this::toDetailItemVO)
            .toList());
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(InboundCreateDTO createDTO) {
        List<Long> relicIds = createDTO.getRelicIds().stream().distinct().toList();
        List<Relic> relicList = relicMapper.selectBatchIds(relicIds);
        if (relicList.size() != relicIds.size()) {
            throw new BusinessException("Selected relics contain invalid data");
        }
        Long currentUserId = SecurityUtils.getUserId();
        RelicInboundOrder order = new RelicInboundOrder();
        order.setOrderNo(OrderNoUtils.nextOrderNo("IN"));
        order.setBatchNo(createDTO.getBatchNo());
        order.setSource(createDTO.getSource());
        order.setHandlerName(createDTO.getHandlerName());
        order.setInboundTime(createDTO.getInboundTime());
        order.setTotalCount(relicList.size());
        order.setStatus("COMPLETED");
        order.setRemark(createDTO.getRemark());
        order.setCreateBy(currentUserId);
        order.setUpdateBy(currentUserId);
        order.setDeleted(0);
        relicInboundOrderMapper.insert(order);

        for (Relic relic : relicList) {
            RelicInboundDetail detail = new RelicInboundDetail();
            detail.setOrderId(order.getId());
            detail.setRelicId(relic.getId());
            detail.setRelicNo(relic.getRelicNo());
            detail.setRelicName(relic.getName());
            detail.setQuantity(1);
            detail.setRemark("Inbound detail");
            detail.setCreateBy(currentUserId);
            detail.setUpdateBy(currentUserId);
            detail.setDeleted(0);
            relicInboundDetailMapper.insert(detail);

            relic.setCurrentStatus("IN_STOCK");
            relic.setUpdateBy(currentUserId);
            relicMapper.updateById(relic);
        }
        return order.getId();
    }

    private RelicInboundOrder getOrderOrThrow(Long id) {
        RelicInboundOrder order = relicInboundOrderMapper.selectById(id);
        if (order == null) {
            throw new BusinessException("Inbound order does not exist");
        }
        return order;
    }

    private InboundListVO toListVO(RelicInboundOrder entity) {
        InboundListVO vo = new InboundListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private InboundDetailItemVO toDetailItemVO(RelicInboundDetail entity) {
        InboundDetailItemVO vo = new InboundDetailItemVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }
}

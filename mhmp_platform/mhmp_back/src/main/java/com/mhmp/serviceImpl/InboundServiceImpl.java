package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.RelicBusinessRuleUtils;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.InboundCreateDTO;
import com.mhmp.dto.InboundPageQueryDTO;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicInboundDetail;
import com.mhmp.entity.RelicInboundOrder;
import com.mhmp.mapper.RelicInboundDetailMapper;
import com.mhmp.mapper.RelicInboundOrderMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.service.InboundService;
import com.mhmp.vo.InboundDetailItemVO;
import com.mhmp.vo.InboundDetailVO;
import com.mhmp.vo.InboundListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class InboundServiceImpl implements InboundService {

    private final RelicInboundOrderMapper relicInboundOrderMapper;
    private final RelicInboundDetailMapper relicInboundDetailMapper;
    private final RelicMapper relicMapper;
    private final BusinessNoService businessNoService;

    public InboundServiceImpl(RelicInboundOrderMapper relicInboundOrderMapper,
                              RelicInboundDetailMapper relicInboundDetailMapper,
                              RelicMapper relicMapper,
                              BusinessNoService businessNoService) {
        this.relicInboundOrderMapper = relicInboundOrderMapper;
        this.relicInboundDetailMapper = relicInboundDetailMapper;
        this.relicMapper = relicMapper;
        this.businessNoService = businessNoService;
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
                .and(StringUtils.hasText(queryDTO.getStatus()), wrapper -> {
                    if ("APPROVED".equals(queryDTO.getStatus())) {
                        wrapper.eq(RelicInboundOrder::getStatus, "APPROVED")
                            .or()
                            .eq(RelicInboundOrder::getStatus, "COMPLETED");
                        return;
                    }
                    wrapper.eq(RelicInboundOrder::getStatus, queryDTO.getStatus());
                })
                .orderByDesc(RelicInboundOrder::getInboundTime)
                .orderByDesc(RelicInboundOrder::getId)
        );
        List<InboundListVO> records = resultPage.getRecords().stream().map(this::toListVO).toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public InboundDetailVO detail(Long id) {
        RelicInboundOrder order = getOrderOrThrow(id);
        InboundOrderContext orderContext = loadOrderContext(id);
        InboundDetailVO vo = new InboundDetailVO();
        BeanUtils.copyProperties(order, vo);
        vo.setDetails(orderContext.details().stream()
            .map(detail -> toDetailItemVO(detail, orderContext.relicMap().get(detail.getRelicId())))
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
        for (Relic relic : relicList) {
            RelicBusinessRuleUtils.validateInboundCreatable(relic);
        }
        Long currentUserId = SecurityUtils.getUserId();
        RelicInboundOrder order = new RelicInboundOrder();
        order.setOrderNo(businessNoService.nextInboundOrderNo());
        order.setBatchNo(businessNoService.nextInboundBatchNo());
        order.setSource(createDTO.getSource());
        order.setHandlerName(resolveOperatorName(createDTO.getHandlerName()));
        order.setInboundTime(createDTO.getInboundTime());
        order.setTotalCount(relicList.size());
        order.setStatus("PENDING");
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
            detail.setRemark("待审批入库文物");
            detail.setCreateBy(currentUserId);
            detail.setUpdateBy(currentUserId);
            detail.setDeleted(0);
            relicInboundDetailMapper.insert(detail);

            relic.setStorageLocationCode(createDTO.getStorageLocationCode());
            relic.setCurrentStatus("INBOUND_PENDING");
            relic.setUpdateBy(currentUserId);
            relicMapper.updateById(relic);
        }
        return order.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approve(Long id) {
        RelicInboundOrder order = getOrderOrThrow(id);
        InboundOrderContext orderContext = loadOrderContext(id);
        RelicBusinessRuleUtils.validateInboundApprovable(order, toRelicList(orderContext));

        Long currentUserId = SecurityUtils.getUserId();
        order.setStatus("APPROVED");
        order.setUpdateBy(currentUserId);
        relicInboundOrderMapper.updateById(order);
        updateRelicStatus(orderContext, "IN_STOCK", currentUserId);
    }

    private RelicInboundOrder getOrderOrThrow(Long id) {
        RelicInboundOrder order = relicInboundOrderMapper.selectById(id);
        if (order == null) {
            throw new BusinessException("Inbound order does not exist");
        }
        return order;
    }

    private InboundOrderContext loadOrderContext(Long orderId) {
        List<RelicInboundDetail> details = listOrderDetails(orderId);
        return new InboundOrderContext(details, loadRelicMap(details));
    }

    private List<Relic> toRelicList(InboundOrderContext orderContext) {
        return orderContext.details().stream()
            .map(detail -> orderContext.relicMap().get(detail.getRelicId()))
            .filter(Objects::nonNull)
            .toList();
    }

    private void updateRelicStatus(InboundOrderContext orderContext, String targetStatus, Long currentUserId) {
        for (Long relicId : orderContext.details().stream()
            .map(RelicInboundDetail::getRelicId)
            .filter(Objects::nonNull)
            .distinct()
            .toList()) {
            Relic relic = orderContext.relicMap().get(relicId);
            if (relic == null) {
                continue;
            }
            relic.setCurrentStatus(targetStatus);
            relic.setUpdateBy(currentUserId);
            relicMapper.updateById(relic);
        }
    }

    private List<RelicInboundDetail> listOrderDetails(Long orderId) {
        return relicInboundDetailMapper.selectList(
            Wrappers.<RelicInboundDetail>lambdaQuery()
                .eq(RelicInboundDetail::getOrderId, orderId)
                .orderByAsc(RelicInboundDetail::getId)
        );
    }

    private Map<Long, Relic> loadRelicMap(List<RelicInboundDetail> details) {
        List<Long> relicIds = details.stream()
            .map(RelicInboundDetail::getRelicId)
            .filter(Objects::nonNull)
            .distinct()
            .toList();
        if (relicIds.isEmpty()) {
            return Map.of();
        }
        return relicMapper.selectBatchIds(relicIds).stream()
            .collect(Collectors.toMap(Relic::getId, Function.identity()));
    }

    private String resolveOperatorName(String operatorName) {
        if (StringUtils.hasText(operatorName)) {
            return operatorName.trim();
        }
        return StringUtils.hasText(SecurityUtils.getUsername()) ? SecurityUtils.getUsername() : "当前用户";
    }

    private InboundListVO toListVO(RelicInboundOrder entity) {
        InboundListVO vo = new InboundListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private InboundDetailItemVO toDetailItemVO(RelicInboundDetail entity, Relic relic) {
        InboundDetailItemVO vo = new InboundDetailItemVO();
        BeanUtils.copyProperties(entity, vo);
        if (relic != null) {
            vo.setStorageLocationCode(relic.getStorageLocationCode());
        }
        return vo;
    }

    private record InboundOrderContext(List<RelicInboundDetail> details, Map<Long, Relic> relicMap) {
    }
}

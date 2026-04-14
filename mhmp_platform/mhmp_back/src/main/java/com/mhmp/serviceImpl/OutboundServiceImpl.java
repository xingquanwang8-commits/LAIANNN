package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.RelicBusinessRuleUtils;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.OutboundApproveDTO;
import com.mhmp.dto.OutboundCreateDTO;
import com.mhmp.dto.OutboundPageQueryDTO;
import com.mhmp.dto.OutboundReturnDTO;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicOutboundDetail;
import com.mhmp.entity.RelicOutboundOrder;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.service.OutboundService;
import com.mhmp.vo.OutboundDetailItemVO;
import com.mhmp.vo.OutboundDetailVO;
import com.mhmp.vo.OutboundListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class OutboundServiceImpl implements OutboundService {

    private final RelicOutboundOrderMapper relicOutboundOrderMapper;
    private final RelicOutboundDetailMapper relicOutboundDetailMapper;
    private final RelicMapper relicMapper;
    private final BusinessNoService businessNoService;

    public OutboundServiceImpl(RelicOutboundOrderMapper relicOutboundOrderMapper,
                               RelicOutboundDetailMapper relicOutboundDetailMapper,
                               RelicMapper relicMapper,
                               BusinessNoService businessNoService) {
        this.relicOutboundOrderMapper = relicOutboundOrderMapper;
        this.relicOutboundDetailMapper = relicOutboundDetailMapper;
        this.relicMapper = relicMapper;
        this.businessNoService = businessNoService;
    }

    @Override
    public PageResponse<OutboundListVO> page(OutboundPageQueryDTO queryDTO) {
        Page<RelicOutboundOrder> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<RelicOutboundOrder> resultPage = relicOutboundOrderMapper.selectPage(page,
            Wrappers.<RelicOutboundOrder>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(RelicOutboundOrder::getOrderNo, queryDTO.getKeyword())
                        .or()
                        .like(RelicOutboundOrder::getPurpose, queryDTO.getKeyword())
                        .or()
                        .like(RelicOutboundOrder::getDestination, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getApproveStatus()), RelicOutboundOrder::getApproveStatus, queryDTO.getApproveStatus())
                .eq(queryDTO.getApplyUserId() != null, RelicOutboundOrder::getApplyUserId, queryDTO.getApplyUserId())
                .orderByDesc(RelicOutboundOrder::getCreateTime)
                .orderByDesc(RelicOutboundOrder::getId)
        );
        Map<Long, Integer> detailCountMap = loadDetailCountMap(resultPage.getRecords().stream()
            .map(RelicOutboundOrder::getId)
            .toList());
        List<OutboundListVO> records = resultPage.getRecords().stream()
            .map(order -> toListVO(order, detailCountMap))
            .toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public OutboundDetailVO detail(Long id) {
        RelicOutboundOrder order = getOrderOrThrow(id);
        OutboundDetailVO vo = new OutboundDetailVO();
        BeanUtils.copyProperties(order, vo);
        vo.setDetails(listDetailItems(id));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(OutboundCreateDTO createDTO) {
        Long currentUserId = SecurityUtils.getUserId();
        List<Long> relicIds = createDTO.getRelicIds().stream().distinct().toList();
        List<Relic> relicList = relicMapper.selectBatchIds(relicIds);
        if (relicList.size() != relicIds.size()) {
            throw new BusinessException("存在无效的文物数据");
        }
        for (Relic relic : relicList) {
            RelicBusinessRuleUtils.validateOutboundCreatable(relic);
        }

        RelicOutboundOrder order = new RelicOutboundOrder();
        order.setOrderNo(businessNoService.nextOutboundOrderNo());
        order.setPurpose(createDTO.getPurpose());
        order.setDestination(createDTO.getDestination());
        order.setHandlerName(resolveOperatorName(createDTO.getHandlerName()));
        order.setOutboundTime(createDTO.getOutboundTime());
        order.setApplyUserId(currentUserId);
        order.setApproveStatus("PENDING");
        order.setRemark(createDTO.getRemark());
        order.setCreateBy(currentUserId);
        order.setUpdateBy(currentUserId);
        order.setDeleted(0);
        relicOutboundOrderMapper.insert(order);

        for (Relic relic : relicList) {
            RelicOutboundDetail detail = new RelicOutboundDetail();
            detail.setOrderId(order.getId());
            detail.setRelicId(relic.getId());
            detail.setRelicNo(relic.getRelicNo());
            detail.setRelicName(relic.getName());
            detail.setQuantity(1);
            detail.setCurrentStatusSnapshot(relic.getCurrentStatus());
            detail.setCreateBy(currentUserId);
            detail.setUpdateBy(currentUserId);
            detail.setDeleted(0);
            relicOutboundDetailMapper.insert(detail);

            relic.setCurrentStatus("OUTBOUND_PENDING");
            relic.setUpdateBy(currentUserId);
            relicMapper.updateById(relic);
        }
        return order.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approve(Long id, OutboundApproveDTO approveDTO) {
        RelicOutboundOrder order = getOrderOrThrow(id);
        OutboundOrderContext orderContext = loadOrderContext(id);
        RelicBusinessRuleUtils.validateOutboundApprovable(order, toRelicList(orderContext));

        Long currentUserId = SecurityUtils.getUserId();
        order.setApproveStatus("APPROVED");
        order.setApproveBy(currentUserId);
        order.setApproveTime(LocalDateTime.now());
        order.setApproveRemark(approveDTO.getApproveRemark());
        order.setUpdateBy(currentUserId);
        relicOutboundOrderMapper.updateById(order);
        updateRelicStatus(orderContext, "OUT_STOCK", currentUserId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reject(Long id, OutboundApproveDTO approveDTO) {
        RelicOutboundOrder order = getOrderOrThrow(id);
        OutboundOrderContext orderContext = loadOrderContext(id);
        RelicBusinessRuleUtils.validateOutboundRejectable(order, toRelicList(orderContext));

        Long currentUserId = SecurityUtils.getUserId();
        order.setApproveStatus("REJECTED");
        order.setApproveBy(currentUserId);
        order.setApproveTime(LocalDateTime.now());
        order.setApproveRemark(approveDTO.getApproveRemark());
        order.setUpdateBy(currentUserId);
        relicOutboundOrderMapper.updateById(order);
        updateRelicStatus(orderContext, "IN_STOCK", currentUserId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void returnOrder(Long id, OutboundReturnDTO returnDTO) {
        RelicOutboundOrder order = getOrderOrThrow(id);
        OutboundOrderContext orderContext = loadOrderContext(id);
        RelicBusinessRuleUtils.validateOutboundReturnable(order, toRelicList(orderContext));

        Long currentUserId = SecurityUtils.getUserId();
        order.setApproveStatus("RETURNED");
        order.setReturnTime(returnDTO.getReturnTime() == null ? LocalDateTime.now() : returnDTO.getReturnTime());
        if (StringUtils.hasText(returnDTO.getRemark())) {
            order.setRemark(returnDTO.getRemark());
        }
        order.setUpdateBy(currentUserId);
        relicOutboundOrderMapper.updateById(order);
        updateRelicStatus(orderContext, "IN_STOCK", currentUserId);
    }

    private RelicOutboundOrder getOrderOrThrow(Long id) {
        RelicOutboundOrder order = relicOutboundOrderMapper.selectById(id);
        if (order == null) {
            throw new BusinessException("出库单不存在");
        }
        return order;
    }

    private List<OutboundDetailItemVO> listDetailItems(Long orderId) {
        return listOrderDetails(orderId).stream()
            .map(this::toDetailItemVO)
            .toList();
    }

    // 审批、驳回和归还都会用到同一批明细和文物，统一预加载避免重复查询。
    private OutboundOrderContext loadOrderContext(Long orderId) {
        List<RelicOutboundDetail> details = listOrderDetails(orderId);
        return new OutboundOrderContext(details, loadRelicMap(details));
    }

    private List<Relic> toRelicList(OutboundOrderContext orderContext) {
        return orderContext.details().stream()
            .map(detail -> orderContext.relicMap().get(detail.getRelicId()))
            .toList();
    }

    private void updateRelicStatus(OutboundOrderContext orderContext, String targetStatus, Long currentUserId) {
        for (Long relicId : orderContext.details().stream()
            .map(RelicOutboundDetail::getRelicId)
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

    private List<RelicOutboundDetail> listOrderDetails(Long orderId) {
        return relicOutboundDetailMapper.selectList(
            Wrappers.<RelicOutboundDetail>lambdaQuery()
                .eq(RelicOutboundDetail::getOrderId, orderId)
                .orderByAsc(RelicOutboundDetail::getId)
        );
    }

    private Map<Long, Integer> loadDetailCountMap(List<Long> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return Collections.emptyMap();
        }
        return relicOutboundDetailMapper.selectList(
                Wrappers.<RelicOutboundDetail>lambdaQuery()
                    .in(RelicOutboundDetail::getOrderId, orderIds)
            ).stream()
            .collect(Collectors.groupingBy(
                RelicOutboundDetail::getOrderId,
                Collectors.collectingAndThen(Collectors.counting(), Long::intValue)
            ));
    }

    private Map<Long, Relic> loadRelicMap(List<RelicOutboundDetail> details) {
        List<Long> relicIds = details.stream()
            .map(RelicOutboundDetail::getRelicId)
            .filter(Objects::nonNull)
            .distinct()
            .toList();
        if (relicIds.isEmpty()) {
            return Map.of();
        }
        return relicMapper.selectBatchIds(relicIds).stream()
            .collect(Collectors.toMap(Relic::getId, Function.identity()));
    }

    private OutboundListVO toListVO(RelicOutboundOrder entity, Map<Long, Integer> detailCountMap) {
        OutboundListVO vo = new OutboundListVO();
        BeanUtils.copyProperties(entity, vo);
        vo.setDetailCount(detailCountMap.getOrDefault(entity.getId(), 0));
        return vo;
    }

    private OutboundDetailItemVO toDetailItemVO(RelicOutboundDetail entity) {
        OutboundDetailItemVO vo = new OutboundDetailItemVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private String resolveOperatorName(String operatorName) {
        if (StringUtils.hasText(operatorName)) {
            return operatorName.trim();
        }
        return StringUtils.hasText(SecurityUtils.getUsername()) ? SecurityUtils.getUsername() : "当前用户";
    }

    private record OutboundOrderContext(List<RelicOutboundDetail> details, Map<Long, Relic> relicMap) {
    }
}

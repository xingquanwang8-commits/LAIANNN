package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.OrderNoUtils;
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
import com.mhmp.service.OutboundService;
import com.mhmp.vo.OutboundDetailItemVO;
import com.mhmp.vo.OutboundDetailVO;
import com.mhmp.vo.OutboundListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OutboundServiceImpl implements OutboundService {

    private final RelicOutboundOrderMapper relicOutboundOrderMapper;
    private final RelicOutboundDetailMapper relicOutboundDetailMapper;
    private final RelicMapper relicMapper;

    public OutboundServiceImpl(RelicOutboundOrderMapper relicOutboundOrderMapper,
                               RelicOutboundDetailMapper relicOutboundDetailMapper,
                               RelicMapper relicMapper) {
        this.relicOutboundOrderMapper = relicOutboundOrderMapper;
        this.relicOutboundDetailMapper = relicOutboundDetailMapper;
        this.relicMapper = relicMapper;
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
        List<OutboundListVO> records = resultPage.getRecords().stream().map(this::toListVO).toList();
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
        List<Relic> invalidRelics = relicList.stream()
            .filter(relic -> !"IN_STOCK".equals(relic.getCurrentStatus()))
            .toList();
        if (!invalidRelics.isEmpty()) {
            String names = invalidRelics.stream().map(Relic::getName).collect(Collectors.joining("、"));
            throw new BusinessException("以下文物当前不允许提交出库申请：" + names);
        }

        RelicOutboundOrder order = new RelicOutboundOrder();
        order.setOrderNo(OrderNoUtils.nextOrderNo("OUT"));
        order.setPurpose(createDTO.getPurpose());
        order.setDestination(createDTO.getDestination());
        order.setHandlerName(createDTO.getHandlerName());
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
        RelicOutboundOrder order = getPendingOrder(id);
        Long currentUserId = SecurityUtils.getUserId();
        order.setApproveStatus("APPROVED");
        order.setApproveBy(currentUserId);
        order.setApproveTime(LocalDateTime.now());
        order.setApproveRemark(approveDTO.getApproveRemark());
        order.setUpdateBy(currentUserId);
        relicOutboundOrderMapper.updateById(order);
        updateRelicStatus(id, "OUT_STOCK", currentUserId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reject(Long id, OutboundApproveDTO approveDTO) {
        RelicOutboundOrder order = getPendingOrder(id);
        Long currentUserId = SecurityUtils.getUserId();
        order.setApproveStatus("REJECTED");
        order.setApproveBy(currentUserId);
        order.setApproveTime(LocalDateTime.now());
        order.setApproveRemark(approveDTO.getApproveRemark());
        order.setUpdateBy(currentUserId);
        relicOutboundOrderMapper.updateById(order);
        updateRelicStatus(id, "IN_STOCK", currentUserId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void returnOrder(Long id, OutboundReturnDTO returnDTO) {
        RelicOutboundOrder order = getOrderOrThrow(id);
        if (!"APPROVED".equals(order.getApproveStatus()) && !"RETURNED".equals(order.getApproveStatus())) {
            throw new BusinessException("Only approved outbound orders can be returned");
        }
        Long currentUserId = SecurityUtils.getUserId();
        order.setApproveStatus("RETURNED");
        order.setReturnTime(returnDTO.getReturnTime() == null ? LocalDateTime.now() : returnDTO.getReturnTime());
        if (StringUtils.hasText(returnDTO.getRemark())) {
            order.setRemark(returnDTO.getRemark());
        }
        order.setUpdateBy(currentUserId);
        relicOutboundOrderMapper.updateById(order);
        updateRelicStatus(id, "IN_STOCK", currentUserId);
    }

    private RelicOutboundOrder getOrderOrThrow(Long id) {
        RelicOutboundOrder order = relicOutboundOrderMapper.selectById(id);
        if (order == null) {
            throw new BusinessException("出库单不存在");
        }
        return order;
    }

    private RelicOutboundOrder getPendingOrder(Long id) {
        RelicOutboundOrder order = getOrderOrThrow(id);
        if (!"PENDING".equals(order.getApproveStatus())) {
            throw new BusinessException("当前出库单不是待审批状态");
        }
        return order;
    }

    private List<OutboundDetailItemVO> listDetailItems(Long orderId) {
        return relicOutboundDetailMapper.selectList(
                Wrappers.<RelicOutboundDetail>lambdaQuery()
                    .eq(RelicOutboundDetail::getOrderId, orderId)
                    .orderByAsc(RelicOutboundDetail::getId)
            ).stream()
            .map(this::toDetailItemVO)
            .toList();
    }

    private void updateRelicStatus(Long orderId, String targetStatus, Long currentUserId) {
        List<RelicOutboundDetail> details = relicOutboundDetailMapper.selectList(
            Wrappers.<RelicOutboundDetail>lambdaQuery().eq(RelicOutboundDetail::getOrderId, orderId)
        );
        for (RelicOutboundDetail detail : details) {
            Relic relic = relicMapper.selectById(detail.getRelicId());
            if (relic != null) {
                relic.setCurrentStatus(targetStatus);
                relic.setUpdateBy(currentUserId);
                relicMapper.updateById(relic);
            }
        }
    }

    private OutboundListVO toListVO(RelicOutboundOrder entity) {
        OutboundListVO vo = new OutboundListVO();
        BeanUtils.copyProperties(entity, vo);
        vo.setDetailCount(Math.toIntExact(relicOutboundDetailMapper.selectCount(
            Wrappers.<RelicOutboundDetail>lambdaQuery().eq(RelicOutboundDetail::getOrderId, entity.getId())
        )));
        return vo;
    }

    private OutboundDetailItemVO toDetailItemVO(RelicOutboundDetail entity) {
        OutboundDetailItemVO vo = new OutboundDetailItemVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }
}

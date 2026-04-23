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
import com.mhmp.entity.SysRole;
import com.mhmp.entity.SysUser;
import com.mhmp.entity.SysUserRole;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicOutboundDetailMapper;
import com.mhmp.mapper.RelicOutboundOrderMapper;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.mapper.SysUserRoleMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.service.OutboundService;
import com.mhmp.vo.OutboundDetailItemVO;
import com.mhmp.vo.OutboundDetailVO;
import com.mhmp.vo.OutboundHandlerVO;
import com.mhmp.vo.OutboundListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
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
    private final SysUserMapper sysUserMapper;
    private final SysRoleMapper sysRoleMapper;
    private final SysUserRoleMapper sysUserRoleMapper;

    public OutboundServiceImpl(RelicOutboundOrderMapper relicOutboundOrderMapper,
                               RelicOutboundDetailMapper relicOutboundDetailMapper,
                               RelicMapper relicMapper,
                               BusinessNoService businessNoService,
                               SysUserMapper sysUserMapper,
                               SysRoleMapper sysRoleMapper,
                               SysUserRoleMapper sysUserRoleMapper) {
        this.relicOutboundOrderMapper = relicOutboundOrderMapper;
        this.relicOutboundDetailMapper = relicOutboundDetailMapper;
        this.relicMapper = relicMapper;
        this.businessNoService = businessNoService;
        this.sysUserMapper = sysUserMapper;
        this.sysRoleMapper = sysRoleMapper;
        this.sysUserRoleMapper = sysUserRoleMapper;
    }

    @Override
    public PageResponse<OutboundListVO> page(OutboundPageQueryDTO queryDTO) {
        Long currentUserId = SecurityUtils.getUserId();
        Page<RelicOutboundOrder> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<RelicOutboundOrder> resultPage = relicOutboundOrderMapper.selectPage(page,
            Wrappers.<RelicOutboundOrder>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(RelicOutboundOrder::getOrderNo, queryDTO.getKeyword())
                        .or()
                        .like(RelicOutboundOrder::getPurpose, queryDTO.getKeyword())
                        .or()
                        .like(RelicOutboundOrder::getDestination, queryDTO.getKeyword())
                        .or()
                        .like(RelicOutboundOrder::getHandlerName, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getApproveStatus()), RelicOutboundOrder::getApproveStatus, queryDTO.getApproveStatus())
                .eq(queryDTO.getApplyUserId() != null, RelicOutboundOrder::getApplyUserId, queryDTO.getApplyUserId())
                .eq(Boolean.TRUE.equals(queryDTO.getOnlyCurrentHandler()) && currentUserId != null,
                    RelicOutboundOrder::getHandlerUserId, currentUserId)
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
    public List<OutboundHandlerVO> handlerOptions() {
        SysRole researcherRole = sysRoleMapper.findByRoleCode("researcher");
        if (researcherRole == null) {
            return List.of();
        }

        List<Long> userIds = sysUserRoleMapper.selectList(
                Wrappers.<SysUserRole>lambdaQuery()
                    .eq(SysUserRole::getRoleId, researcherRole.getId())
                    .orderByAsc(SysUserRole::getId)
            ).stream()
            .map(SysUserRole::getUserId)
            .distinct()
            .toList();
        if (CollectionUtils.isEmpty(userIds)) {
            return List.of();
        }

        return sysUserMapper.selectBatchIds(userIds).stream()
            .filter(Objects::nonNull)
            .filter(user -> "ENABLED".equals(user.getStatus()))
            .sorted(Comparator.comparing(this::resolveDisplayName))
            .map(this::toHandlerVO)
            .toList();
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

        SysUser handlerUser = resolveHandlerUser(createDTO.getHandlerUserId());

        RelicOutboundOrder order = new RelicOutboundOrder();
        order.setOrderNo(businessNoService.nextOutboundOrderNo());
        order.setPurpose(createDTO.getPurpose());
        order.setDestination(createDTO.getDestination());
        order.setHandlerUserId(handlerUser.getId());
        order.setHandlerName(resolveDisplayName(handlerUser));
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
        Long currentUserId = SecurityUtils.getUserId();
        if (!Objects.equals(order.getHandlerUserId(), currentUserId)) {
            throw new BusinessException("只能由当前经手人登记归还");
        }

        OutboundOrderContext orderContext = loadOrderContext(id);
        RelicBusinessRuleUtils.validateOutboundReturnable(order, toRelicList(orderContext));

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

    private SysUser resolveHandlerUser(Long handlerUserId) {
        if (handlerUserId == null) {
            throw new BusinessException("经手人不能为空");
        }
        SysUser user = sysUserMapper.selectById(handlerUserId);
        if (user == null || !"ENABLED".equals(user.getStatus())) {
            throw new BusinessException("所选经手人不存在或已被停用");
        }
        List<String> roleCodes = sysUserMapper.selectRoleCodesByUserId(handlerUserId);
        if (!roleCodes.contains("researcher")) {
            throw new BusinessException("出库经手人必须选择研究员");
        }
        return user;
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
            .filter(Objects::nonNull)
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

    private OutboundHandlerVO toHandlerVO(SysUser user) {
        OutboundHandlerVO vo = new OutboundHandlerVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickName(user.getNickName());
        vo.setRealName(user.getRealName());
        vo.setDisplayName(resolveDisplayName(user));
        return vo;
    }

    private String resolveDisplayName(SysUser user) {
        if (user == null) {
            return "当前用户";
        }
        if (StringUtils.hasText(user.getRealName())) {
            return user.getRealName().trim();
        }
        if (StringUtils.hasText(user.getNickName())) {
            return user.getNickName().trim();
        }
        if (StringUtils.hasText(user.getUsername())) {
            return user.getUsername().trim();
        }
        return "当前用户";
    }

    private record OutboundOrderContext(List<RelicOutboundDetail> details, Map<Long, Relic> relicMap) {
    }
}

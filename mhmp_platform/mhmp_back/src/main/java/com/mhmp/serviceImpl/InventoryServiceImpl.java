package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.RelicBusinessRuleUtils;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.InventoryQueryPageDTO;
import com.mhmp.dto.InventoryTaskCreateDTO;
import com.mhmp.dto.InventoryTaskDetailUpdateDTO;
import com.mhmp.dto.InventoryTaskPageQueryDTO;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.entity.Relic;
import com.mhmp.entity.SysRole;
import com.mhmp.entity.SysUser;
import com.mhmp.entity.SysUserRole;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.mapper.SysUserRoleMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.service.InventoryService;
import com.mhmp.vo.InventorySummaryVO;
import com.mhmp.vo.InventoryTaskDetailVO;
import com.mhmp.vo.InventoryTaskItemVO;
import com.mhmp.vo.InventoryTaskListVO;
import com.mhmp.vo.InventoryTaskPrincipalVO;
import com.mhmp.vo.RelicListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class InventoryServiceImpl implements InventoryService {

    private final RelicMapper relicMapper;
    private final InventoryTaskMapper inventoryTaskMapper;
    private final InventoryTaskDetailMapper inventoryTaskDetailMapper;
    private final BusinessNoService businessNoService;
    private final SysUserMapper sysUserMapper;
    private final SysRoleMapper sysRoleMapper;
    private final SysUserRoleMapper sysUserRoleMapper;

    public InventoryServiceImpl(RelicMapper relicMapper,
                                InventoryTaskMapper inventoryTaskMapper,
                                InventoryTaskDetailMapper inventoryTaskDetailMapper,
                                BusinessNoService businessNoService,
                                SysUserMapper sysUserMapper,
                                SysRoleMapper sysRoleMapper,
                                SysUserRoleMapper sysUserRoleMapper) {
        this.relicMapper = relicMapper;
        this.inventoryTaskMapper = inventoryTaskMapper;
        this.inventoryTaskDetailMapper = inventoryTaskDetailMapper;
        this.businessNoService = businessNoService;
        this.sysUserMapper = sysUserMapper;
        this.sysRoleMapper = sysRoleMapper;
        this.sysUserRoleMapper = sysUserRoleMapper;
    }

    @Override
    public InventorySummaryVO summary() {
        InventorySummaryVO vo = new InventorySummaryVO();
        vo.setTotalCount(relicMapper.selectCount(null));
        vo.setInStockCount(relicMapper.selectCount(Wrappers.<Relic>lambdaQuery().eq(Relic::getCurrentStatus, "IN_STOCK")));
        vo.setOutboundPendingCount(relicMapper.selectCount(Wrappers.<Relic>lambdaQuery().eq(Relic::getCurrentStatus, "OUTBOUND_PENDING")));
        vo.setOutStockCount(relicMapper.selectCount(Wrappers.<Relic>lambdaQuery().eq(Relic::getCurrentStatus, "OUT_STOCK")));
        vo.setInRepairCount(relicMapper.selectCount(Wrappers.<Relic>lambdaQuery().eq(Relic::getCurrentStatus, "IN_REPAIR")));
        return vo;
    }

    @Override
    public PageResponse<RelicListVO> queryPage(InventoryQueryPageDTO queryDTO) {
        Page<Relic> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<Relic> resultPage = relicMapper.selectPage(page,
            Wrappers.<Relic>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(Relic::getRelicNo, queryDTO.getKeyword())
                        .or().like(Relic::getName, queryDTO.getKeyword())
                        .or().like(Relic::getEra, queryDTO.getKeyword())
                        .or().like(Relic::getSource, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getCategoryCode()), Relic::getCategoryCode, queryDTO.getCategoryCode())
                .eq(StringUtils.hasText(queryDTO.getMaterialCode()), Relic::getMaterialCode, queryDTO.getMaterialCode())
                .eq(StringUtils.hasText(queryDTO.getStorageLocationCode()), Relic::getStorageLocationCode, queryDTO.getStorageLocationCode())
                .eq(StringUtils.hasText(queryDTO.getPreservationStatusCode()), Relic::getPreservationStatusCode, queryDTO.getPreservationStatusCode())
                .eq(StringUtils.hasText(queryDTO.getCurrentStatus()), Relic::getCurrentStatus, queryDTO.getCurrentStatus())
                .orderByDesc(Relic::getUpdateTime)
                .orderByDesc(Relic::getId)
        );
        return PageResponse.of(resultPage, resultPage.getRecords().stream().map(this::toRelicListVO).toList());
    }

    @Override
    public PageResponse<InventoryTaskListVO> taskPage(InventoryTaskPageQueryDTO queryDTO) {
        Page<InventoryTask> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<InventoryTask> resultPage = inventoryTaskMapper.selectPage(page,
            Wrappers.<InventoryTask>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(InventoryTask::getTaskNo, queryDTO.getKeyword())
                        .or().like(InventoryTask::getTaskName, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getLocationCode()), InventoryTask::getLocationCode, queryDTO.getLocationCode())
                .eq(StringUtils.hasText(queryDTO.getTaskStatus()), InventoryTask::getTaskStatus, queryDTO.getTaskStatus())
                .eq(queryDTO.getPrincipalUserId() != null, InventoryTask::getPrincipalUserId, queryDTO.getPrincipalUserId())
                .orderByDesc(InventoryTask::getStartTime)
                .orderByDesc(InventoryTask::getId)
        );
        Map<Long, List<InventoryTaskDetail>> detailMap = loadTaskDetailMap(resultPage.getRecords().stream()
            .map(InventoryTask::getId)
            .toList());
        List<InventoryTaskListVO> records = resultPage.getRecords().stream()
            .map(task -> toTaskListVO(task, detailMap.getOrDefault(task.getId(), List.of())))
            .toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public InventoryTaskDetailVO taskDetail(Long id) {
        InventoryTask task = getTaskOrThrow(id);
        InventoryTaskDetailVO vo = new InventoryTaskDetailVO();
        BeanUtils.copyProperties(task, vo);
        vo.setDetails(listTaskDetails(id).stream()
            .map(this::toTaskItemVO)
            .toList());
        return vo;
    }

    @Override
    public List<InventoryTaskPrincipalVO> taskPrincipals() {
        Long currentUserId = SecurityUtils.getUserId();
        if (currentUserId == null) {
            return List.of();
        }
        List<String> currentRoleCodes = loadRoleCodes(currentUserId);
        if (canDispatchToOtherResearchers(currentRoleCodes)) {
            return listResearcherPrincipals();
        }
        if (!currentRoleCodes.contains("researcher")) {
            return List.of();
        }
        SysUser currentUser = sysUserMapper.selectById(currentUserId);
        if (currentUser == null || !"ENABLED".equals(currentUser.getStatus())) {
            return List.of();
        }
        return List.of(toPrincipalVO(currentUser));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createTask(InventoryTaskCreateDTO createDTO) {
        SysUser principal = resolvePrincipalUser(createDTO.getPrincipalUserId());
        List<Relic> relics = relicMapper.selectList(
            Wrappers.<Relic>lambdaQuery()
                .eq(Relic::getStorageLocationCode, createDTO.getLocationCode())
                .eq(Relic::getCurrentStatus, "IN_STOCK")
                .orderByAsc(Relic::getId)
        );
        boolean hasActiveTask = inventoryTaskMapper.selectCount(
            Wrappers.<InventoryTask>lambdaQuery()
                .eq(InventoryTask::getLocationCode, createDTO.getLocationCode())
                .in(InventoryTask::getTaskStatus, RelicBusinessRuleUtils.ACTIVE_INVENTORY_TASK_STATUSES)
        ) > 0;
        RelicBusinessRuleUtils.validateInventoryTaskCreatable(createDTO.getLocationCode(), relics, hasActiveTask);

        Long currentUserId = SecurityUtils.getUserId();
        InventoryTask task = new InventoryTask();
        task.setTaskNo(businessNoService.nextInventoryTaskNo());
        task.setTaskName(createDTO.getTaskName());
        task.setLocationCode(createDTO.getLocationCode());
        task.setTaskStatus("CREATED");
        task.setStartTime(createDTO.getStartTime());
        task.setPrincipalUserId(principal.getId());
        task.setPrincipalName(resolvePrincipalDisplayName(principal));
        task.setRemark(createDTO.getRemark());
        task.setCreateBy(currentUserId);
        task.setUpdateBy(currentUserId);
        task.setDeleted(0);
        inventoryTaskMapper.insert(task);

        for (Relic relic : relics) {
            InventoryTaskDetail detail = new InventoryTaskDetail();
            detail.setTaskId(task.getId());
            detail.setRelicId(relic.getId());
            detail.setRelicNo(relic.getRelicNo());
            detail.setRelicName(relic.getName());
            detail.setSystemQuantity(1);
            detail.setResultStatus("PENDING");
            detail.setCreateBy(currentUserId);
            detail.setUpdateBy(currentUserId);
            detail.setDeleted(0);
            inventoryTaskDetailMapper.insert(detail);
        }
        return task.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateTaskDetail(Long taskId, Long detailId, InventoryTaskDetailUpdateDTO updateDTO) {
        InventoryTask task = getTaskOrThrow(taskId);
        InventoryTaskDetail detail = inventoryTaskDetailMapper.selectById(detailId);
        RelicBusinessRuleUtils.validateInventoryTaskDetailUpdatable(task, detail, taskId, updateDTO.getActualQuantity());
        detail.setActualQuantity(updateDTO.getActualQuantity());
        detail.setDiffRemark(updateDTO.getDiffRemark());
        if (updateDTO.getActualQuantity() == null) {
            detail.setDiffQuantity(null);
            detail.setResultStatus("PENDING");
        } else {
            int diff = updateDTO.getActualQuantity() - detail.getSystemQuantity();
            detail.setDiffQuantity(diff);
            detail.setResultStatus(diff == 0 ? "CHECKED" : "DIFF_FOUND");
        }
        detail.setUpdateBy(SecurityUtils.getUserId());
        inventoryTaskDetailMapper.updateById(detail);

        if ("CREATED".equals(task.getTaskStatus())) {
            task.setTaskStatus("IN_PROGRESS");
            task.setUpdateBy(SecurityUtils.getUserId());
            inventoryTaskMapper.updateById(task);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitTask(Long taskId) {
        InventoryTask task = getTaskOrThrow(taskId);
        List<InventoryTaskDetail> details = listTaskDetails(taskId);
        RelicBusinessRuleUtils.validateInventoryTaskSubmittable(task, details);
        Long currentUserId = SecurityUtils.getUserId();
        for (InventoryTaskDetail detail : details) {
            if ("CHECKED".equals(detail.getResultStatus())) {
                detail.setResultStatus("NORMAL");
                detail.setUpdateBy(currentUserId);
                inventoryTaskDetailMapper.updateById(detail);
            }
        }
        task.setTaskStatus("COMPLETED");
        task.setEndTime(LocalDateTime.now());
        task.setUpdateBy(currentUserId);
        inventoryTaskMapper.updateById(task);
    }

    private InventoryTask getTaskOrThrow(Long id) {
        InventoryTask task = inventoryTaskMapper.selectById(id);
        if (task == null) {
            throw new BusinessException("盘点任务不存在");
        }
        return task;
    }

    private Map<Long, List<InventoryTaskDetail>> loadTaskDetailMap(List<Long> taskIds) {
        if (taskIds == null || taskIds.isEmpty()) {
            return Collections.emptyMap();
        }
        return inventoryTaskDetailMapper.selectList(
                Wrappers.<InventoryTaskDetail>lambdaQuery()
                    .in(InventoryTaskDetail::getTaskId, taskIds)
                    .orderByAsc(InventoryTaskDetail::getId)
            ).stream()
            .collect(Collectors.groupingBy(InventoryTaskDetail::getTaskId));
    }

    private List<InventoryTaskDetail> listTaskDetails(Long taskId) {
        return inventoryTaskDetailMapper.selectList(
            Wrappers.<InventoryTaskDetail>lambdaQuery()
                .eq(InventoryTaskDetail::getTaskId, taskId)
                .orderByAsc(InventoryTaskDetail::getId)
        );
    }

    private RelicListVO toRelicListVO(Relic entity) {
        RelicListVO vo = new RelicListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private InventoryTaskListVO toTaskListVO(InventoryTask entity, List<InventoryTaskDetail> details) {
        InventoryTaskListVO vo = new InventoryTaskListVO();
        BeanUtils.copyProperties(entity, vo);
        vo.setTotalCount(details.size());
        vo.setCheckedCount((int) details.stream().filter(detail -> !"PENDING".equals(detail.getResultStatus())).count());
        vo.setDiffCount((int) details.stream().filter(detail -> "DIFF_FOUND".equals(detail.getResultStatus())).count());
        return vo;
    }

    private InventoryTaskItemVO toTaskItemVO(InventoryTaskDetail entity) {
        InventoryTaskItemVO vo = new InventoryTaskItemVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private SysUser resolvePrincipalUser(Long principalUserId) {
        if (principalUserId == null) {
            throw new BusinessException("负责人不能为空");
        }
        SysUser principal = sysUserMapper.selectById(principalUserId);
        if (principal == null || !"ENABLED".equals(principal.getStatus())) {
            throw new BusinessException("所选负责人不存在或已被停用");
        }
        List<String> principalRoleCodes = loadRoleCodes(principalUserId);
        if (!principalRoleCodes.contains("researcher")) {
            throw new BusinessException("盘点任务负责人必须选择研究员");
        }

        Long currentUserId = SecurityUtils.getUserId();
        List<String> currentRoleCodes = loadRoleCodes(currentUserId);
        if (!canDispatchToOtherResearchers(currentRoleCodes) && !Objects.equals(currentUserId, principalUserId)) {
            throw new BusinessException("研究员只能给自己发起盘点任务");
        }
        return principal;
    }

    private List<String> loadRoleCodes(Long userId) {
        if (userId == null) {
            return List.of();
        }
        return sysUserMapper.selectRoleCodesByUserId(userId);
    }

    private boolean canDispatchToOtherResearchers(List<String> roleCodes) {
        return roleCodes.contains("admin") || roleCodes.contains("senior_researcher");
    }

    private List<InventoryTaskPrincipalVO> listResearcherPrincipals() {
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
            .sorted(Comparator.comparing(this::resolvePrincipalDisplayName))
            .map(this::toPrincipalVO)
            .toList();
    }

    private InventoryTaskPrincipalVO toPrincipalVO(SysUser user) {
        InventoryTaskPrincipalVO vo = new InventoryTaskPrincipalVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickName(user.getNickName());
        vo.setRealName(user.getRealName());
        vo.setDisplayName(resolvePrincipalDisplayName(user));
        return vo;
    }

    private String resolvePrincipalDisplayName(SysUser user) {
        if (user == null) {
            return "";
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
}

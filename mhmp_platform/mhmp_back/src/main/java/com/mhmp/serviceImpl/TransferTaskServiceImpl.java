package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.RelicBusinessRuleUtils;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.TransferTaskBatchCreateDTO;
import com.mhmp.dto.TransferTaskConfirmDTO;
import com.mhmp.dto.TransferTaskCreateDTO;
import com.mhmp.dto.TransferTaskPageQueryDTO;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicTransferTask;
import com.mhmp.entity.SysRole;
import com.mhmp.entity.SysUser;
import com.mhmp.entity.SysUserRole;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.RelicTransferTaskMapper;
import com.mhmp.mapper.SysRoleMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.mapper.SysUserRoleMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.service.TransferTaskService;
import com.mhmp.vo.TransferTaskDetailVO;
import com.mhmp.vo.TransferTaskListVO;
import com.mhmp.vo.TransferTaskPrincipalVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

@Service
public class TransferTaskServiceImpl implements TransferTaskService {

    private static final String TRANSFER_PREFIX = "[TRANSFER]";

    private final RelicMapper relicMapper;
    private final RelicTransferTaskMapper relicTransferTaskMapper;
    private final BusinessNoService businessNoService;
    private final SysUserMapper sysUserMapper;
    private final SysRoleMapper sysRoleMapper;
    private final SysUserRoleMapper sysUserRoleMapper;

    public TransferTaskServiceImpl(RelicMapper relicMapper,
                                   RelicTransferTaskMapper relicTransferTaskMapper,
                                   BusinessNoService businessNoService,
                                   SysUserMapper sysUserMapper,
                                   SysRoleMapper sysRoleMapper,
                                   SysUserRoleMapper sysUserRoleMapper) {
        this.relicMapper = relicMapper;
        this.relicTransferTaskMapper = relicTransferTaskMapper;
        this.businessNoService = businessNoService;
        this.sysUserMapper = sysUserMapper;
        this.sysRoleMapper = sysRoleMapper;
        this.sysUserRoleMapper = sysUserRoleMapper;
    }

    @Override
    public List<TransferTaskPrincipalVO> taskPrincipals() {
        requireDispatcherRole();
        return listResearcherPrincipals();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createTask(TransferTaskCreateDTO createDTO) {
        requireDispatcherRole();
        SysUser principal = resolvePrincipalUser(createDTO.getPrincipalUserId());
        Relic relic = getRelicOrThrow(createDTO.getRelicId());
        validateRelicTransferTaskCreatable(relic, createDTO.getTargetLocationCode(), Set.of());
        return createTransferTask(relic, createDTO.getTargetLocationCode(), createDTO.getTransferReason(), principal);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public List<Long> createBatchTasks(TransferTaskBatchCreateDTO createDTO) {
        requireDispatcherRole();
        SysUser principal = resolvePrincipalUser(createDTO.getPrincipalUserId());
        List<Long> relicIds = normalizeRelicIds(createDTO.getRelicIds());
        if (relicIds.isEmpty()) {
            throw new BusinessException("Please select relics to transfer");
        }

        List<Relic> relics = relicMapper.selectBatchIds(relicIds);
        if (relics.size() != relicIds.size()) {
            throw new BusinessException("Some relics do not exist or have been deleted");
        }

        Set<Long> activeRelicIds = relicTransferTaskMapper.selectList(
                Wrappers.<RelicTransferTask>lambdaQuery()
                    .in(RelicTransferTask::getRelicId, relicIds)
                    .in(RelicTransferTask::getTaskStatus, RelicBusinessRuleUtils.ACTIVE_TRANSFER_TASK_STATUSES)
            ).stream()
            .map(RelicTransferTask::getRelicId)
            .collect(java.util.stream.Collectors.toSet());

        List<Long> taskIds = new ArrayList<>();
        for (Relic relic : relics) {
            validateRelicTransferTaskCreatable(relic, createDTO.getTargetLocationCode(), activeRelicIds);
            taskIds.add(createTransferTask(relic, createDTO.getTargetLocationCode(), createDTO.getTransferReason(), principal));
        }
        return taskIds;
    }

    @Override
    public PageResponse<TransferTaskListVO> myTaskPage(TransferTaskPageQueryDTO queryDTO) {
        Long currentUserId = SecurityUtils.getUserId();
        if (currentUserId == null) {
            return new PageResponse<>(0L, queryDTO.getPageNum(), queryDTO.getPageSize(), List.of());
        }

        Page<RelicTransferTask> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<RelicTransferTask> resultPage = relicTransferTaskMapper.selectPage(page,
            Wrappers.<RelicTransferTask>lambdaQuery()
                .eq(RelicTransferTask::getPrincipalUserId, currentUserId)
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(RelicTransferTask::getTaskNo, queryDTO.getKeyword())
                        .or().like(RelicTransferTask::getRelicNo, queryDTO.getKeyword())
                        .or().like(RelicTransferTask::getRelicName, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getTaskStatus()), RelicTransferTask::getTaskStatus, queryDTO.getTaskStatus())
                .orderByAsc(RelicTransferTask::getTaskStatus)
                .orderByDesc(RelicTransferTask::getAssignTime)
                .orderByDesc(RelicTransferTask::getId)
        );
        return PageResponse.of(resultPage, resultPage.getRecords().stream().map(this::toTaskListVO).toList());
    }

    @Override
    public TransferTaskDetailVO taskDetail(Long id) {
        RelicTransferTask task = getTaskOrThrow(id);
        ensureTaskAccessible(task);
        TransferTaskDetailVO vo = new TransferTaskDetailVO();
        BeanUtils.copyProperties(task, vo);
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmTask(Long id, TransferTaskConfirmDTO confirmDTO) {
        RelicTransferTask task = getTaskOrThrow(id);
        Long currentUserId = SecurityUtils.getUserId();
        if (!Objects.equals(task.getPrincipalUserId(), currentUserId)) {
            throw new BusinessException("Only the assigned researcher can confirm this transfer task");
        }
        if (!RelicBusinessRuleUtils.ACTIVE_TRANSFER_TASK_STATUSES.contains(task.getTaskStatus())) {
            throw new BusinessException("The transfer task has already been completed");
        }

        Relic relic = getRelicOrThrow(task.getRelicId());
        RelicBusinessRuleUtils.validateTransferCreatable(relic, task.getTargetLocationCode());
        if (!Objects.equals(task.getFromLocationCode(), relic.getStorageLocationCode())) {
            throw new BusinessException("The current relic location has changed. Please refresh and create a new transfer task");
        }

        LocalDateTime completeTime = LocalDateTime.now();
        applyTransfer(relic, task, completeTime, currentUserId);

        task.setTaskStatus("COMPLETED");
        task.setCompleteTime(completeTime);
        task.setConfirmRemark(confirmDTO.getConfirmRemark());
        task.setUpdateBy(currentUserId);
        relicTransferTaskMapper.updateById(task);
    }

    private void requireDispatcherRole() {
        Long currentUserId = SecurityUtils.getUserId();
        if (!canDispatchTransfer(loadRoleCodes(currentUserId))) {
            throw new BusinessException("Only administrators and senior researchers can create transfer tasks");
        }
    }

    private Long createTransferTask(Relic relic,
                                    String targetLocationCode,
                                    String transferReason,
                                    SysUser principal) {
        Long currentUserId = SecurityUtils.getUserId();
        RelicTransferTask task = new RelicTransferTask();
        task.setTaskNo(businessNoService.nextTransferTaskNo());
        task.setRelicId(relic.getId());
        task.setRelicNo(relic.getRelicNo());
        task.setRelicName(relic.getName());
        task.setFromLocationCode(relic.getStorageLocationCode());
        task.setTargetLocationCode(targetLocationCode);
        task.setTaskStatus("ASSIGNED");
        task.setAssignUserId(currentUserId);
        task.setAssignUserName(resolveCurrentUserName(currentUserId));
        task.setPrincipalUserId(principal.getId());
        task.setPrincipalName(resolveDisplayName(principal));
        task.setAssignTime(LocalDateTime.now());
        task.setTransferReason(transferReason);
        task.setCreateBy(currentUserId);
        task.setUpdateBy(currentUserId);
        task.setDeleted(0);
        relicTransferTaskMapper.insert(task);
        return task.getId();
    }

    private void validateRelicTransferTaskCreatable(Relic relic, String targetLocationCode, Set<Long> activeRelicIds) {
        RelicBusinessRuleUtils.validateTransferCreatable(relic, targetLocationCode);
        if (activeRelicIds.contains(relic.getId()) || hasActiveTask(relic.getId())) {
            String identity = StringUtils.hasText(relic.getRelicNo()) ? relic.getRelicNo() : "Current relic";
            throw new BusinessException(identity + " already has an unfinished transfer task");
        }
    }

    private boolean hasActiveTask(Long relicId) {
        return relicTransferTaskMapper.selectCount(
            Wrappers.<RelicTransferTask>lambdaQuery()
                .eq(RelicTransferTask::getRelicId, relicId)
                .in(RelicTransferTask::getTaskStatus, RelicBusinessRuleUtils.ACTIVE_TRANSFER_TASK_STATUSES)
        ) > 0;
    }

    private Relic getRelicOrThrow(Long relicId) {
        Relic relic = relicMapper.selectById(relicId);
        if (relic == null) {
            throw new BusinessException("Relic does not exist");
        }
        return relic;
    }

    private RelicTransferTask getTaskOrThrow(Long id) {
        RelicTransferTask task = relicTransferTaskMapper.selectById(id);
        if (task == null) {
            throw new BusinessException("Transfer task does not exist");
        }
        return task;
    }

    private void ensureTaskAccessible(RelicTransferTask task) {
        Long currentUserId = SecurityUtils.getUserId();
        List<String> roleCodes = loadRoleCodes(currentUserId);
        if (canDispatchTransfer(roleCodes)) {
            return;
        }
        if (!Objects.equals(task.getPrincipalUserId(), currentUserId)) {
            throw new BusinessException("You do not have permission to view this transfer task");
        }
    }

    private void applyTransfer(Relic relic,
                               RelicTransferTask task,
                               LocalDateTime transferTime,
                               Long currentUserId) {
        String previousLocationCode = relic.getStorageLocationCode();
        relic.setStorageLocationCode(task.getTargetLocationCode());
        relic.setNote(appendBusinessNote(
            relic.getNote(),
            String.format("%s[%s] from=%s;to=%s;reason=%s;task=%s",
                TRANSFER_PREFIX,
                transferTime,
                StringUtils.hasText(previousLocationCode) ? previousLocationCode : "UNKNOWN",
                task.getTargetLocationCode(),
                StringUtils.hasText(task.getTransferReason()) ? task.getTransferReason() : "No reason",
                task.getTaskNo())
        ));
        relic.setUpdateBy(currentUserId);
        relicMapper.updateById(relic);
    }

    private String appendBusinessNote(String originalNote, String noteLine) {
        if (!StringUtils.hasText(originalNote)) {
            return noteLine;
        }
        return originalNote + System.lineSeparator() + noteLine;
    }

    private SysUser resolvePrincipalUser(Long principalUserId) {
        if (principalUserId == null) {
            throw new BusinessException("Principal researcher is required");
        }
        SysUser principal = sysUserMapper.selectById(principalUserId);
        if (principal == null || !"ENABLED".equals(principal.getStatus())) {
            throw new BusinessException("Selected principal researcher does not exist or has been disabled");
        }
        if (!loadRoleCodes(principalUserId).contains("researcher")) {
            throw new BusinessException("Transfer task principal must be a researcher");
        }
        return principal;
    }

    private List<Long> normalizeRelicIds(List<Long> relicIds) {
        if (relicIds == null) {
            return List.of();
        }
        return new ArrayList<>(new LinkedHashSet<>(relicIds.stream()
            .filter(Objects::nonNull)
            .toList()));
    }

    private List<String> loadRoleCodes(Long userId) {
        if (userId == null) {
            return List.of();
        }
        return sysUserMapper.selectRoleCodesByUserId(userId);
    }

    private boolean canDispatchTransfer(List<String> roleCodes) {
        return roleCodes.contains("admin") || roleCodes.contains("senior_researcher");
    }

    private List<TransferTaskPrincipalVO> listResearcherPrincipals() {
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
            .map(this::toPrincipalVO)
            .toList();
    }

    private TransferTaskPrincipalVO toPrincipalVO(SysUser user) {
        TransferTaskPrincipalVO vo = new TransferTaskPrincipalVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickName(user.getNickName());
        vo.setRealName(user.getRealName());
        vo.setDisplayName(resolveDisplayName(user));
        return vo;
    }

    private TransferTaskListVO toTaskListVO(RelicTransferTask entity) {
        TransferTaskListVO vo = new TransferTaskListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private String resolveCurrentUserName(Long userId) {
        if (userId == null) {
            return "Current User";
        }
        return resolveDisplayName(sysUserMapper.selectById(userId));
    }

    private String resolveDisplayName(SysUser user) {
        if (user == null) {
            return "Current User";
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
        return "Current User";
    }
}

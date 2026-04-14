package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.RelicBusinessRuleUtils;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.AttachmentSaveDTO;
import com.mhmp.dto.RelicPageQueryDTO;
import com.mhmp.dto.RepairAcceptanceDTO;
import com.mhmp.dto.RepairApplyCreateDTO;
import com.mhmp.dto.RepairApproveDTO;
import com.mhmp.dto.RepairLogCreateDTO;
import com.mhmp.dto.RepairPageQueryDTO;
import com.mhmp.entity.RepairAcceptance;
import com.mhmp.entity.RepairLog;
import com.mhmp.entity.RepairPlan;
import com.mhmp.entity.RepairTask;
import com.mhmp.entity.Relic;
import com.mhmp.entity.RelicAttachment;
import com.mhmp.entity.SysUser;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairPlanMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicAttachmentMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.service.BusinessNoService;
import com.mhmp.service.RepairService;
import com.mhmp.vo.RelicAttachmentVO;
import com.mhmp.vo.RelicListVO;
import com.mhmp.vo.RepairAcceptanceVO;
import com.mhmp.vo.RepairDetailVO;
import com.mhmp.vo.RepairHistoryTaskVO;
import com.mhmp.vo.RepairLogVO;
import com.mhmp.vo.RepairPlanVO;
import com.mhmp.vo.RepairTaskListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class RepairServiceImpl implements RepairService {

    private static final List<String> ACTIVE_TASK_STATUSES = List.of("APPLIED", "APPROVED", "IN_PROGRESS", "COMPLETED");
    private static final List<String> APPROVE_TASK_STATUSES = List.of("APPLIED", "APPROVED", "REJECTED");
    private static final List<String> PROCESS_TASK_STATUSES = List.of("APPROVED", "IN_PROGRESS", "COMPLETED");
    private static final List<String> REPAIRED_TASK_STATUSES = List.of("ACCEPTED");
    private static final List<String> PENDING_REPAIR_STATUS_CODES = RelicBusinessRuleUtils.REPAIRABLE_PRESERVATION_CODES;
    private static final List<String> IMAGE_SUFFIXES = List.of("png", "jpg", "jpeg", "gif", "webp", "bmp");

    private final RepairTaskMapper repairTaskMapper;
    private final RepairPlanMapper repairPlanMapper;
    private final RepairLogMapper repairLogMapper;
    private final RepairAcceptanceMapper repairAcceptanceMapper;
    private final RelicMapper relicMapper;
    private final RelicAttachmentMapper relicAttachmentMapper;
    private final SysUserMapper sysUserMapper;
    private final BusinessNoService businessNoService;

    public RepairServiceImpl(RepairTaskMapper repairTaskMapper,
                             RepairPlanMapper repairPlanMapper,
                             RepairLogMapper repairLogMapper,
                             RepairAcceptanceMapper repairAcceptanceMapper,
                             RelicMapper relicMapper,
                             RelicAttachmentMapper relicAttachmentMapper,
                             SysUserMapper sysUserMapper,
                             BusinessNoService businessNoService) {
        this.repairTaskMapper = repairTaskMapper;
        this.repairPlanMapper = repairPlanMapper;
        this.repairLogMapper = repairLogMapper;
        this.repairAcceptanceMapper = repairAcceptanceMapper;
        this.relicMapper = relicMapper;
        this.relicAttachmentMapper = relicAttachmentMapper;
        this.sysUserMapper = sysUserMapper;
        this.businessNoService = businessNoService;
    }

    @Override
    public PageResponse<RepairTaskListVO> applyPage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, null, null, null);
    }

    @Override
    public PageResponse<RepairTaskListVO> approvePage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, APPROVE_TASK_STATUSES, null, null);
    }

    @Override
    public PageResponse<RepairTaskListVO> processPage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, PROCESS_TASK_STATUSES, null, null);
    }

    @Override
    public PageResponse<RepairTaskListVO> acceptancePage(RepairPageQueryDTO queryDTO) {
        return pageAcceptanceTasks(queryDTO);
    }

    @Override
    public PageResponse<RepairTaskListVO> historyPage(RepairPageQueryDTO queryDTO) {
        return repairedPage(queryDTO);
    }

    @Override
    public PageResponse<RelicListVO> pendingRelicPage(RelicPageQueryDTO queryDTO) {
        Page<Relic> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        List<Long> activeRepairRelicIds = repairTaskMapper.selectList(
                Wrappers.<RepairTask>lambdaQuery()
                    .in(RepairTask::getTaskStatus, ACTIVE_TASK_STATUSES)
                    .select(RepairTask::getRelicId)
            ).stream()
            .map(RepairTask::getRelicId)
            .filter(Objects::nonNull)
            .distinct()
            .toList();

        List<String> targetPreservationStatuses = StringUtils.hasText(queryDTO.getPreservationStatusCode())
            ? List.of(queryDTO.getPreservationStatusCode())
            : PENDING_REPAIR_STATUS_CODES;

        Page<Relic> resultPage = relicMapper.selectPage(page,
            Wrappers.<Relic>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(Relic::getRelicNo, queryDTO.getKeyword())
                        .or()
                        .like(Relic::getName, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getCategoryCode()), Relic::getCategoryCode, queryDTO.getCategoryCode())
                .eq(StringUtils.hasText(queryDTO.getMaterialCode()), Relic::getMaterialCode, queryDTO.getMaterialCode())
                .eq(StringUtils.hasText(queryDTO.getStorageLocationCode()), Relic::getStorageLocationCode, queryDTO.getStorageLocationCode())
                .eq(Relic::getCurrentStatus, "IN_STOCK")
                .in(Relic::getPreservationStatusCode, targetPreservationStatuses)
                .notIn(!activeRepairRelicIds.isEmpty(), Relic::getId, activeRepairRelicIds)
                .orderByDesc(Relic::getUpdateTime)
                .orderByDesc(Relic::getId)
        );
        return PageResponse.of(resultPage, resultPage.getRecords().stream().map(this::toRelicListVO).toList());
    }

    @Override
    public PageResponse<RepairTaskListVO> myPage(RepairPageQueryDTO queryDTO) {
        return pageMyTasks(queryDTO, SecurityUtils.getUserId());
    }

    @Override
    public PageResponse<RepairTaskListVO> repairedPage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, REPAIRED_TASK_STATUSES,
            List.of(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_SUCCESS), null);
    }

    @Override
    public RepairDetailVO detail(Long id) {
        RepairTask task = getTaskOrThrow(id);
        RepairDetailVO vo = new RepairDetailVO();
        BeanUtils.copyProperties(task, vo);

        Map<Long, String> userNameMap = loadUserNameMap(
            Stream.of(task.getApplyUserId(), task.getApproveBy())
                .filter(Objects::nonNull)
                .collect(Collectors.toSet())
        );
        vo.setApplyUserName(userNameMap.get(task.getApplyUserId()));
        vo.setApproveUserName(userNameMap.get(task.getApproveBy()));
        vo.setPlan(toPlanVO(loadPlan(id)));
        vo.setLogs(listLogsByTaskId(id).stream()
            .map(this::toLogVO)
            .toList());
        vo.setAcceptance(toAcceptanceVO(loadAcceptanceByTaskId(id)));
        vo.setHistoryTasks(listHistoryTasks(task.getRelicId()).stream()
            .map(this::toHistoryTaskVO)
            .toList());
        vo.setAttachments(listRepairAttachments(task.getRelicId()).stream()
            .map(this::toAttachmentVO)
            .toList());
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createApply(RepairApplyCreateDTO createDTO) {
        Relic relic = relicMapper.selectById(createDTO.getRelicId());
        if (relic == null) {
            throw new BusinessException("Relic does not exist");
        }
        long activeTaskCount = repairTaskMapper.selectCount(
            Wrappers.<RepairTask>lambdaQuery()
                .eq(RepairTask::getRelicId, relic.getId())
                .in(RepairTask::getTaskStatus, ACTIVE_TASK_STATUSES)
        );
        RelicBusinessRuleUtils.validateRepairCreatable(relic, activeTaskCount > 0);

        Long currentUserId = SecurityUtils.getUserId();
        RepairTask task = new RepairTask();
        task.setTaskNo(businessNoService.nextRepairTaskNo());
        task.setRelicId(relic.getId());
        task.setRelicNo(relic.getRelicNo());
        task.setRelicName(relic.getName());
        task.setApplyUserId(currentUserId);
        task.setApplyReason(createDTO.getApplyReason());
        task.setTaskStatus("APPLIED");
        task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_UNACCEPTED);
        task.setApplyTime(LocalDateTime.now());
        task.setRemark(createDTO.getRemark());
        task.setCreateBy(currentUserId);
        task.setUpdateBy(currentUserId);
        task.setDeleted(0);
        repairTaskMapper.insert(task);
        return task.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approve(Long id, RepairApproveDTO approveDTO) {
        RepairTask task = getTaskOrThrow(id);
        Relic relic = relicMapper.selectById(task.getRelicId());
        RelicBusinessRuleUtils.validateRepairReviewable(
            task,
            relic,
            approveDTO.getApproveResult()
        );

        Long currentUserId = SecurityUtils.getUserId();
        task.setApproveBy(currentUserId);
        task.setApproveTime(LocalDateTime.now());
        task.setApproveRemark(approveDTO.getApproveRemark());
        task.setUpdateBy(currentUserId);
        if ("APPROVED".equals(approveDTO.getApproveResult())) {
            task.setTaskStatus("APPROVED");
            task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_UNACCEPTED);
        } else {
            task.setTaskStatus("REJECTED");
            task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_UNACCEPTED);
        }
        repairTaskMapper.updateById(task);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addLog(Long id, RepairLogCreateDTO createDTO) {
        RepairTask task = getTaskOrThrow(id);
        Relic relic = relicMapper.selectById(task.getRelicId());
        RelicBusinessRuleUtils.validateRepairLogAddable(task, relic, createDTO.getProgressStatus());

        Long currentUserId = SecurityUtils.getUserId();
        RepairLog log = new RepairLog();
        log.setRepairTaskId(id);
        log.setLogNo(businessNoService.nextRepairLogNo());
        log.setStepName(createDTO.getStepName());
        log.setOperationContent(createDTO.getOperationContent());
        log.setMaterialsUsed(createDTO.getMaterialsUsed());
        log.setOperatorName(resolveOperatorName(createDTO.getOperatorName()));
        log.setLogTime(createDTO.getLogTime());
        log.setProgressStatus(createDTO.getProgressStatus());
        log.setRemark(createDTO.getRemark());
        log.setCreateBy(currentUserId);
        log.setUpdateBy(currentUserId);
        log.setDeleted(0);
        repairLogMapper.insert(log);
        saveRepairAttachments(task, createDTO.getAttachments(), currentUserId, createDTO.getStepName(), createDTO.getRemark());

        if (relic != null) {
            relic.setCurrentStatus("IN_REPAIR");
            if (!StringUtils.hasText(relic.getPreservationStatusCode())
                || List.of("COMPLETE", "BASIC_COMPLETE").contains(relic.getPreservationStatusCode())) {
                relic.setPreservationStatusCode("PHYSICAL_DAMAGE");
            }
            relic.setUpdateBy(currentUserId);
            relicMapper.updateById(relic);
        }

        task.setStartTime(task.getStartTime() == null ? createDTO.getLogTime() : task.getStartTime());
        task.setUpdateBy(currentUserId);
        if ("COMPLETED".equals(createDTO.getProgressStatus())) {
            task.setTaskStatus("COMPLETED");
            task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_UNACCEPTED);
            task.setEndTime(createDTO.getLogTime());
        } else {
            task.setTaskStatus("IN_PROGRESS");
            if (!StringUtils.hasText(task.getAcceptanceStatus())) {
                task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_UNACCEPTED);
            }
            task.setEndTime(null);
        }
        repairTaskMapper.updateById(task);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void applyAcceptance(Long id) {
        RepairTask task = getTaskOrThrow(id);
        Relic relic = relicMapper.selectById(task.getRelicId());
        RelicBusinessRuleUtils.validateRepairAcceptanceAppliable(task, relic);

        Long currentUserId = SecurityUtils.getUserId();
        task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_WAITING);
        task.setUpdateBy(currentUserId);
        repairTaskMapper.updateById(task);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void accept(Long id, RepairAcceptanceDTO acceptanceDTO) {
        RepairTask task = getTaskOrThrow(id);
        Relic relic = relicMapper.selectById(task.getRelicId());
        RelicBusinessRuleUtils.validateRepairAcceptable(
            task,
            relic,
            acceptanceDTO.getAcceptanceResult(),
            acceptanceDTO.getAcceptanceRemark(),
            acceptanceDTO.getPreservationStatusCode(),
            acceptanceDTO.getStorageLocationCode()
        );

        Long currentUserId = SecurityUtils.getUserId();
        RepairAcceptance entity = repairAcceptanceMapper.selectOne(
            Wrappers.<RepairAcceptance>lambdaQuery()
                .eq(RepairAcceptance::getRepairTaskId, id)
                .last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RepairAcceptance();
            entity.setRepairTaskId(id);
            entity.setAcceptanceNo(businessNoService.nextRepairAcceptanceNo());
            entity.setCreateBy(currentUserId);
            entity.setDeleted(0);
        }
        entity.setAcceptanceResult(acceptanceDTO.getAcceptanceResult());
        entity.setAcceptanceBy(currentUserId);
        entity.setAcceptanceTime(acceptanceDTO.getAcceptanceTime());
        entity.setAcceptanceRemark(acceptanceDTO.getAcceptanceRemark());
        entity.setFollowUpSuggestion(acceptanceDTO.getFollowUpSuggestion());
        entity.setUpdateBy(currentUserId);
        if (entity.getId() == null) {
            repairAcceptanceMapper.insert(entity);
        } else {
            repairAcceptanceMapper.updateById(entity);
        }

        if ("PASS".equals(acceptanceDTO.getAcceptanceResult())) {
            task.setTaskStatus("ACCEPTED");
            task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_SUCCESS);
            if (relic != null) {
                relic.setCurrentStatus("IN_STOCK");
                if (StringUtils.hasText(acceptanceDTO.getPreservationStatusCode())) {
                    relic.setPreservationStatusCode(acceptanceDTO.getPreservationStatusCode());
                }
                if (StringUtils.hasText(acceptanceDTO.getStorageLocationCode())) {
                    relic.setStorageLocationCode(acceptanceDTO.getStorageLocationCode());
                }
                relic.setUpdateBy(currentUserId);
                relicMapper.updateById(relic);
            }
        } else {
            task.setTaskStatus("IN_PROGRESS");
            task.setAcceptanceStatus(RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_REJECTED);
            task.setEndTime(null);
            if (relic != null) {
                relic.setCurrentStatus("IN_REPAIR");
                relic.setUpdateBy(currentUserId);
                relicMapper.updateById(relic);
            }
        }
        task.setUpdateBy(currentUserId);
        repairTaskMapper.updateById(task);
    }

    private PageResponse<RepairTaskListVO> pageByStatuses(RepairPageQueryDTO queryDTO,
                                                          List<String> fixedStatuses,
                                                          List<String> fixedAcceptanceStatuses,
                                                          Long applyUserId) {
        Page<RepairTask> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<RepairTask> resultPage = repairTaskMapper.selectPage(page, buildBaseTaskQuery(queryDTO, applyUserId)
            .in(fixedStatuses != null && !fixedStatuses.isEmpty(), RepairTask::getTaskStatus, fixedStatuses)
            .in(fixedAcceptanceStatuses != null && !fixedAcceptanceStatuses.isEmpty(),
                RepairTask::getAcceptanceStatus, fixedAcceptanceStatuses)
        );
        return toTaskPageResponse(resultPage);
    }

    private PageResponse<RepairTaskListVO> pageMyTasks(RepairPageQueryDTO queryDTO, Long applyUserId) {
        Page<RepairTask> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<RepairTask> resultPage = repairTaskMapper.selectPage(page, buildBaseTaskQuery(queryDTO, applyUserId)
            .and(wrapper -> wrapper
                .in(RepairTask::getTaskStatus, List.of("APPROVED", "IN_PROGRESS"))
                .or(condition -> condition
                    .eq(RepairTask::getTaskStatus, "COMPLETED")
                    .eq(RepairTask::getAcceptanceStatus, RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_UNACCEPTED)))
        );
        return toTaskPageResponse(resultPage);
    }

    private PageResponse<RepairTaskListVO> pageAcceptanceTasks(RepairPageQueryDTO queryDTO) {
        Page<RepairTask> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<RepairTask> resultPage = repairTaskMapper.selectPage(page, buildBaseTaskQuery(queryDTO, null)
            .and(wrapper -> wrapper
                .eq(RepairTask::getTaskStatus, "COMPLETED")
                .eq(RepairTask::getAcceptanceStatus, RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_WAITING)
                .or(condition -> condition
                    .eq(RepairTask::getTaskStatus, "ACCEPTED")
                    .eq(RepairTask::getAcceptanceStatus, RelicBusinessRuleUtils.REPAIR_ACCEPTANCE_STATUS_SUCCESS)))
        );
        return toTaskPageResponse(resultPage);
    }

    private com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<RepairTask> buildBaseTaskQuery(
        RepairPageQueryDTO queryDTO,
        Long applyUserId
    ) {
        return Wrappers.<RepairTask>lambdaQuery()
            .and(StringUtils.hasText(queryDTO.getKeyword()),
                wrapper -> wrapper.like(RepairTask::getTaskNo, queryDTO.getKeyword())
                    .or()
                    .like(RepairTask::getRelicNo, queryDTO.getKeyword())
                    .or()
                    .like(RepairTask::getRelicName, queryDTO.getKeyword()))
            .eq(StringUtils.hasText(queryDTO.getTaskStatus()), RepairTask::getTaskStatus, queryDTO.getTaskStatus())
            .eq(StringUtils.hasText(queryDTO.getAcceptanceStatus()),
                RepairTask::getAcceptanceStatus, queryDTO.getAcceptanceStatus())
            .eq(applyUserId != null, RepairTask::getApplyUserId, applyUserId)
            .orderByDesc(RepairTask::getApplyTime)
            .orderByDesc(RepairTask::getId);
    }

    private RepairTask getTaskOrThrow(Long id) {
        RepairTask task = repairTaskMapper.selectById(id);
        if (task == null) {
            throw new BusinessException("Repair task does not exist");
        }
        return task;
    }

    private RepairPlan loadPlan(Long taskId) {
        return repairPlanMapper.selectOne(
            Wrappers.<RepairPlan>lambdaQuery()
                .eq(RepairPlan::getRepairTaskId, taskId)
                .last("LIMIT 1")
        );
    }

    private List<RepairLog> listLogsByTaskId(Long taskId) {
        return repairLogMapper.selectList(
            Wrappers.<RepairLog>lambdaQuery()
                .eq(RepairLog::getRepairTaskId, taskId)
                .orderByDesc(RepairLog::getLogTime)
        );
    }

    private RepairAcceptance loadAcceptanceByTaskId(Long taskId) {
        return repairAcceptanceMapper.selectOne(
            Wrappers.<RepairAcceptance>lambdaQuery()
                .eq(RepairAcceptance::getRepairTaskId, taskId)
                .last("LIMIT 1")
        );
    }

    private List<RepairTask> listHistoryTasks(Long relicId) {
        return repairTaskMapper.selectList(
            Wrappers.<RepairTask>lambdaQuery()
                .eq(RepairTask::getRelicId, relicId)
                .orderByDesc(RepairTask::getApplyTime)
                .orderByDesc(RepairTask::getId)
        );
    }

    private List<RelicAttachment> listRepairAttachments(Long relicId) {
        return relicAttachmentMapper.selectList(
            Wrappers.<RelicAttachment>lambdaQuery()
                .eq(RelicAttachment::getRelicId, relicId)
                .likeRight(RelicAttachment::getAttachmentType, "REPAIR_")
                .orderByAsc(RelicAttachment::getId)
        );
    }

    private PageResponse<RepairTaskListVO> toTaskPageResponse(Page<RepairTask> resultPage) {
        Map<Long, String> userNameMap = loadApplyUserNameMap(resultPage.getRecords());
        List<RepairTaskListVO> records = resultPage.getRecords().stream()
            .map(task -> toListVO(task, userNameMap.get(task.getApplyUserId())))
            .toList();
        return PageResponse.of(resultPage, records);
    }

    private Map<Long, String> loadApplyUserNameMap(List<RepairTask> tasks) {
        return loadUserNameMap(tasks.stream()
            .map(RepairTask::getApplyUserId)
            .collect(Collectors.toSet()));
    }

    private RepairTaskListVO toListVO(RepairTask task, String applyUserName) {
        RepairTaskListVO vo = new RepairTaskListVO();
        BeanUtils.copyProperties(task, vo);
        vo.setApplyUserName(applyUserName);
        return vo;
    }

    private RepairPlanVO toPlanVO(RepairPlan entity) {
        if (entity == null) {
            return null;
        }
        RepairPlanVO vo = new RepairPlanVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private RepairLogVO toLogVO(RepairLog entity) {
        RepairLogVO vo = new RepairLogVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private RepairHistoryTaskVO toHistoryTaskVO(RepairTask entity) {
        RepairHistoryTaskVO vo = new RepairHistoryTaskVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private RepairAcceptanceVO toAcceptanceVO(RepairAcceptance entity) {
        if (entity == null) {
            return null;
        }
        RepairAcceptanceVO vo = new RepairAcceptanceVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private RelicAttachmentVO toAttachmentVO(RelicAttachment entity) {
        RelicAttachmentVO vo = new RelicAttachmentVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private RelicListVO toRelicListVO(Relic entity) {
        RelicListVO vo = new RelicListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private Map<Long, String> loadUserNameMap(Set<Long> userIds) {
        List<Long> filteredUserIds = userIds == null
            ? List.of()
            : userIds.stream().filter(Objects::nonNull).distinct().toList();
        if (filteredUserIds.isEmpty()) {
            return Collections.emptyMap();
        }
        return sysUserMapper.selectBatchIds(filteredUserIds)
            .stream()
            .collect(Collectors.toMap(SysUser::getId, this::resolveUserName));
    }

    private String resolveUserName(SysUser user) {
        if (user == null) {
            return null;
        }
        if (StringUtils.hasText(user.getRealName())) {
            return user.getRealName();
        }
        if (StringUtils.hasText(user.getNickName())) {
            return user.getNickName();
        }
        return user.getUsername();
    }

    private String resolveOperatorName(String operatorName) {
        if (StringUtils.hasText(operatorName)) {
            return operatorName.trim();
        }
        return StringUtils.hasText(SecurityUtils.getUsername()) ? SecurityUtils.getUsername() : "当前用户";
    }

    private void saveRepairAttachments(RepairTask task,
                                       List<AttachmentSaveDTO> attachments,
                                       Long currentUserId,
                                       String stepName,
                                       String logRemark) {
        if (task == null || task.getRelicId() == null || attachments == null || attachments.isEmpty()) {
            return;
        }
        for (AttachmentSaveDTO attachment : attachments) {
            if (attachment == null || !StringUtils.hasText(attachment.getFileUrl())) {
                continue;
            }
            RelicAttachment entity = new RelicAttachment();
            entity.setRelicId(task.getRelicId());
            entity.setAttachmentType(resolveRepairAttachmentType(attachment));
            entity.setFileName(attachment.getFileName());
            entity.setFileUrl(attachment.getFileUrl());
            entity.setFileSize(attachment.getFileSize());
            entity.setFileSuffix(attachment.getFileSuffix());
            entity.setRemark(buildRepairAttachmentRemark(task.getId(), stepName, attachment.getRemark(), logRemark));
            entity.setCreateBy(currentUserId);
            entity.setUpdateBy(currentUserId);
            entity.setDeleted(0);
            relicAttachmentMapper.insert(entity);
        }
    }

    private String resolveRepairAttachmentType(AttachmentSaveDTO attachment) {
        if (attachment == null) {
            return "REPAIR_FILE";
        }
        if (StringUtils.hasText(attachment.getAttachmentType()) && attachment.getAttachmentType().startsWith("REPAIR_")) {
            return attachment.getAttachmentType();
        }

        String suffix = attachment.getFileSuffix();
        if (!StringUtils.hasText(suffix) && StringUtils.hasText(attachment.getFileName())) {
            int index = attachment.getFileName().lastIndexOf('.');
            suffix = index >= 0 ? attachment.getFileName().substring(index + 1) : "";
        }
        return IMAGE_SUFFIXES.contains(suffix == null ? "" : suffix.toLowerCase()) ? "REPAIR_IMAGE" : "REPAIR_FILE";
    }

    private String buildRepairAttachmentRemark(Long taskId,
                                               String stepName,
                                               String attachmentRemark,
                                               String logRemark) {
        String resolvedStepName = StringUtils.hasText(stepName) ? stepName : "Unnamed step";
        String resolvedRemark = StringUtils.hasText(attachmentRemark)
            ? attachmentRemark
            : (StringUtils.hasText(logRemark) ? logRemark : "No remark");
        return String.format("repairTaskId=%s;step=%s;remark=%s", taskId, resolvedStepName, resolvedRemark);
    }
}

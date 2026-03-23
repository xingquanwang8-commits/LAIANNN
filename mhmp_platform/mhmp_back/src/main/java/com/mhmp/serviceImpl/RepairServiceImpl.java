package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.OrderNoUtils;
import com.mhmp.common.util.SecurityUtils;
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
import com.mhmp.entity.SysUser;
import com.mhmp.mapper.RepairAcceptanceMapper;
import com.mhmp.mapper.RepairLogMapper;
import com.mhmp.mapper.RepairPlanMapper;
import com.mhmp.mapper.RepairTaskMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.mapper.SysUserMapper;
import com.mhmp.service.RepairService;
import com.mhmp.vo.RepairAcceptanceVO;
import com.mhmp.vo.RepairDetailVO;
import com.mhmp.vo.RepairLogVO;
import com.mhmp.vo.RepairPlanVO;
import com.mhmp.vo.RepairTaskListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class RepairServiceImpl implements RepairService {

    private final RepairTaskMapper repairTaskMapper;
    private final RepairPlanMapper repairPlanMapper;
    private final RepairLogMapper repairLogMapper;
    private final RepairAcceptanceMapper repairAcceptanceMapper;
    private final RelicMapper relicMapper;
    private final SysUserMapper sysUserMapper;

    public RepairServiceImpl(RepairTaskMapper repairTaskMapper,
                             RepairPlanMapper repairPlanMapper,
                             RepairLogMapper repairLogMapper,
                             RepairAcceptanceMapper repairAcceptanceMapper,
                             RelicMapper relicMapper,
                             SysUserMapper sysUserMapper) {
        this.repairTaskMapper = repairTaskMapper;
        this.repairPlanMapper = repairPlanMapper;
        this.repairLogMapper = repairLogMapper;
        this.repairAcceptanceMapper = repairAcceptanceMapper;
        this.relicMapper = relicMapper;
        this.sysUserMapper = sysUserMapper;
    }

    @Override
    public PageResponse<RepairTaskListVO> applyPage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, null);
    }

    @Override
    public PageResponse<RepairTaskListVO> approvePage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, List.of("APPLIED", "APPROVED", "REJECTED"));
    }

    @Override
    public PageResponse<RepairTaskListVO> processPage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, List.of("APPROVED", "IN_PROGRESS", "COMPLETED"));
    }

    @Override
    public PageResponse<RepairTaskListVO> acceptancePage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, List.of("COMPLETED", "ACCEPTED"));
    }

    @Override
    public PageResponse<RepairTaskListVO> historyPage(RepairPageQueryDTO queryDTO) {
        return pageByStatuses(queryDTO, null);
    }

    @Override
    public RepairDetailVO detail(Long id) {
        RepairTask task = getTaskOrThrow(id);
        RepairDetailVO vo = new RepairDetailVO();
        BeanUtils.copyProperties(task, vo);
        Map<Long, String> userNameMap = loadUserNameMap(Set.of(task.getApplyUserId(), task.getApproveBy()));
        vo.setApplyUserName(userNameMap.get(task.getApplyUserId()));
        vo.setApproveUserName(userNameMap.get(task.getApproveBy()));
        vo.setPlan(toPlanVO(repairPlanMapper.selectOne(
            Wrappers.<RepairPlan>lambdaQuery().eq(RepairPlan::getRepairTaskId, id).last("LIMIT 1")
        )));
        vo.setLogs(repairLogMapper.selectList(
                Wrappers.<RepairLog>lambdaQuery().eq(RepairLog::getRepairTaskId, id).orderByDesc(RepairLog::getLogTime)
            ).stream()
            .map(this::toLogVO)
            .toList());
        vo.setAcceptance(toAcceptanceVO(repairAcceptanceMapper.selectOne(
            Wrappers.<RepairAcceptance>lambdaQuery().eq(RepairAcceptance::getRepairTaskId, id).last("LIMIT 1")
        )));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createApply(RepairApplyCreateDTO createDTO) {
        Relic relic = relicMapper.selectById(createDTO.getRelicId());
        if (relic == null) {
            throw new BusinessException("Relic does not exist");
        }
        if (!"IN_STOCK".equals(relic.getCurrentStatus())) {
            throw new BusinessException("Only in-stock relics can initiate repair");
        }
        Long currentUserId = SecurityUtils.getUserId();
        RepairTask task = new RepairTask();
        task.setTaskNo(OrderNoUtils.nextOrderNo("REP"));
        task.setRelicId(relic.getId());
        task.setRelicNo(relic.getRelicNo());
        task.setRelicName(relic.getName());
        task.setApplyUserId(currentUserId);
        task.setApplyReason(createDTO.getApplyReason());
        task.setTaskStatus("APPLIED");
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
        if (!"APPLIED".equals(task.getTaskStatus())) {
            throw new BusinessException("Only applied tasks can be reviewed");
        }
        Long currentUserId = SecurityUtils.getUserId();
        task.setApproveBy(currentUserId);
        task.setApproveTime(LocalDateTime.now());
        task.setApproveRemark(approveDTO.getApproveRemark());
        task.setUpdateBy(currentUserId);
        if ("APPROVED".equals(approveDTO.getApproveResult())) {
            if (!StringUtils.hasText(approveDTO.getPlanTitle()) || !StringUtils.hasText(approveDTO.getPlanContent())) {
                throw new BusinessException("Approved repair tasks must provide a repair plan");
            }
            task.setTaskStatus("APPROVED");
            saveOrUpdatePlan(task, approveDTO, currentUserId);
        } else if ("REJECTED".equals(approveDTO.getApproveResult())) {
            task.setTaskStatus("REJECTED");
        } else {
            throw new BusinessException("Unsupported approve result");
        }
        repairTaskMapper.updateById(task);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addLog(Long id, RepairLogCreateDTO createDTO) {
        RepairTask task = getTaskOrThrow(id);
        if (!List.of("APPROVED", "IN_PROGRESS", "COMPLETED").contains(task.getTaskStatus())) {
            throw new BusinessException("Current task status does not allow adding repair logs");
        }
        Long currentUserId = SecurityUtils.getUserId();
        RepairLog log = new RepairLog();
        log.setRepairTaskId(id);
        log.setLogNo(OrderNoUtils.nextOrderNo("LOG"));
        log.setStepName(createDTO.getStepName());
        log.setOperationContent(createDTO.getOperationContent());
        log.setMaterialsUsed(createDTO.getMaterialsUsed());
        log.setOperatorName(createDTO.getOperatorName());
        log.setLogTime(createDTO.getLogTime());
        log.setProgressStatus(createDTO.getProgressStatus());
        log.setRemark(createDTO.getRemark());
        log.setCreateBy(currentUserId);
        log.setUpdateBy(currentUserId);
        log.setDeleted(0);
        repairLogMapper.insert(log);

        Relic relic = relicMapper.selectById(task.getRelicId());
        if (relic != null) {
            relic.setCurrentStatus("IN_REPAIR");
            relic.setPreservationStatusCode("UNDER_REPAIR");
            relic.setUpdateBy(currentUserId);
            relicMapper.updateById(relic);
        }

        task.setStartTime(task.getStartTime() == null ? createDTO.getLogTime() : task.getStartTime());
        task.setUpdateBy(currentUserId);
        if ("COMPLETED".equals(createDTO.getProgressStatus())) {
            task.setTaskStatus("COMPLETED");
            task.setEndTime(createDTO.getLogTime());
        } else {
            task.setTaskStatus("IN_PROGRESS");
            task.setEndTime(null);
        }
        repairTaskMapper.updateById(task);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void accept(Long id, RepairAcceptanceDTO acceptanceDTO) {
        RepairTask task = getTaskOrThrow(id);
        if (!List.of("COMPLETED", "ACCEPTED").contains(task.getTaskStatus())) {
            throw new BusinessException("Only completed repair tasks can be accepted");
        }
        Long currentUserId = SecurityUtils.getUserId();
        RepairAcceptance entity = repairAcceptanceMapper.selectOne(
            Wrappers.<RepairAcceptance>lambdaQuery().eq(RepairAcceptance::getRepairTaskId, id).last("LIMIT 1")
        );
        if (entity == null) {
            entity = new RepairAcceptance();
            entity.setRepairTaskId(id);
            entity.setAcceptanceNo(OrderNoUtils.nextOrderNo("ACC"));
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

        Relic relic = relicMapper.selectById(task.getRelicId());
        if ("PASS".equals(acceptanceDTO.getAcceptanceResult())) {
            task.setTaskStatus("ACCEPTED");
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
            task.setTaskStatus("COMPLETED");
            if (relic != null) {
                relic.setCurrentStatus("IN_REPAIR");
                relic.setUpdateBy(currentUserId);
                relicMapper.updateById(relic);
            }
        }
        task.setUpdateBy(currentUserId);
        repairTaskMapper.updateById(task);
    }

    private PageResponse<RepairTaskListVO> pageByStatuses(RepairPageQueryDTO queryDTO, List<String> fixedStatuses) {
        Page<RepairTask> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<RepairTask> resultPage = repairTaskMapper.selectPage(page,
            Wrappers.<RepairTask>lambdaQuery()
                .and(StringUtils.hasText(queryDTO.getKeyword()),
                    wrapper -> wrapper.like(RepairTask::getTaskNo, queryDTO.getKeyword())
                        .or().like(RepairTask::getRelicNo, queryDTO.getKeyword())
                        .or().like(RepairTask::getRelicName, queryDTO.getKeyword()))
                .eq(StringUtils.hasText(queryDTO.getTaskStatus()), RepairTask::getTaskStatus, queryDTO.getTaskStatus())
                .in(fixedStatuses != null && !fixedStatuses.isEmpty(), RepairTask::getTaskStatus, fixedStatuses)
                .orderByDesc(RepairTask::getApplyTime)
                .orderByDesc(RepairTask::getId)
        );
        Map<Long, String> userNameMap = loadUserNameMap(
            resultPage.getRecords().stream().map(RepairTask::getApplyUserId).collect(Collectors.toSet())
        );
        List<RepairTaskListVO> records = resultPage.getRecords().stream()
            .map(task -> toListVO(task, userNameMap.get(task.getApplyUserId())))
            .toList();
        return PageResponse.of(resultPage, records);
    }

    private RepairTask getTaskOrThrow(Long id) {
        RepairTask task = repairTaskMapper.selectById(id);
        if (task == null) {
            throw new BusinessException("Repair task does not exist");
        }
        return task;
    }

    private void saveOrUpdatePlan(RepairTask task, RepairApproveDTO approveDTO, Long currentUserId) {
        RepairPlan plan = repairPlanMapper.selectOne(
            Wrappers.<RepairPlan>lambdaQuery().eq(RepairPlan::getRepairTaskId, task.getId()).last("LIMIT 1")
        );
        if (plan == null) {
            plan = new RepairPlan();
            plan.setRepairTaskId(task.getId());
            plan.setPlanNo(OrderNoUtils.nextOrderNo("PLAN"));
            plan.setCreateBy(currentUserId);
            plan.setDeleted(0);
        }
        SysUser applyUser = sysUserMapper.selectById(task.getApplyUserId());
        plan.setPlanTitle(approveDTO.getPlanTitle());
        plan.setPlanContent(approveDTO.getPlanContent());
        plan.setMaterials(approveDTO.getMaterials());
        plan.setRiskNote(approveDTO.getRiskNote());
        plan.setPlanStatus("APPROVED");
        plan.setSubmitterName(resolveUserName(applyUser));
        plan.setReviewerName(resolveUserName(sysUserMapper.selectById(currentUserId)));
        plan.setReviewTime(LocalDateTime.now());
        plan.setReviewRemark(approveDTO.getApproveRemark());
        plan.setUpdateBy(currentUserId);
        if (plan.getId() == null) {
            repairPlanMapper.insert(plan);
        } else {
            repairPlanMapper.updateById(plan);
        }
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

    private RepairAcceptanceVO toAcceptanceVO(RepairAcceptance entity) {
        if (entity == null) {
            return null;
        }
        RepairAcceptanceVO vo = new RepairAcceptanceVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private Map<Long, String> loadUserNameMap(Set<Long> userIds) {
        return sysUserMapper.selectBatchIds(userIds.stream().filter(Objects::nonNull).toList())
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
}

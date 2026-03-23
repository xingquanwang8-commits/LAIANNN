package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.common.util.OrderNoUtils;
import com.mhmp.common.util.SecurityUtils;
import com.mhmp.dto.InventoryQueryPageDTO;
import com.mhmp.dto.InventoryTaskCreateDTO;
import com.mhmp.dto.InventoryTaskDetailUpdateDTO;
import com.mhmp.dto.InventoryTaskPageQueryDTO;
import com.mhmp.entity.InventoryTask;
import com.mhmp.entity.InventoryTaskDetail;
import com.mhmp.entity.Relic;
import com.mhmp.mapper.InventoryTaskDetailMapper;
import com.mhmp.mapper.InventoryTaskMapper;
import com.mhmp.mapper.RelicMapper;
import com.mhmp.service.InventoryService;
import com.mhmp.vo.InventorySummaryVO;
import com.mhmp.vo.InventoryTaskDetailVO;
import com.mhmp.vo.InventoryTaskItemVO;
import com.mhmp.vo.InventoryTaskListVO;
import com.mhmp.vo.RelicListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class InventoryServiceImpl implements InventoryService {

    private final RelicMapper relicMapper;
    private final InventoryTaskMapper inventoryTaskMapper;
    private final InventoryTaskDetailMapper inventoryTaskDetailMapper;

    public InventoryServiceImpl(RelicMapper relicMapper,
                                InventoryTaskMapper inventoryTaskMapper,
                                InventoryTaskDetailMapper inventoryTaskDetailMapper) {
        this.relicMapper = relicMapper;
        this.inventoryTaskMapper = inventoryTaskMapper;
        this.inventoryTaskDetailMapper = inventoryTaskDetailMapper;
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
                        .or().like(Relic::getName, queryDTO.getKeyword()))
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
                .orderByDesc(InventoryTask::getStartTime)
                .orderByDesc(InventoryTask::getId)
        );
        List<InventoryTaskListVO> records = resultPage.getRecords().stream().map(this::toTaskListVO).toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public InventoryTaskDetailVO taskDetail(Long id) {
        InventoryTask task = getTaskOrThrow(id);
        InventoryTaskDetailVO vo = new InventoryTaskDetailVO();
        BeanUtils.copyProperties(task, vo);
        vo.setDetails(inventoryTaskDetailMapper.selectList(
                Wrappers.<InventoryTaskDetail>lambdaQuery()
                    .eq(InventoryTaskDetail::getTaskId, id)
                    .orderByAsc(InventoryTaskDetail::getId)
            ).stream()
            .map(this::toTaskItemVO)
            .toList());
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createTask(InventoryTaskCreateDTO createDTO) {
        List<Relic> relics = relicMapper.selectList(
            Wrappers.<Relic>lambdaQuery()
                .eq(Relic::getStorageLocationCode, createDTO.getLocationCode())
                .eq(Relic::getCurrentStatus, "IN_STOCK")
                .orderByAsc(Relic::getId)
        );
        if (relics.isEmpty()) {
            throw new BusinessException("No in-stock relics found at the selected location");
        }
        Long currentUserId = SecurityUtils.getUserId();
        InventoryTask task = new InventoryTask();
        task.setTaskNo(OrderNoUtils.nextOrderNo("INV"));
        task.setTaskName(createDTO.getTaskName());
        task.setLocationCode(createDTO.getLocationCode());
        task.setTaskStatus("CREATED");
        task.setStartTime(createDTO.getStartTime());
        task.setPrincipalName(createDTO.getPrincipalName());
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
        if ("COMPLETED".equals(task.getTaskStatus())) {
            throw new BusinessException("Completed inventory tasks cannot be edited");
        }
        InventoryTaskDetail detail = inventoryTaskDetailMapper.selectById(detailId);
        if (detail == null || !taskId.equals(detail.getTaskId())) {
            throw new BusinessException("Inventory task detail does not exist");
        }
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
        if ("COMPLETED".equals(task.getTaskStatus())) {
            throw new BusinessException("Task has already been submitted");
        }
        List<InventoryTaskDetail> details = inventoryTaskDetailMapper.selectList(
            Wrappers.<InventoryTaskDetail>lambdaQuery().eq(InventoryTaskDetail::getTaskId, taskId)
        );
        boolean hasPending = details.stream().anyMatch(detail -> "PENDING".equals(detail.getResultStatus()));
        if (hasPending) {
            throw new BusinessException("There are still unsubmitted inventory detail records");
        }
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
            throw new BusinessException("Inventory task does not exist");
        }
        return task;
    }

    private RelicListVO toRelicListVO(Relic entity) {
        RelicListVO vo = new RelicListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private InventoryTaskListVO toTaskListVO(InventoryTask entity) {
        InventoryTaskListVO vo = new InventoryTaskListVO();
        BeanUtils.copyProperties(entity, vo);
        List<InventoryTaskDetail> details = inventoryTaskDetailMapper.selectList(
            Wrappers.<InventoryTaskDetail>lambdaQuery().eq(InventoryTaskDetail::getTaskId, entity.getId())
        );
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
}

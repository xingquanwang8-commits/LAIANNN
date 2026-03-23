package com.mhmp.serviceImpl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.LogPageQueryDTO;
import com.mhmp.entity.SysOperationLog;
import com.mhmp.mapper.SysOperationLogMapper;
import com.mhmp.service.SystemLogService;
import com.mhmp.vo.OperationLogDetailVO;
import com.mhmp.vo.OperationLogListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class SystemLogServiceImpl implements SystemLogService {

    private final SysOperationLogMapper sysOperationLogMapper;

    public SystemLogServiceImpl(SysOperationLogMapper sysOperationLogMapper) {
        this.sysOperationLogMapper = sysOperationLogMapper;
    }

    @Override
    public PageResponse<OperationLogListVO> page(LogPageQueryDTO queryDTO) {
        Page<SysOperationLog> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Page<SysOperationLog> resultPage = sysOperationLogMapper.selectPage(page,
            Wrappers.<SysOperationLog>lambdaQuery()
                .like(StringUtils.hasText(queryDTO.getUsername()), SysOperationLog::getUsername, queryDTO.getUsername())
                .like(StringUtils.hasText(queryDTO.getModuleName()), SysOperationLog::getModuleName, queryDTO.getModuleName())
                .eq(StringUtils.hasText(queryDTO.getBusinessType()), SysOperationLog::getBusinessType, queryDTO.getBusinessType())
                .eq(StringUtils.hasText(queryDTO.getOperationStatus()), SysOperationLog::getOperationStatus, queryDTO.getOperationStatus())
                .ge(queryDTO.getStartTime() != null, SysOperationLog::getOperationTime, queryDTO.getStartTime())
                .le(queryDTO.getEndTime() != null, SysOperationLog::getOperationTime, queryDTO.getEndTime())
                .orderByDesc(SysOperationLog::getOperationTime)
                .orderByDesc(SysOperationLog::getId)
        );
        List<OperationLogListVO> records = resultPage.getRecords().stream().map(this::toListVO).toList();
        return PageResponse.of(resultPage, records);
    }

    @Override
    public OperationLogDetailVO detail(Long id) {
        SysOperationLog entity = sysOperationLogMapper.selectById(id);
        if (entity == null) {
            throw new BusinessException("Operation log does not exist");
        }
        OperationLogDetailVO vo = new OperationLogDetailVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }

    private OperationLogListVO toListVO(SysOperationLog entity) {
        OperationLogListVO vo = new OperationLogListVO();
        BeanUtils.copyProperties(entity, vo);
        return vo;
    }
}

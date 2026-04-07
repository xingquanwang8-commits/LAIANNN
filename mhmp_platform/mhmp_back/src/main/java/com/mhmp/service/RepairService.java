package com.mhmp.service;

import com.mhmp.common.result.PageResponse;
import com.mhmp.dto.RelicPageQueryDTO;
import com.mhmp.dto.RepairAcceptanceDTO;
import com.mhmp.dto.RepairApplyCreateDTO;
import com.mhmp.dto.RepairApproveDTO;
import com.mhmp.dto.RepairLogCreateDTO;
import com.mhmp.dto.RepairPageQueryDTO;
import com.mhmp.vo.RelicListVO;
import com.mhmp.vo.RepairDetailVO;
import com.mhmp.vo.RepairTaskListVO;

public interface RepairService {

    PageResponse<RepairTaskListVO> applyPage(RepairPageQueryDTO queryDTO);

    PageResponse<RepairTaskListVO> approvePage(RepairPageQueryDTO queryDTO);

    PageResponse<RepairTaskListVO> processPage(RepairPageQueryDTO queryDTO);

    PageResponse<RepairTaskListVO> acceptancePage(RepairPageQueryDTO queryDTO);

    PageResponse<RepairTaskListVO> historyPage(RepairPageQueryDTO queryDTO);

    PageResponse<RelicListVO> pendingRelicPage(RelicPageQueryDTO queryDTO);

    PageResponse<RepairTaskListVO> myPage(RepairPageQueryDTO queryDTO);

    PageResponse<RepairTaskListVO> repairedPage(RepairPageQueryDTO queryDTO);

    RepairDetailVO detail(Long id);

    Long createApply(RepairApplyCreateDTO createDTO);

    void approve(Long id, RepairApproveDTO approveDTO);

    void addLog(Long id, RepairLogCreateDTO createDTO);

    void applyAcceptance(Long id);

    void accept(Long id, RepairAcceptanceDTO acceptanceDTO);
}

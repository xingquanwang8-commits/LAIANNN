package com.mhmp.controller;

import com.mhmp.common.result.Result;
import com.mhmp.service.DashboardService;
import com.mhmp.vo.DashboardSummaryVO;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/summary")
    @PreAuthorize("hasAuthority('dashboard:view')")
    public Result<DashboardSummaryVO> summary() {
        return Result.success(dashboardService.summary());
    }
}

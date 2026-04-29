package com.mhmp.controller;

import com.mhmp.common.result.R;
import com.mhmp.service.DashboardService;
import com.mhmp.vo.DashboardHomeVO;
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
    public R<DashboardSummaryVO> summary() {
        return R.success(dashboardService.summary());
    }

    @GetMapping("/home")
    @PreAuthorize("hasAuthority('dashboard:view')")
    public R<DashboardHomeVO> home() {
        return R.success(dashboardService.home());
    }
}

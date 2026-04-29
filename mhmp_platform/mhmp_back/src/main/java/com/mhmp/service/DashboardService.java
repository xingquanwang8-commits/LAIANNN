package com.mhmp.service;

import com.mhmp.vo.DashboardSummaryVO;
import com.mhmp.vo.DashboardHomeVO;

public interface DashboardService {

    DashboardSummaryVO summary();

    DashboardHomeVO home();
}

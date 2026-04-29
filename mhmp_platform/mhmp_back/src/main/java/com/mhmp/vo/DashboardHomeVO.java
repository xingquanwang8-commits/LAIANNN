package com.mhmp.vo;

import lombok.Data;

import java.util.List;

@Data
public class DashboardHomeVO {

    private String badge;

    private String title;

    private String description;

    private List<HomeCardVO> cards;

    @Data
    public static class HomeCardVO {

        private String orderNo;

        private String title;

        private String description;
    }
}

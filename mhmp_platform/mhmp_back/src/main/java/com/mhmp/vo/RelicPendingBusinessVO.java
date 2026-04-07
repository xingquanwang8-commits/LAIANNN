package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RelicPendingBusinessVO {

    private String businessType;

    private Long relatedId;

    private String title;

    private String description;

    private String status;

    private LocalDateTime eventTime;
}

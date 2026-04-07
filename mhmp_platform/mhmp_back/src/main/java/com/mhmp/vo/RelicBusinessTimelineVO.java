package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RelicBusinessTimelineVO {

    private String eventType;

    private String title;

    private String description;

    private String status;

    private LocalDateTime eventTime;

    private Long relatedId;
}

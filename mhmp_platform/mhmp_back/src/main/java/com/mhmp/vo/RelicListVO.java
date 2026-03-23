package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RelicListVO {

    private Long id;
    private String relicNo;
    private String name;
    private String categoryCode;
    private String materialCode;
    private String era;
    private String storageLocationCode;
    private String preservationStatusCode;
    private String currentStatus;
    private String imageUrl;
    private LocalDateTime updateTime;
}

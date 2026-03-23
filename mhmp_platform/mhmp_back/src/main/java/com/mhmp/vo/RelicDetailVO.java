package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class RelicDetailVO {

    private Long id;
    private String relicNo;
    private String name;
    private String categoryCode;
    private String materialCode;
    private String era;
    private String source;
    private String storageLocationCode;
    private String preservationStatusCode;
    private String currentStatus;
    private String protectionLevel;
    private String storageCondition;
    private String attentionNote;
    private String description;
    private String note;
    private String imageUrl;
    private String appraisalReportUrl;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private List<RelicAttachmentVO> attachments;
}

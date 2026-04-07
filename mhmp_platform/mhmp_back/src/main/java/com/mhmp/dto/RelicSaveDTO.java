package com.mhmp.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class RelicSaveDTO {

    private String relicNo;

    @jakarta.validation.constraints.NotBlank(message = "文物名称不能为空")
    private String name;

    @jakarta.validation.constraints.NotBlank(message = "文物类别不能为空")
    private String categoryCode;

    @jakarta.validation.constraints.NotBlank(message = "材质不能为空")
    private String materialCode;

    private String era;
    private String source;
    private String storageLocationCode;
    private String preservationStatusCode;

    @jakarta.validation.constraints.NotBlank(message = "当前状态不能为空")
    private String currentStatus;

    private String protectionLevel;
    private String storageCondition;
    private String attentionNote;
    private String description;
    private String note;
    private String imageUrl;
    private String appraisalReportUrl;
    private List<AttachmentSaveDTO> attachments = new ArrayList<>();
}

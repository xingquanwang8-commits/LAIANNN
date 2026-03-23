package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RelicSaveDTO {

    @NotBlank(message = "文物编号不能为空")
    private String relicNo;

    @NotBlank(message = "文物名称不能为空")
    private String name;

    @NotBlank(message = "文物类别不能为空")
    private String categoryCode;

    @NotBlank(message = "材质不能为空")
    private String materialCode;

    private String era;
    private String source;
    private String storageLocationCode;
    private String preservationStatusCode;

    @NotBlank(message = "当前状态不能为空")
    private String currentStatus;

    private String protectionLevel;
    private String storageCondition;
    private String attentionNote;
    private String description;
    private String note;
    private String imageUrl;
    private String appraisalReportUrl;
}

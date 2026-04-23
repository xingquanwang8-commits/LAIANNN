package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
public class RepairLogCreateDTO {

    @NotBlank(message = "步骤名称不能为空")
    private String stepName;

    @NotBlank(message = "操作内容不能为空")
    private String operationContent;

    private String materialsUsed;

    private String operatorName;

    @NotNull(message = "记录时间不能为空")
    private LocalDateTime logTime;

    @NotBlank(message = "进度状态不能为空")
    private String progressStatus;

    private String remark;

    private List<AttachmentSaveDTO> attachments = new ArrayList<>();
}

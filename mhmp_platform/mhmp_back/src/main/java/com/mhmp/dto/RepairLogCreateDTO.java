package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
public class RepairLogCreateDTO {

    @NotBlank(message = "stepName is required")
    private String stepName;

    @NotBlank(message = "operationContent is required")
    private String operationContent;

    private String materialsUsed;

    @NotBlank(message = "operatorName is required")
    private String operatorName;

    @NotNull(message = "logTime is required")
    private LocalDateTime logTime;

    @NotBlank(message = "progressStatus is required")
    private String progressStatus;

    private String remark;

    private List<AttachmentSaveDTO> attachments = new ArrayList<>();
}

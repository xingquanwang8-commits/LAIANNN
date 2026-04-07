package com.mhmp.dto;

import lombok.Data;

@Data
public class AttachmentSaveDTO {

    private String attachmentType;

    private String fileName;

    private String fileUrl;

    private Long fileSize;

    private String fileSuffix;

    private String remark;
}

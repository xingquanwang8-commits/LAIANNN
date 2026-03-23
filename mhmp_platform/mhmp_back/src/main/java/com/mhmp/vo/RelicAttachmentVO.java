package com.mhmp.vo;

import lombok.Data;

@Data
public class RelicAttachmentVO {

    private Long id;
    private String attachmentType;
    private String fileName;
    private String fileUrl;
    private Long fileSize;
    private String fileSuffix;
    private String remark;
}

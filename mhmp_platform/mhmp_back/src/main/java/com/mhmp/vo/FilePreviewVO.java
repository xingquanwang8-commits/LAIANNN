package com.mhmp.vo;

import lombok.Data;

@Data
public class FilePreviewVO {

    private String fileName;

    private String fileUrl;

    private String fileSuffix;

    private String previewType;

    private String content;

    private String message;
}

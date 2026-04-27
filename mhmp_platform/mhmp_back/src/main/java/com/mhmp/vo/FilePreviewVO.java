package com.mhmp.vo;

import lombok.Data;

@Data
public class FilePreviewVO {

    private String fileSuffix;
    private String previewType;
    private Boolean previewable;
    private String content;
    private String message;
}

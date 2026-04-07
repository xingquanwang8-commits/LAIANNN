package com.mhmp.vo;

import lombok.Data;

@Data
public class FileUploadVO {

    private String fileName;

    private String fileUrl;

    private Long fileSize;

    private String fileSuffix;
}

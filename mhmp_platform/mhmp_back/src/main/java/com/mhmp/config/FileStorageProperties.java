package com.mhmp.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "mhmp.file")
public class FileStorageProperties {

    private String basePath = "uploads";
}

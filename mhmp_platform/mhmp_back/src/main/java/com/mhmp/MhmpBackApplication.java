package com.mhmp;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@MapperScan("com.mhmp.mapper")
@ConfigurationPropertiesScan
public class MhmpBackApplication {

    public static void main(String[] args) {
        SpringApplication.run(MhmpBackApplication.class, args);
    }
}

package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class UserSaveDTO {

    @NotBlank(message = "username is required")
    private String username;

    private String password;

    private String nickName;

    private String realName;

    private String phone;

    private String email;

    private String gender;

    private String avatarUrl;

    private String status;

    private String remark;

    private List<Long> roleIds;
}

package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.NotEmpty;
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

    @NotEmpty(message = "roleIds is required")
    @Size(max = 1, message = "roleIds supports only one primary role")
    private List<Long> roleIds;
}

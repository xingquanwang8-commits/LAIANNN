package com.mhmp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.util.List;

@Data
public class UserSaveDTO {

    @NotBlank(message = "用户名不能为空")
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

    @NotEmpty(message = "请选择主角色")
    @Size(max = 1, message = "一个账号只能绑定一个主角色")
    private List<Long> roleIds;
}

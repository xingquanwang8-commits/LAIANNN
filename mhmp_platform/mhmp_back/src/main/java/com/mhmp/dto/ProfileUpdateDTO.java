package com.mhmp.dto;

import lombok.Data;

@Data
public class ProfileUpdateDTO {

    private String nickName;

    private String realName;

    private String phone;

    private String email;

    private String gender;

    private String avatarUrl;

    private String remark;
}

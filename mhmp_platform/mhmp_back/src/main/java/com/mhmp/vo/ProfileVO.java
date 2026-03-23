package com.mhmp.vo;

import lombok.Data;

import java.util.List;

@Data
public class ProfileVO {

    private Long id;
    private String username;
    private String nickName;
    private String realName;
    private String phone;
    private String email;
    private String gender;
    private String avatarUrl;
    private String remark;
    private List<String> roles;
}

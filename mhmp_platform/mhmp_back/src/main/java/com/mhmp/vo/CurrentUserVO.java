package com.mhmp.vo;

import lombok.Data;

import java.util.List;

@Data
public class CurrentUserVO {

    private Long id;
    private String username;
    private String nickName;
    private String realName;
    private String avatarUrl;
    private List<String> roles;
    private List<String> permissions;
}

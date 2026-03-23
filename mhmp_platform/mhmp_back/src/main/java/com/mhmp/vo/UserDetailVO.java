package com.mhmp.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class UserDetailVO {

    private Long id;
    private String username;
    private String nickName;
    private String realName;
    private String phone;
    private String email;
    private String gender;
    private String avatarUrl;
    private String status;
    private String remark;
    private LocalDateTime lastLoginTime;
    private List<Long> roleIds;
}

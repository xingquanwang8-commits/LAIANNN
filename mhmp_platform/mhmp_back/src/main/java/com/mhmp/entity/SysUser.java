package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_user")
public class SysUser extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;
    private String username;
    private String password;
    @TableField("nick_name")
    private String nickName;
    @TableField("real_name")
    private String realName;
    private String phone;
    private String email;
    private String gender;
    @TableField("avatar_url")
    private String avatarUrl;
    private String status;
    @TableField("last_login_time")
    private LocalDateTime lastLoginTime;
    private String remark;
}

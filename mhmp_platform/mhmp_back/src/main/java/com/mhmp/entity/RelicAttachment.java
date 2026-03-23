package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("relic_attachment")
public class RelicAttachment extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("relic_id")
    private Long relicId;
    @TableField("attachment_type")
    private String attachmentType;
    @TableField("file_name")
    private String fileName;
    @TableField("file_url")
    private String fileUrl;
    @TableField("file_size")
    private Long fileSize;
    @TableField("file_suffix")
    private String fileSuffix;
    private String remark;
}

package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("relic")
public class Relic extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("relic_no")
    private String relicNo;
    private String name;
    @TableField("category_code")
    private String categoryCode;
    @TableField("material_code")
    private String materialCode;
    private String era;
    private String source;
    @TableField("storage_location_code")
    private String storageLocationCode;
    @TableField("preservation_status_code")
    private String preservationStatusCode;
    @TableField("current_status")
    private String currentStatus;
    @TableField("protection_level")
    private String protectionLevel;
    @TableField("storage_condition")
    private String storageCondition;
    @TableField("attention_note")
    private String attentionNote;
    private String description;
    private String note;
    @TableField("image_url")
    private String imageUrl;
    @TableField("appraisal_report_url")
    private String appraisalReportUrl;
}

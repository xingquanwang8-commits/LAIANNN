package com.mhmp.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_dict_item")
public class SysDictItem extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("dict_type_code")
    private String dictTypeCode;
    @TableField("item_label")
    private String itemLabel;
    @TableField("item_value")
    private String itemValue;
    @TableField("item_sort")
    private Integer itemSort;
    private String status;
    @TableField("css_class")
    private String cssClass;
    private String remark;
}

package com.mhmp.common.result;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageResponse<T> {

    private Long total;
    private Long pageNum;
    private Long pageSize;
    private List<T> records;

    public static <T> PageResponse<T> of(Page<?> page, List<T> records) {
        return new PageResponse<>(page.getTotal(), page.getCurrent(), page.getSize(), records);
    }
}

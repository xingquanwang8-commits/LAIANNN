package com.mhmp.controller;

import com.mhmp.common.result.R;
import com.mhmp.service.DictService;
import com.mhmp.vo.DictItemVO;
import com.mhmp.vo.DictTypeVO;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/dict")
public class DictController {

    private final DictService dictService;

    public DictController(DictService dictService) {
        this.dictService = dictService;
    }

    @GetMapping("/types")
    public R<List<DictTypeVO>> types() {
        return R.success(dictService.listTypes());
    }

    @GetMapping("/{dictTypeCode}/items")
    public R<List<DictItemVO>> items(@PathVariable String dictTypeCode) {
        return R.success(dictService.listItemsByType(dictTypeCode));
    }
}

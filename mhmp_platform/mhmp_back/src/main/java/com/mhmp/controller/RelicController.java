package com.mhmp.controller;

import com.mhmp.common.result.PageResponse;
import com.mhmp.common.result.Result;
import com.mhmp.dto.RelicPageQueryDTO;
import com.mhmp.dto.RelicSaveDTO;
import com.mhmp.service.RelicService;
import com.mhmp.vo.RelicAttachmentVO;
import com.mhmp.vo.RelicDetailVO;
import com.mhmp.vo.RelicListVO;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Validated
@RestController
@RequestMapping("/api/relic")
public class RelicController {

    private final RelicService relicService;

    public RelicController(RelicService relicService) {
        this.relicService = relicService;
    }

    @GetMapping("/page")
    @PreAuthorize("hasAnyAuthority('relic:list:view','relic:view')")
    public Result<PageResponse<RelicListVO>> page(@Valid RelicPageQueryDTO queryDTO) {
        return Result.success(relicService.page(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('relic:detail:view','relic:view','relic:list:view')")
    public Result<RelicDetailVO> detail(@PathVariable Long id) {
        return Result.success(relicService.detail(id));
    }

    @GetMapping("/{id}/attachments")
    @PreAuthorize("hasAnyAuthority('relic:detail:view','relic:view','relic:list:view')")
    public Result<List<RelicAttachmentVO>> attachments(@PathVariable Long id) {
        return Result.success(relicService.listAttachments(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('relic:add')")
    public Result<Long> create(@Valid @RequestBody RelicSaveDTO saveDTO) {
        return Result.success("新增成功", relicService.create(saveDTO));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('relic:edit')")
    public Result<Void> update(@PathVariable Long id, @Valid @RequestBody RelicSaveDTO saveDTO) {
        relicService.update(id, saveDTO);
        return Result.success();
    }
}

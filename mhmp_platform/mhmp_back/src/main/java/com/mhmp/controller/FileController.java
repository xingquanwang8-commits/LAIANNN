package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.R;
import com.mhmp.config.FileStorageProperties;
import com.mhmp.vo.FileUploadVO;
import org.springframework.http.MediaType;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.UUID;

@RestController
@RequestMapping("/api/files")
public class FileController {

    private static final DateTimeFormatter FOLDER_FORMATTER = DateTimeFormatter.ofPattern("yyyyMM");

    private final FileStorageProperties fileStorageProperties;

    public FileController(FileStorageProperties fileStorageProperties) {
        this.fileStorageProperties = fileStorageProperties;
    }

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @OperationLog(module = "File", businessType = "UPLOAD", description = "Upload business file")
    public R<FileUploadVO> upload(@RequestPart("file") MultipartFile file,
                                       @RequestParam(value = "bizType", required = false) String bizType) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException("Uploaded file cannot be empty");
        }

        String safeBizType = normalizeBizType(bizType);
        String originalFileName = StringUtils.cleanPath(file.getOriginalFilename() == null ? "file" : file.getOriginalFilename());
        String fileSuffix = StringUtils.getFilenameExtension(originalFileName);
        String storedFileName = UUID.randomUUID() + (StringUtils.hasText(fileSuffix) ? "." + fileSuffix.toLowerCase(Locale.ROOT) : "");
        String monthFolder = LocalDate.now().format(FOLDER_FORMATTER);

        Path basePath = Paths.get(fileStorageProperties.getBasePath()).toAbsolutePath().normalize();
        Path targetDirectory = basePath.resolve(safeBizType).resolve(monthFolder);
        Path targetFile = targetDirectory.resolve(storedFileName);
        try {
            Files.createDirectories(targetDirectory);
            Files.copy(file.getInputStream(), targetFile, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException ex) {
            throw new BusinessException("File upload failed");
        }

        FileUploadVO vo = new FileUploadVO();
        vo.setFileName(originalFileName);
        vo.setFileUrl(String.format("/uploads/%s/%s/%s", safeBizType, monthFolder, storedFileName));
        vo.setFileSize(file.getSize());
        vo.setFileSuffix(fileSuffix);
        return R.success(vo);
    }

    private String normalizeBizType(String bizType) {
        if (!StringUtils.hasText(bizType)) {
            return "common";
        }
        String normalized = bizType.replaceAll("[^a-zA-Z0-9_-]", "").toLowerCase(Locale.ROOT);
        return StringUtils.hasText(normalized) ? normalized : "common";
    }
}

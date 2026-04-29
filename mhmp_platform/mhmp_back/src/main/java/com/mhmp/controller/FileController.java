package com.mhmp.controller;

import com.mhmp.common.annotation.OperationLog;
import com.mhmp.common.exception.BusinessException;
import com.mhmp.common.result.R;
import com.mhmp.config.FileStorageProperties;
import com.mhmp.service.FilePreviewService;
import com.mhmp.vo.FilePreviewVO;
import com.mhmp.vo.FileUploadVO;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
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
    private final FilePreviewService filePreviewService;

    public FileController(FileStorageProperties fileStorageProperties,
                          FilePreviewService filePreviewService) {
        this.fileStorageProperties = fileStorageProperties;
        this.filePreviewService = filePreviewService;
    }

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @OperationLog(module = "文件管理", businessType = "UPLOAD", description = "上传业务文件")
    public R<FileUploadVO> upload(@RequestPart("file") MultipartFile file,
                                  @RequestParam(value = "bizType", required = false) String bizType) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException("上传文件不能为空");
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
            throw new BusinessException("文件上传失败");
        }

        FileUploadVO vo = new FileUploadVO();
        vo.setFileName(originalFileName);
        vo.setFileUrl(String.format("/uploads/%s/%s/%s", safeBizType, monthFolder, storedFileName));
        vo.setFileSize(file.getSize());
        vo.setFileSuffix(fileSuffix);
        return R.success(vo);
    }

    @GetMapping("/preview")
    public R<FilePreviewVO> preview(@RequestParam("fileUrl") String fileUrl) {
        return R.success(filePreviewService.preview(fileUrl));
    }

    @GetMapping("/source")
    public ResponseEntity<Resource> source(@RequestParam("fileUrl") String fileUrl,
                                           @RequestParam(value = "fileName", required = false) String fileName,
                                           @RequestParam(value = "download", defaultValue = "false") boolean download) {
        Path sourcePath = resolveUploadedPath(fileUrl);
        Resource resource = buildResource(sourcePath);
        String responseFileName = resolveResponseFileName(fileName, sourcePath);

        return ResponseEntity.ok()
            .contentType(resolveMediaType(sourcePath))
            .header(HttpHeaders.CONTENT_DISPOSITION, ContentDisposition
                .builder(download ? "attachment" : "inline")
                .filename(responseFileName, StandardCharsets.UTF_8)
                .build()
                .toString())
            .body(resource);
    }

    private String normalizeBizType(String bizType) {
        if (!StringUtils.hasText(bizType)) {
            return "common";
        }
        String normalized = bizType.replaceAll("[^a-zA-Z0-9_-]", "").toLowerCase(Locale.ROOT);
        return StringUtils.hasText(normalized) ? normalized : "common";
    }

    private Resource buildResource(Path sourcePath) {
        try {
            Resource resource = new UrlResource(sourcePath.toUri());
            if (!resource.exists() || !resource.isReadable()) {
                throw new BusinessException("文件不存在或已被删除");
            }
            return resource;
        } catch (IOException ex) {
            throw new BusinessException("文件读取失败");
        }
    }

    private MediaType resolveMediaType(Path sourcePath) {
        try {
            String contentType = Files.probeContentType(sourcePath);
            return StringUtils.hasText(contentType)
                ? MediaType.parseMediaType(contentType)
                : MediaType.APPLICATION_OCTET_STREAM;
        } catch (Exception ex) {
            return MediaType.APPLICATION_OCTET_STREAM;
        }
    }

    private String resolveResponseFileName(String fileName, Path sourcePath) {
        String suffix = StringUtils.getFilenameExtension(sourcePath.getFileName().toString());
        String safeFileName = StringUtils.hasText(fileName)
            ? fileName.trim().replaceAll("[\\\\/:*?\"<>|]", "_")
            : sourcePath.getFileName().toString();
        if (!StringUtils.hasText(suffix) || StringUtils.hasText(StringUtils.getFilenameExtension(safeFileName))) {
            return safeFileName;
        }
        return safeFileName + "." + suffix;
    }

    private Path resolveUploadedPath(String fileUrl) {
        String normalizedUrl = normalizeUploadedUrl(fileUrl);
        String subPath = normalizedUrl.substring("/uploads/".length());
        String decodedSubPath = URLDecoder.decode(subPath, StandardCharsets.UTF_8);

        Path basePath = Paths.get(fileStorageProperties.getBasePath()).toAbsolutePath().normalize();
        Path sourcePath = basePath.resolve(decodedSubPath).normalize();
        if (!sourcePath.startsWith(basePath)) {
            throw new BusinessException("文件地址不合法");
        }
        if (!Files.exists(sourcePath) || !Files.isRegularFile(sourcePath)) {
            throw new BusinessException("文件不存在或已被删除");
        }
        return sourcePath;
    }

    private String normalizeUploadedUrl(String fileUrl) {
        if (!StringUtils.hasText(fileUrl)) {
            throw new BusinessException("文件地址不能为空");
        }
        String trimmed = fileUrl.trim();
        try {
            URI uri = URI.create(trimmed);
            if (uri.isAbsolute()) {
                trimmed = uri.getRawPath();
            }
        } catch (IllegalArgumentException ignored) {
            int queryIndex = trimmed.indexOf('?');
            if (queryIndex >= 0) {
                trimmed = trimmed.substring(0, queryIndex);
            }
        }
        int hashIndex = trimmed.indexOf('#');
        if (hashIndex >= 0) {
            trimmed = trimmed.substring(0, hashIndex);
        }
        int queryIndex = trimmed.indexOf('?');
        if (queryIndex >= 0) {
            trimmed = trimmed.substring(0, queryIndex);
        }
        if (!trimmed.startsWith("/uploads/")) {
            throw new BusinessException("仅支持访问系统上传文件");
        }
        return trimmed;
    }
}

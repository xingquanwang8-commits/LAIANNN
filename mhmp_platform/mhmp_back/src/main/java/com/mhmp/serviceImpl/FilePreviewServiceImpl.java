package com.mhmp.serviceImpl;

import com.mhmp.common.exception.BusinessException;
import com.mhmp.config.FileStorageProperties;
import com.mhmp.service.FilePreviewService;
import com.mhmp.vo.FilePreviewVO;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;

@Service
public class FilePreviewServiceImpl implements FilePreviewService {

    private static final String UPLOAD_PREFIX = "/uploads/";
    private static final int MAX_PREVIEW_LENGTH = 30000;
    private static final Set<String> TEXT_SUFFIXES = Set.of("txt", "log", "md", "json", "xml", "csv");

    private final FileStorageProperties fileStorageProperties;

    public FilePreviewServiceImpl(FileStorageProperties fileStorageProperties) {
        this.fileStorageProperties = fileStorageProperties;
    }

    @Override
    public FilePreviewVO preview(String fileUrl) {
        Path filePath = resolveFilePath(fileUrl);
        if (!Files.exists(filePath) || Files.isDirectory(filePath)) {
            throw new BusinessException("预览文件不存在或已被删除");
        }

        String fileSuffix = normalizeSuffix(StringUtils.getFilenameExtension(filePath.getFileName().toString()));
        FilePreviewVO vo = new FilePreviewVO();
        vo.setFileSuffix(fileSuffix);

        if ("pdf".equals(fileSuffix)) {
            vo.setPreviewType("PDF");
            vo.setPreviewable(true);
            vo.setMessage("PDF 文件支持直接在线预览。");
            return vo;
        }

        if ("docx".equals(fileSuffix)) {
            return buildTextPreview(vo, "WORD", extractDocxText(filePath), "当前显示为 Word 文本预览，排版请以下载原件为准。");
        }

        if ("doc".equals(fileSuffix)) {
            return buildTextPreview(vo, "WORD", extractDocText(filePath), "当前显示为 Word 文本预览，排版请以下载原件为准。");
        }

        if (TEXT_SUFFIXES.contains(fileSuffix)) {
            return buildTextPreview(vo, "TEXT", extractTextFile(filePath), "当前显示为文本文件预览。");
        }

        vo.setPreviewType("UNSUPPORTED");
        vo.setPreviewable(false);
        vo.setMessage("当前文件类型暂不支持在线预览，请下载原件查看。");
        return vo;
    }

    private FilePreviewVO buildTextPreview(FilePreviewVO vo,
                                           String previewType,
                                           String content,
                                           String message) {
        vo.setPreviewType(previewType);
        vo.setPreviewable(true);
        vo.setContent(normalizePreviewContent(content));
        vo.setMessage(message);
        return vo;
    }

    private Path resolveFilePath(String fileUrl) {
        if (!StringUtils.hasText(fileUrl)) {
            throw new BusinessException("预览文件地址不能为空");
        }
        String normalizedUrl = fileUrl.trim().replace("\\", "/");
        if (!normalizedUrl.startsWith(UPLOAD_PREFIX)) {
            throw new BusinessException("仅支持预览系统上传文件");
        }

        Path basePath = Paths.get(fileStorageProperties.getBasePath()).toAbsolutePath().normalize();
        String relativePath = normalizedUrl.substring(UPLOAD_PREFIX.length());
        Path resolvedPath = basePath.resolve(relativePath).normalize();
        if (!resolvedPath.startsWith(basePath)) {
            throw new BusinessException("预览文件路径非法");
        }
        return resolvedPath;
    }

    private String extractDocxText(Path filePath) {
        try (InputStream inputStream = Files.newInputStream(filePath);
             XWPFDocument document = new XWPFDocument(inputStream);
             XWPFWordExtractor extractor = new XWPFWordExtractor(document)) {
            return extractor.getText();
        } catch (Exception ex) {
            throw new BusinessException("Word 文档预览失败，请下载原件查看");
        }
    }

    private String extractDocText(Path filePath) {
        try (InputStream inputStream = Files.newInputStream(filePath);
             POIFSFileSystem fileSystem = new POIFSFileSystem(inputStream);
             HWPFDocument document = new HWPFDocument(fileSystem);
             WordExtractor extractor = new WordExtractor(document)) {
            return extractor.getText();
        } catch (Exception ex) {
            throw new BusinessException("Word 文档预览失败，请下载原件查看");
        }
    }

    private String extractTextFile(Path filePath) {
        try {
            return Files.readString(filePath, StandardCharsets.UTF_8);
        } catch (IOException ex) {
            throw new BusinessException("文本文件预览失败，请下载原件查看");
        }
    }

    private String normalizePreviewContent(String content) {
        if (!StringUtils.hasText(content)) {
            return "";
        }
        String normalized = content
            .replace("\u0000", "")
            .replace("\r\n", "\n")
            .replace('\r', '\n')
            .replaceAll("\\n{3,}", "\n\n")
            .trim();
        if (normalized.length() <= MAX_PREVIEW_LENGTH) {
            return normalized;
        }
        return normalized.substring(0, MAX_PREVIEW_LENGTH) + "\n\n[预览内容已截断，请下载原件查看完整文档]";
    }

    private String normalizeSuffix(String suffix) {
        return StringUtils.hasText(suffix) ? suffix.trim().toLowerCase(Locale.ROOT) : "";
    }
}

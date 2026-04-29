package com.mhmp.serviceImpl;

import com.mhmp.common.exception.BusinessException;
import com.mhmp.config.FileStorageProperties;
import com.mhmp.service.FilePreviewService;
import com.mhmp.vo.FilePreviewVO;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;

@Service
public class FilePreviewServiceImpl implements FilePreviewService {

    private static final int MAX_PREVIEW_LENGTH = 200_000;
    private static final Set<String> TEXT_SUFFIXES = Set.of("txt", "log", "md", "json", "xml", "csv");

    private final FileStorageProperties fileStorageProperties;

    public FilePreviewServiceImpl(FileStorageProperties fileStorageProperties) {
        this.fileStorageProperties = fileStorageProperties;
    }

    @Override
    public FilePreviewVO preview(String fileUrl) {
        Path filePath = resolveUploadedPath(fileUrl);
        String suffix = resolveSuffix(filePath);

        FilePreviewVO vo = new FilePreviewVO();
        vo.setFileName(filePath.getFileName().toString());
        vo.setFileUrl(normalizeUploadedUrl(fileUrl));
        vo.setFileSuffix(suffix);

        if (!isTextPreviewSupported(suffix)) {
            vo.setPreviewType("UNSUPPORTED");
            vo.setMessage("当前文件类型暂不支持文本预览，请下载源文件查看");
            return vo;
        }

        try {
            vo.setPreviewType("TEXT");
            vo.setContent(limitPreviewContent(extractText(filePath, suffix)));
            return vo;
        } catch (Exception ex) {
            throw new BusinessException("文件预览失败，请下载源文件查看");
        }
    }

    private boolean isTextPreviewSupported(String suffix) {
        return TEXT_SUFFIXES.contains(suffix)
            || "doc".equals(suffix)
            || "docx".equals(suffix)
            || "xls".equals(suffix)
            || "xlsx".equals(suffix);
    }

    private String extractText(Path filePath, String suffix) throws IOException {
        return switch (suffix) {
            case "doc" -> extractDoc(filePath);
            case "docx" -> extractDocx(filePath);
            case "xls" -> extractWorkbook(filePath, false);
            case "xlsx" -> extractWorkbook(filePath, true);
            default -> readTextFile(filePath);
        };
    }

    private String extractDoc(Path filePath) throws IOException {
        try (InputStream inputStream = Files.newInputStream(filePath);
             WordExtractor extractor = new WordExtractor(inputStream)) {
            return extractor.getText();
        }
    }

    private String extractDocx(Path filePath) throws IOException {
        try (InputStream inputStream = Files.newInputStream(filePath);
             XWPFDocument document = new XWPFDocument(inputStream);
             XWPFWordExtractor extractor = new XWPFWordExtractor(document)) {
            return extractor.getText();
        }
    }

    private String extractWorkbook(Path filePath, boolean xlsx) throws IOException {
        try (InputStream inputStream = Files.newInputStream(filePath);
             Workbook workbook = xlsx ? new XSSFWorkbook(inputStream) : new HSSFWorkbook(inputStream)) {
            StringBuilder builder = new StringBuilder();
            DataFormatter formatter = new DataFormatter(Locale.CHINA);
            for (int sheetIndex = 0; sheetIndex < workbook.getNumberOfSheets(); sheetIndex++) {
                Sheet sheet = workbook.getSheetAt(sheetIndex);
                if (sheet == null) {
                    continue;
                }
                if (!builder.isEmpty()) {
                    builder.append(System.lineSeparator()).append(System.lineSeparator());
                }
                builder.append("【工作表】").append(sheet.getSheetName()).append(System.lineSeparator());
                appendSheetRows(builder, formatter, sheet);
            }
            return builder.toString();
        }
    }

    private void appendSheetRows(StringBuilder builder, DataFormatter formatter, Sheet sheet) {
        for (Row row : sheet) {
            short firstCell = row.getFirstCellNum();
            short lastCell = row.getLastCellNum();
            if (firstCell < 0 || lastCell < 0) {
                continue;
            }

            StringBuilder rowBuilder = new StringBuilder();
            for (int cellIndex = firstCell; cellIndex < lastCell; cellIndex++) {
                Cell cell = row.getCell(cellIndex);
                String cellValue = cell == null ? "" : formatter.formatCellValue(cell).trim();
                if (cellIndex > firstCell) {
                    rowBuilder.append('\t');
                }
                rowBuilder.append(cellValue);
            }
            if (!rowBuilder.toString().trim().isEmpty()) {
                builder.append(rowBuilder).append(System.lineSeparator());
            }
        }
    }

    private String readTextFile(Path filePath) throws IOException {
        byte[] bytes = Files.readAllBytes(filePath);
        try {
            return StandardCharsets.UTF_8.newDecoder().decode(java.nio.ByteBuffer.wrap(bytes)).toString();
        } catch (CharacterCodingException ex) {
            return Charset.forName("GBK").decode(java.nio.ByteBuffer.wrap(bytes)).toString();
        }
    }

    private String limitPreviewContent(String content) {
        if (!StringUtils.hasText(content)) {
            return "未提取到可预览文本内容。";
        }
        if (content.length() <= MAX_PREVIEW_LENGTH) {
            return content;
        }
        return content.substring(0, MAX_PREVIEW_LENGTH)
            + System.lineSeparator()
            + System.lineSeparator()
            + "【内容较长，仅展示前 " + MAX_PREVIEW_LENGTH + " 个字符，请下载源文件查看完整内容】";
    }

    private Path resolveUploadedPath(String fileUrl) {
        String normalizedUrl = normalizeUploadedUrl(fileUrl);
        String subPath = normalizedUrl.substring("/uploads/".length());
        String decodedSubPath = URLDecoder.decode(subPath, StandardCharsets.UTF_8);

        Path basePath = Paths.get(fileStorageProperties.getBasePath()).toAbsolutePath().normalize();
        Path targetPath = basePath.resolve(decodedSubPath).normalize();
        if (!targetPath.startsWith(basePath)) {
            throw new BusinessException("文件地址不合法");
        }
        if (!Files.exists(targetPath) || !Files.isRegularFile(targetPath)) {
            throw new BusinessException("文件不存在或已被删除");
        }
        return targetPath;
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
            throw new BusinessException("仅支持预览系统上传文件");
        }
        return trimmed;
    }

    private String resolveSuffix(Path filePath) {
        String fileName = filePath.getFileName().toString();
        String extension = StringUtils.getFilenameExtension(fileName);
        return extension == null ? "" : extension.toLowerCase(Locale.ROOT);
    }
}

package com.mhmp.serviceImpl;

import com.mhmp.config.FileStorageProperties;
import com.mhmp.vo.FilePreviewVO;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class FilePreviewServiceImplTest {

    @TempDir
    Path tempDir;

    private FilePreviewServiceImpl filePreviewService;

    @BeforeEach
    void setUp() {
        FileStorageProperties fileStorageProperties = new FileStorageProperties();
        fileStorageProperties.setBasePath(tempDir.toString());
        filePreviewService = new FilePreviewServiceImpl(fileStorageProperties);
    }

    @Test
    void previewShouldReturnPdfModeForPdfFile() throws Exception {
        Path pdfFile = createFile("preview/sample.pdf", "%PDF-1.4 demo".getBytes(StandardCharsets.UTF_8));

        FilePreviewVO preview = filePreviewService.preview(toFileUrl(pdfFile));

        assertEquals("PDF", preview.getPreviewType());
        assertTrue(Boolean.TRUE.equals(preview.getPreviewable()));
    }

    @Test
    void previewShouldExtractDocxText() throws Exception {
        Path docxFile = tempDir.resolve("preview/sample.docx");
        Files.createDirectories(docxFile.getParent());
        try (XWPFDocument document = new XWPFDocument();
             OutputStream outputStream = Files.newOutputStream(docxFile)) {
            document.createParagraph().createRun().setText("文物修复记录");
            document.write(outputStream);
        }

        FilePreviewVO preview = filePreviewService.preview(toFileUrl(docxFile));

        assertEquals("WORD", preview.getPreviewType());
        assertTrue(Boolean.TRUE.equals(preview.getPreviewable()));
        assertTrue(preview.getContent().contains("文物修复记录"));
    }

    @Test
    void previewShouldReadTextFile() throws Exception {
        Path textFile = createFile("preview/sample.txt", "答辩演示附件".getBytes(StandardCharsets.UTF_8));

        FilePreviewVO preview = filePreviewService.preview(toFileUrl(textFile));

        assertEquals("TEXT", preview.getPreviewType());
        assertTrue(Boolean.TRUE.equals(preview.getPreviewable()));
        assertTrue(preview.getContent().contains("答辩演示附件"));
    }

    private Path createFile(String relativePath, byte[] content) throws Exception {
        Path file = tempDir.resolve(relativePath);
        Files.createDirectories(file.getParent());
        Files.write(file, content);
        return file;
    }

    private String toFileUrl(Path file) {
        Path relativePath = tempDir.relativize(file);
        return "/uploads/" + relativePath.toString().replace("\\", "/");
    }
}

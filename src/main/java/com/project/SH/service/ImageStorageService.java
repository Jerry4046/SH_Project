package com.project.SH.service;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class ImageStorageService {

    private static final Logger log = LoggerFactory.getLogger(ImageStorageService.class);

    @Value("${app.media.base-directory}")
    private String mediaBaseDirectory;

    @Value("${app.media.url-prefix:/media}")
    private String mediaUrlPrefix;

    @PostConstruct
    void ensureBaseDirectory() throws IOException {
        Path basePath = getBasePath();
        if (Files.notExists(basePath)) {
            Files.createDirectories(basePath);
        }
    }

    public void ensureProductFolderExists(String productName) throws IOException {
        String normalizedFolder = normalizeFolder(productName);
        Path targetDirectory = getBasePath().resolve(normalizedFolder);
        Files.createDirectories(targetDirectory);
    }

    public String storeAsWebp(MultipartFile file, String productName) throws IOException {
        String normalizedFolder = normalizeFolder(productName);
        if (file.isEmpty()) {
            throw new IllegalArgumentException("비어 있는 파일은 업로드할 수 없습니다.");
        }

        ensureProductFolderExists(productName);
        String outputFileName = buildProductFileName(productName);
        Path targetDirectory = getBasePath().resolve(normalizedFolder);
        Path targetFile = targetDirectory.resolve(outputFileName);

        BufferedImage image = readImage(file);
        boolean attemptedWebp = false;
        boolean storedAsWebp = false;

        if (image != null) {
            attemptedWebp = true;
            try {
                storedAsWebp = writeWebp(image, targetFile);
            } catch (IOException ex) {
                log.warn("WebP 변환에 실패하여 원본 파일을 저장합니다. (target: {})", targetFile, ex);
            }
        } else if (!isLikelyImage(file)) {
            throw new IllegalArgumentException("이미지 파일만 업로드할 수 있습니다.");
        }

        if (!storedAsWebp) {
            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, targetFile, StandardCopyOption.REPLACE_EXISTING);
            }
            if (attemptedWebp) {
                log.info("원본 이미지를 그대로 저장했습니다. (target: {})", targetFile);
            } else {
                log.info("이미지 판독이 불가능했지만 원본 파일을 그대로 저장했습니다. (target: {})", targetFile);
            }
        }

        return buildPublicUrl(normalizedFolder, outputFileName);
    }

    public Optional<String> findLatestImageUrlByProductName(String productName) {
        if (!StringUtils.hasText(productName)) {
            return Optional.empty();
        }
        String normalizedFolder;
        try {
            normalizedFolder = normalizeFolder(productName);
        } catch (IllegalArgumentException ex) {
            return Optional.empty();
        }
        Path targetDirectory = getBasePath().resolve(normalizedFolder);
        if (Files.notExists(targetDirectory) || !Files.isDirectory(targetDirectory)) {
            return Optional.empty();
        }

        Path expectedFile = targetDirectory.resolve(buildProductFileName(productName));
        if (Files.exists(expectedFile) && Files.isRegularFile(expectedFile)) {
            return Optional.of(buildPublicUrl(normalizedFolder, expectedFile.getFileName().toString()));
        }

        try (Stream<Path> fileStream = Files.list(targetDirectory)) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .sorted((a, b) -> {
                        try {
                            return Files.getLastModifiedTime(b).compareTo(Files.getLastModifiedTime(a));
                        } catch (IOException e) {
                            return 0;
                        }
                    })
                    .map(path -> buildPublicUrl(normalizedFolder, path.getFileName().toString()))
                    .findFirst();
        } catch (IOException e) {
            return Optional.empty();
        }
    }

    public Map<String, List<String>> findAllImages() throws IOException {
        Path basePath = getBasePath();
        if (Files.notExists(basePath)) {
            return Map.of();
        }

        Map<String, List<String>> result = new HashMap<>();
        try (Stream<Path> folderStream = Files.list(basePath)) {
            folderStream.filter(Files::isDirectory)
                    .sorted(Comparator.comparing(Path::getFileName))
                    .forEach(folderPath -> {
                        String folderName = folderPath.getFileName().toString();
                        List<String> images = listImagesInFolder(folderPath, folderName);
                        if (!images.isEmpty()) {
                            result.put(folderName, images);
                        }
                    });
        }

        return result;
    }

    private List<String> listImagesInFolder(Path folderPath, String folderName) {
        try (Stream<Path> fileStream = Files.list(folderPath)) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .sorted(Comparator.comparing(Path::getFileName))
                    .map(path -> buildPublicUrl(folderName, path.getFileName().toString()))
                    .collect(Collectors.toCollection(ArrayList::new));
        } catch (IOException e) {
            return List.of();
        }
    }

    private Path getBasePath() {
        return Paths.get(mediaBaseDirectory).toAbsolutePath().normalize();
    }

    private String normalizeFolder(String folder) {
        String sanitized = sanitizeName(folder);
        if (!StringUtils.hasText(sanitized)) {
            throw new IllegalArgumentException("폴더 이름은 필수 값입니다.");
        }
        return sanitized;
    }

    private String buildProductFileName(String productName) {
        String baseName = sanitizeName(productName);
        if (!StringUtils.hasText(baseName)) {
            baseName = "product";
        }
        return baseName + ".webp";
    }

    private String sanitizeName(String input) {
        if (!StringUtils.hasText(input)) {
            return null;
        }
        String trimmed = input.trim();
        String withoutSeparators = trimmed.replaceAll("[\\\\/:*?\"<>|]+", "");
        String normalizedWhitespace = withoutSeparators.replaceAll("\\s+", "_");
        String sanitized = normalizedWhitespace.replaceAll("[^\\p{L}0-9._-]", "-");
        sanitized = sanitized.replaceAll("-+", "-");
        sanitized = sanitized.replaceAll("_+", "_");
        sanitized = sanitized.replaceAll("^[-_]+", "");
        sanitized = sanitized.replaceAll("[-_]+$", "");
        return sanitized;
    }

    private boolean writeWebp(BufferedImage image, Path targetFile) throws IOException {
        var writers = ImageIO.getImageWritersByMIMEType("image/webp");
        if (!writers.hasNext()) {
            log.warn("WebP 인코더를 찾을 수 없습니다. 원본 파일을 그대로 저장합니다. (target: {})", targetFile);
            return false;
        }
        ImageWriter writer = writers.next();

        try (ImageOutputStream outputStream = ImageIO.createImageOutputStream(Files.newOutputStream(targetFile))) {
            writer.setOutput(outputStream);
            ImageWriteParam writeParam = writer.getDefaultWriteParam();
            writer.write(null, new IIOImage(image, null, null), writeParam);
            return true;
        } finally {
            writer.dispose();
        }
    }

    private BufferedImage readImage(MultipartFile file) throws IOException {
        try (InputStream inputStream = file.getInputStream()) {
            return ImageIO.read(inputStream);
        }
    }

    private boolean isLikelyImage(MultipartFile file) {
        String contentType = file.getContentType();
        return contentType != null && contentType.toLowerCase(Locale.ROOT).startsWith("image/");
    }

    private String buildPublicUrl(String folder, String filename) {
        String cleanedPrefix = mediaUrlPrefix.endsWith("/")
                ? mediaUrlPrefix.substring(0, mediaUrlPrefix.length() - 1)
                : mediaUrlPrefix;
        return cleanedPrefix + "/" + folder + "/" + filename;
    }
}
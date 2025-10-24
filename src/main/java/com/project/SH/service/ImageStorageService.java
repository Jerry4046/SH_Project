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
import java.util.Objects;
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
        String baseFileName = resolveBaseName(productName);
        String outputFileName = baseFileName + ".webp";
        Path targetDirectory = getBasePath().resolve(normalizedFolder);
        Path targetFile = targetDirectory.resolve(outputFileName);
        rotateExistingProductImages(targetDirectory, baseFileName);

        BufferedImage image = readImage(file);
        boolean storedAsWebp = false;

        if (image != null) {
            storedAsWebp = writeWebp(image, targetFile);
        } else if (!isLikelyImage(file)) {
            throw new IllegalArgumentException("이미지 파일만 업로드할 수 있습니다.");
        }

        if (!storedAsWebp) {
            if (isWebpFile(file)) {
                try (InputStream inputStream = file.getInputStream()) {
                    Files.copy(inputStream, targetFile, StandardCopyOption.REPLACE_EXISTING);
                }
            } else {
                throw new IllegalStateException("이미지 파일을 WebP로 변환할 수 없습니다.");
            }
        }

        return buildPublicUrl(normalizedFolder, targetFile.getFileName().toString());
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

        String baseFileName = resolveBaseName(productName);
        Path expectedFile = targetDirectory.resolve(baseFileName + ".webp");
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


    private Path getBasePath() {
        return Paths.get(mediaBaseDirectory).toAbsolutePath().normalize();
    }

    private String buildProductFileName(String productName) {
        return resolveBaseName(productName) + ".webp";
    }

    private String normalizeFolder(String folder) {
        String sanitized = sanitizeName(folder);
        if (!StringUtils.hasText(sanitized)) {
            throw new IllegalArgumentException("폴더 이름은 필수 값입니다.");
        }
        return sanitized;
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

    private String resolveBaseName(String productName) {
        String baseName = sanitizeName(productName);
        if (!StringUtils.hasText(baseName)) {
            return "product";
        }
        return baseName;
    }

    private void rotateExistingProductImages(Path directory, String baseName) throws IOException {
        if (Files.notExists(directory) || !Files.isDirectory(directory)) {
            return;
        }

        try (Stream<Path> fileStream = Files.list(directory)) {
            List<ImageVariant> variants = fileStream
                    .filter(Files::isRegularFile)
                    .map(path -> toVariant(path, baseName))
                    .filter(Objects::nonNull)
                    .sorted(Comparator.comparingInt(ImageVariant::index).reversed())
                    .collect(Collectors.toList());

            for (ImageVariant variant : variants) {
                int nextIndex = variant.index + 1;
                String targetFileName = buildIndexedFileName(baseName, nextIndex);
                Path targetPath = directory.resolve(targetFileName);
                Files.move(variant.path, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }
        }
    }

    private ImageVariant toVariant(Path path, String baseName) {
        String filename = path.getFileName().toString();
        if (!filename.toLowerCase(Locale.ROOT).endsWith(".webp")) {
            return null;
        }

        String withoutExtension = filename.substring(0, filename.length() - 5);
        if (withoutExtension.equals(baseName)) {
            return new ImageVariant(path, 0);
        }

        String prefix = baseName + "_";
        if (withoutExtension.startsWith(prefix)) {
            String suffix = withoutExtension.substring(prefix.length());
            try {
                int index = Integer.parseInt(suffix);
                return new ImageVariant(path, index);
            } catch (NumberFormatException ignored) {
                return null;
            }
        }

        return null;
    }

    private String buildIndexedFileName(String baseName, int index) {
        return baseName + "_" + index + ".webp";
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

    private boolean isWebpFile(MultipartFile file) {
        String contentType = file.getContentType();
        if (contentType != null && contentType.equalsIgnoreCase("image/webp")) {
            return true;
        }
        String originalFilename = file.getOriginalFilename();
        return originalFilename != null && originalFilename.toLowerCase(Locale.ROOT).endsWith(".webp");
    }

    private String buildPublicUrl(String folder, String filename) {
        String cleanedPrefix = mediaUrlPrefix.endsWith("/")
                ? mediaUrlPrefix.substring(0, mediaUrlPrefix.length() - 1)
                : mediaUrlPrefix;
        return cleanedPrefix + "/" + folder + "/" + filename;
    }

    private record ImageVariant(Path path, int index) {}
}
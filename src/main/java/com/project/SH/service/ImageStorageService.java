package com.project.SH.service;

import jakarta.annotation.PostConstruct;
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
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class ImageStorageService {

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

        BufferedImage image = readImage(file);
        if (image == null) {
            throw new IllegalArgumentException("이미지 파일만 업로드할 수 있습니다.");
        }

        ensureProductFolderExists(productName);
        String outputFileName = buildProductFileName(productName);
        Path targetDirectory = getBasePath().resolve(normalizedFolder);
        Path targetFile = targetDirectory.resolve(outputFileName);

        writeWebp(image, targetFile);

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

    private void writeWebp(BufferedImage image, Path targetFile) throws IOException {
        var writers = ImageIO.getImageWritersByMIMEType("image/webp");
        if (!writers.hasNext()) {
            throw new IOException("WebP 인코더를 찾을 수 없습니다.");
        }
        ImageWriter writer = writers.next();

        try (ImageOutputStream outputStream = ImageIO.createImageOutputStream(Files.newOutputStream(targetFile))) {
            writer.setOutput(outputStream);
            ImageWriteParam writeParam = writer.getDefaultWriteParam();
            writer.write(null, new IIOImage(image, null, null), writeParam);
        } finally {
            writer.dispose();
        }
    }

    private BufferedImage readImage(MultipartFile file) throws IOException {
        try (InputStream inputStream = file.getInputStream()) {
            return ImageIO.read(inputStream);
        }
    }

    private String buildPublicUrl(String folder, String filename) {
        String cleanedPrefix = mediaUrlPrefix.endsWith("/")
                ? mediaUrlPrefix.substring(0, mediaUrlPrefix.length() - 1)
                : mediaUrlPrefix;
        return cleanedPrefix + "/" + folder + "/" + filename;
    }
}
package com.project.SH.service;

import com.project.SH.domain.Product;
import com.project.SH.domain.ProductChangeHistory;
import com.project.SH.domain.Stock;
import com.project.SH.domain.StockHistory;
import com.project.SH.repository.ProductRepository;
import com.project.SH.repository.StockHistoryRepository;
import com.project.SH.repository.StockRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.project.SH.repository.ProductChangeHistoryRepository;

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
import java.nio.file.StandardOpenOption;
import java.util.Iterator;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductService implements ProductServiceImpl {

    private final ProductRepository productRepository;
    private final PriceService priceService;
    private final ProductCodeService productCodeService;
    private final StockRepository stockRepository;
    private final StockHistoryRepository stockHistoryRepository;
    private final ProductChangeHistoryRepository productChangeHistoryRepository;


    @Transactional
    public void registerProduct(Product product, Double price, Integer piecesPerBox, Integer shQty, Integer hpQty,
                                Long accountSeq, MultipartFile productImage) {
        final String baseProductCode = requireProductCode(product.getProductCode());
        final String nextSequence = productCodeService.getNextItemCodeForBase(baseProductCode);
        final String fullProductCode = productCodeService.buildFullProductCode(baseProductCode, nextSequence);

        final String externalItemCode = normalizeItemCode(product.getItemCode());
        product.setItemCode(externalItemCode);

        if (productRepository.existsByAccountSeqAndProductCode(accountSeq, fullProductCode)) {
            log.error("상품 등록 실패 - 중복된 전체 코드: {}", fullProductCode);
            throw new IllegalStateException("Duplicate product code: " + fullProductCode);
        }

        product.setProductCode(fullProductCode);
        log.info("상품 등록 서비스 호출, 기본 코드: {}, 생성된 전체 코드: {}", baseProductCode, fullProductCode);

        Path imageDirectory = createImageDirectoryIfNecessary(product.getPdName());

        if (piecesPerBox == null || piecesPerBox < 1) piecesPerBox = 1;
        int safeShQty = resolveWarehouseQuantity(shQty, 0);
        int safeHpQty = resolveWarehouseQuantity(hpQty, 0);
        if (product.getMinStockQuantity() == null) product.setMinStockQuantity(0);

        // 상품 정보 저장
        product.setPiecesPerBox(piecesPerBox);
        productRepository.save(product);
        log.info("상품 기본 정보 저장 완료, 상품 코드: {}", product.getFullProductCode());

        // 재고 정보 저장
        Stock stock = Stock.builder()
                .product(product)
                .build();
        stock.updateWarehouseQuantities(safeShQty, safeHpQty);
        stockRepository.save(stock);
        log.info("상품 코드: {}에 재고 등록 완료", product.getFullProductCode());

        // 재고 변동 기록 저장
        int totalQty = stock.getTotalQty();
        StockHistory history = StockHistory.builder()
                .product_id(product)
                .account_seq(accountSeq)
                .action("IN")
                .old_sh_qty(0)
                .new_sh_qty(stock.getShQty())
                .old_hp_qty(0)
                .new_hp_qty(stock.getHpQty())
                .old_total_qty(0)
                .change_qty(totalQty)
                .new_total_qty(totalQty)
                .reason("초기등록")
                .build();
        stockHistoryRepository.save(history);
        log.info("상품 코드: {}의 초기 재고 이력 저장", product.getFullProductCode());

        // 가격 등록
        priceService.registerPrice(product, price, accountSeq);
        log.info("상품 코드: {}에 가격 등록 완료", product.getFullProductCode());
        storeProductImage(product.getPdName(), productImage, imageDirectory);
    }

    private Path createImageDirectoryIfNecessary(String productName) {
        if (productName == null || productName.isBlank()) {
            log.warn("상품 이미지 디렉터리 생성 건너뜀 - 상품명이 비어있음");
            return null;
        }

        String sanitizedName = sanitizeDirectoryName(productName);
        if (sanitizedName.isEmpty()) {
            log.warn("상품 이미지 디렉터리 생성 건너뜀 - 상품명에 사용 가능한 문자가 없음: {}", productName);
            return null;
        }

        try {
            Path imagesDir = Paths.get("src", "main", "resources", "static", "images");
            Path productDir = imagesDir.resolve(sanitizedName);
            Files.createDirectories(productDir);
            log.info("상품 이미지 디렉터리 확인 완료: {}", productDir.toAbsolutePath());
            return productDir;
        } catch (Exception e) {
            log.error("상품 이미지 디렉터리 생성 실패 - 상품명: {}, 에러: {}", productName, e.getMessage());
            throw new IllegalStateException("Failed to prepare image directory for product: " + productName, e);
        }
    }

    private void storeProductImage(String productName, MultipartFile productImage, Path preparedDirectory) {
        if (productImage == null || productImage.isEmpty()) {
            return;
        }

        if (productName == null || productName.isBlank()) {
            log.warn("상품 이미지 저장 건너뜀 - 상품명이 비어있음");
            return;
        }

        String sanitizedName = sanitizeDirectoryName(productName);
        if (sanitizedName.isEmpty()) {
            log.warn("상품 이미지 저장 건너뜀 - 상품명에 사용 가능한 문자가 없음: {}", productName);
            return;
        }

        Path targetDirectory = preparedDirectory != null ? preparedDirectory : createImageDirectoryIfNecessary(productName);
        if (targetDirectory == null) {
            log.warn("상품 이미지 저장 건너뜀 - 유효한 디렉터리를 준비하지 못함: {}", productName);
            return;
        }

        Path targetFile = targetDirectory.resolve(sanitizedName + ".webp");
        String extension = getFileExtension(productImage.getOriginalFilename());

        try {
            if ("webp".equalsIgnoreCase(extension)) {
                try (InputStream inputStream = productImage.getInputStream()) {
                    Files.copy(inputStream, targetFile, StandardCopyOption.REPLACE_EXISTING);
                }
                log.info("상품 이미지 저장 완료(WebP 그대로): {}", targetFile.toAbsolutePath());
                return;
            }

            convertToWebp(productImage, targetFile);
            log.info("상품 이미지 저장 완료(WebP 변환): {}", targetFile.toAbsolutePath());
        } catch (IOException e) {
            log.error("상품 이미지 저장 실패 - 상품명: {}, 에러: {}", productName, e.getMessage(), e);
            throw new IllegalStateException("Failed to store product image for product: " + productName, e);
        }
    }

    private void convertToWebp(MultipartFile productImage, Path targetFile) throws IOException {
        ImageIO.scanForPlugins();
        BufferedImage bufferedImage;
        try (InputStream inputStream = productImage.getInputStream()) {
            bufferedImage = ImageIO.read(inputStream);
        }

        if (bufferedImage == null) {
            throw new IllegalArgumentException("Unsupported image format for conversion to webp");
        }

        Iterator<ImageWriter> writers = ImageIO.getImageWritersByMIMEType("image/webp");
        if (!writers.hasNext()) {
            throw new IllegalStateException("No WebP writers available");
        }

        ImageWriter writer = writers.next();
        try (ImageOutputStream outputStream = ImageIO.createImageOutputStream(Files.newOutputStream(targetFile,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING))) {
            writer.setOutput(outputStream);
            ImageWriteParam writeParam = writer.getDefaultWriteParam();
            writer.write(null, new IIOImage(bufferedImage, null, null), writeParam);
        } finally {
            writer.dispose();
        }
    }

    private String getFileExtension(String filename) {
        if (filename == null) {
            return "";
        }
        int lastDot = filename.lastIndexOf('.');
        if (lastDot < 0 || lastDot == filename.length() - 1) {
            return "";
        }
        return filename.substring(lastDot + 1);
    }

    private String sanitizeDirectoryName(String name) {
        String trimmed = name.trim();
        String replacedWhitespace = trimmed.replaceAll("\\s+", "_");
        return replacedWhitespace.replaceAll("[^\\p{L}0-9._-]", "");
    }

    public List<Product> getAllProducts() {
        log.info("상품 목록 조회 서비스 호출");

        // 상품과 해당 가격 목록을 함께 조회
        List<Product> products = productRepository.findAllWithPricesAndStock();

        log.info("상품 목록 조회 서비스 완료, 상품 수: {}", products.size());
        return products;
    }

    public Product getProductByCode(String productCode, String itemCode) {
        final String normalizedProductCode = requireProductCode(productCode);
        Product product = productRepository.findByProductCodeWithStock(normalizedProductCode);
        if (product != null) {
            log.info("단일 상품 조회, 상품 코드: {}", product.getProductCode());
            return product;
        }

        final String candidateItemCode = normalizeItemCode(itemCode);
        if (candidateItemCode == null) {
            log.warn("상품 조회 실패 - 일치하는 상품이 없습니다. 요청 기본 코드: {}", normalizedProductCode);
            return null;
        }

        final String legacyFullCode = productCodeService.buildFullProductCode(normalizedProductCode, candidateItemCode);
        log.info("단일 상품 조회(레거시 포맷), 상품 코드: {}", legacyFullCode);
        return productRepository.findByProductCodeAndItemCodeWithStock(normalizedProductCode, candidateItemCode);
    }
    public List<Product> searchProducts(String keyword) {
        log.info("상품 검색, 키워드: {}", keyword);
        return productRepository.searchAllByKeyword(keyword);
    }

    @Transactional
    public void updateProduct(String originalProductCode, String originalItemCode, Product updatedProduct,
                              Integer piecesPerBox, Integer shQty, Integer hpQty, Double price,
                              Long accountSeq, String reason, boolean isAdmin) {
        final String normalizedProductCode = requireProductCode(originalProductCode);
        final boolean productCodeIncludesSequence = hasSequenceSuffix(normalizedProductCode);
        final String normalizedItemCode = productCodeIncludesSequence
                ? normalizeItemCode(originalItemCode)
                : requireItemCode(originalItemCode);
        final String originalFullCode = productCodeIncludesSequence
                ? normalizedProductCode
                : productCodeService.buildFullProductCode(normalizedProductCode, normalizedItemCode);

        log.info("상품 수정 서비스 호출, 대상 코드: {}", originalFullCode);

        Product product;
        if (productCodeIncludesSequence) {
            product = productRepository.findByProductCodeWithStock(normalizedProductCode);
            if (product == null && normalizedItemCode != null) {
                product = productRepository.findByProductCodeAndItemCodeWithStock(normalizedProductCode, normalizedItemCode);
            }
        } else {
            product = productRepository.findByProductCodeAndItemCodeWithStock(normalizedProductCode, normalizedItemCode);
            if (product == null) {
                product = productRepository.findByProductCodeWithStock(normalizedProductCode);
            }
        }

        if (product == null) {
            log.error("상품 수정 실패 - 상품을 찾을 수 없음: {}", originalFullCode);
            throw new IllegalArgumentException("Product not found: " + originalFullCode);
        }

        if (isAdmin && updatedProduct.getProductCode() != null) {
            final String candidateProductCode = requireProductCode(updatedProduct.getProductCode());
            if (!candidateProductCode.equals(product.getProductCode())) {
                if (productRepository.existsByAccountSeqAndProductCodeExcludingId(product.getAccountSeq(), candidateProductCode, product.getProductId())) {
                    log.error("상품코드 변경 실패 - 중복된 전체 코드: {}", candidateProductCode);
                    throw new IllegalStateException("Duplicate product code: " + candidateProductCode);

                }
                log.info("상품코드 변경: {} -> {}", product.getProductCode(), candidateProductCode);
                saveHistory(product, "product_code", product.getProductCode(), candidateProductCode, reason, accountSeq);
                product.setProductCode(candidateProductCode);
            }
        }

        if (isAdmin && updatedProduct.getItemCode() != null) {
            final String candidateItemCode = requireItemCode(updatedProduct.getItemCode());
            if (!candidateItemCode.equals(product.getItemCode())) {
                if (productRepository.existsByProductCodeAndItemCode(product.getProductCode(), candidateItemCode)) {
                    String duplicateCode = productCodeService.buildFullProductCode(product.getProductCode(), candidateItemCode);
                    log.error("아이템코드 변경 실패 - 중복된 전체 코드: {}", duplicateCode);
                    throw new IllegalStateException("Duplicate product code: " + duplicateCode);
                }
                log.info("아이템코드 변경: {} -> {}", product.getItemCode(), candidateItemCode);
                saveHistory(product, "item_code", product.getItemCode(), candidateItemCode, reason, accountSeq);
                product.setItemCode(candidateItemCode);
            }
        }

        if (updatedProduct.getSpec() != null && !updatedProduct.getSpec().equals(product.getSpec())) {
            log.info("규격 변경: {} -> {}", product.getSpec(), updatedProduct.getSpec());
            saveHistory(product, "spec", product.getSpec(), updatedProduct.getSpec(), reason, accountSeq);
            product.setSpec(updatedProduct.getSpec());
        }

        if (updatedProduct.getPdName() != null && !updatedProduct.getPdName().equals(product.getPdName())) {
            log.info("상품명 변경: {} -> {}", product.getPdName(), updatedProduct.getPdName());
            saveHistory(product, "pd_name", product.getPdName(), updatedProduct.getPdName(), reason, accountSeq);
            product.setPdName(updatedProduct.getPdName());
        }


        if (updatedProduct.getActive() != null &&
                !updatedProduct.getActive().equals(product.getActive())) {
            log.info("사용상태 변경: {} -> {}", product.getActive(), updatedProduct.getActive());
            saveHistory(product, "active", String.valueOf(product.getActive()),
                    String.valueOf(updatedProduct.getActive()), reason, accountSeq);
            product.setActive(updatedProduct.getActive());
        }

        if (updatedProduct.getMinStockQuantity() != null &&
                !updatedProduct.getMinStockQuantity().equals(product.getMinStockQuantity())) {
            log.info("최소재고 변경: {} -> {}", product.getMinStockQuantity(), updatedProduct.getMinStockQuantity());
            saveHistory(product, "min_stock_quantity", String.valueOf(product.getMinStockQuantity()),
                    String.valueOf(updatedProduct.getMinStockQuantity()), reason, accountSeq);
            product.setMinStockQuantity(updatedProduct.getMinStockQuantity());
        }

        Stock stock = product.getStock();
        if (stock != null) {
            int currentPiecesPerBox = product.getPiecesPerBox() == null ? 1 : product.getPiecesPerBox();
            Integer sanitizedPieces = sanitizePiecesPerBox(piecesPerBox);

            if (sanitizedPieces != null && !sanitizedPieces.equals(currentPiecesPerBox)) {
                log.info("박스당 수량 변경: {} -> {}", currentPiecesPerBox, sanitizedPieces);
                saveHistory(product, "pieces_per_box", String.valueOf(currentPiecesPerBox),
                        String.valueOf(sanitizedPieces), reason, accountSeq);
                product.setPiecesPerBox(sanitizedPieces);
                currentPiecesPerBox = sanitizedPieces;
            }

            int oldShQty = stock.getShQty() == null ? 0 : stock.getShQty();
            int oldHpQty = stock.getHpQty() == null ? 0 : stock.getHpQty();
            int oldTotal = stock.getTotalQty() != null ? stock.getTotalQty() : oldShQty + oldHpQty;

            int resolvedShQty = resolveWarehouseQuantity(shQty, oldShQty);
            int resolvedHpQty = resolveWarehouseQuantity(hpQty, oldHpQty);

            boolean shChanged = resolvedShQty != oldShQty;
            boolean hpChanged = resolvedHpQty != oldHpQty;

            stock.updateWarehouseQuantities(resolvedShQty, resolvedHpQty);
            int newTotal = stock.getTotalQty();
            boolean totalChanged = newTotal != oldTotal;

            if (shChanged) {
                saveHistory(product, "sh_qty", String.valueOf(oldShQty), String.valueOf(resolvedShQty), reason, accountSeq);
            }
            if (hpChanged) {
                saveHistory(product, "hp_qty", String.valueOf(oldHpQty), String.valueOf(resolvedHpQty), reason, accountSeq);
            }

            if (shChanged || hpChanged || totalChanged || stock.getTotalQty() == null) {
                if (totalChanged) {
                    log.info("총재고 변경: {} -> {}", oldTotal, newTotal);
                    saveHistory(product, "total_qty", String.valueOf(oldTotal), String.valueOf(newTotal), reason, accountSeq);
                }

                StockHistory history = StockHistory.builder()
                        .product_id(product)
                        .account_seq(accountSeq)
                        .action("ADJUST")
                        .old_sh_qty(oldShQty)
                        .new_sh_qty(stock.getShQty())
                        .old_hp_qty(oldHpQty)
                        .new_hp_qty(stock.getHpQty())
                        .old_total_qty(oldTotal)
                        .change_qty(newTotal - oldTotal)
                        .new_total_qty(newTotal)
                        .reason(reason)
                        .build();
                stockHistoryRepository.save(history);
                log.info("재고 이력 저장: productId={}, oldTotal={}, newTotal={}", product.getProductId(), oldTotal, newTotal);
            } else {
                stock.recalculateTotalQty();
            }
        }

        if (price != null && !price.equals(product.getPrice())) {
            log.info("단가 변경: {} -> {}", product.getPrice(), price);
            saveHistory(product, "price", String.valueOf(product.getPrice()),
                    String.valueOf(price), reason, accountSeq);
            priceService.registerPrice(product, price, accountSeq);
        }

        productRepository.save(product);
        if (stock != null) {
            stockRepository.save(stock);
            log.info("총재고 저장 완료, 상품 코드: {}, 현재 총재고: {}", product.getFullProductCode(), stock.getTotalQty());
        }
        log.info("상품 수정 서비스 완료, 최종 코드: {}", product.getFullProductCode());
    }

    private String requireProductCode(String code) {
        if (code == null) {
            throw new IllegalArgumentException("제품 기본 코드가 필요합니다.");
        }
        final String trimmed = code.trim();
        if (trimmed.isEmpty()) {
            throw new IllegalArgumentException("제품 기본 코드가 필요합니다.");
        }
        return trimmed;
    }

    private String requireItemCode(String code) {
        if (code == null) {
            throw new IllegalArgumentException("아이템 코드가 필요합니다.");
        }
        final String trimmed = code.trim();
        if (trimmed.isEmpty()) {
            throw new IllegalArgumentException("아이템 코드가 필요합니다.");
        }
        return trimmed;
    }

    private String normalizeItemCode(String code) {
        if (code == null) {
            return null;
        }
        final String trimmed = code.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private boolean hasSequenceSuffix(String productCode) {
        if (productCode == null) {
            return false;
        }
        final String trimmed = productCode.trim();
        if (trimmed.isEmpty()) {
            return false;
        }
        int underscoreCount = 0;
        for (int i = 0; i < trimmed.length(); i++) {
            if (trimmed.charAt(i) == '_') {
                underscoreCount++;
                if (underscoreCount >= 3) {
                    return true;
                }
            }
        }
        return false;
    }

    private void saveHistory(Product product, String field, String oldValue, String newValue,
                             String reason, Long accountSeq) {
        ProductChangeHistory history = ProductChangeHistory.builder()
                .product_id(product)
                .field_name(field)
                .old_value(oldValue)
                .new_value(newValue)
                .reason(reason)
                .changed_by(accountSeq)
                .build();
        productChangeHistoryRepository.save(history);
        log.debug("변경 이력 저장 - productId: {}, field: {}, old: {}, new: {}, reason: {}", product.getProductId(), field, oldValue, newValue, reason);
    }

    private Integer sanitizePiecesPerBox(Integer piecesPerBox) {
        if (piecesPerBox == null) {
            return null;
        }
        if (piecesPerBox < 1) {
            log.warn("잘못된 박스당 수량 입력: {}. 1로 보정합니다.", piecesPerBox);
            return 1;
        }
        return piecesPerBox;
    }

    private int resolveWarehouseQuantity(Integer requested, int fallback) {
        if (requested == null) {
            return fallback;
        }
        return requested < 0 ? 0 : requested;
    }
}
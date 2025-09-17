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
import com.project.SH.repository.ProductChangeHistoryRepository;

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
    public void registerProduct(Product product, Double price, Integer piecesPerBox, Integer totalQty, Long accountSeq) {
        final String baseProductCode = requireProductCode(product.getProductCode());
        final String nextItemCode = productCodeService.getNextItemCodeForBase(baseProductCode);
        product.setProductCode(baseProductCode);
        product.setItemCode(nextItemCode);

        final String fullProductCode = product.getFullProductCode();

        if (productRepository.existsByProductCodeAndItemCode(baseProductCode, nextItemCode)) {
            log.error("상품 등록 실패 - 중복된 전체 코드: {}", fullProductCode);
            throw new IllegalStateException("Duplicate product code: " + fullProductCode);
        }

        log.info("상품 등록 서비스 호출, 기본 코드: {}, 생성된 전체 코드: {}", baseProductCode, fullProductCode);

        if (piecesPerBox == null) piecesPerBox = 1;
        if (totalQty == null) totalQty = 0;
        if (product.getMinStockQuantity() == null) product.setMinStockQuantity(0);

        // 상품 정보 저장
        product.setPiecesPerBox(piecesPerBox);
        productRepository.save(product);
        log.info("상품 기본 정보 저장 완료, 상품 코드: {}", product.getFullProductCode());

        // 재고 정보 저장
        int boxQty = totalQty / piecesPerBox;
        int looseQty = totalQty % piecesPerBox;
        Stock stock = Stock.builder()
                .product(product)
                .pieces_per_box(piecesPerBox)
                .box_qty(boxQty)
                .loose_qty(looseQty)
                .build();
        stockRepository.save(stock);
        log.info("상품 코드: {}에 재고 등록 완료", product.getFullProductCode());

        // 재고 변동 기록 저장
        StockHistory history = StockHistory.builder()
                .product_id(product)
                .account_seq(accountSeq)
                .action("IN")
                .old_total_qty(0)
                .change_qty(totalQty)
                .new_total_qty(totalQty)
                .reason("Initial stock")
                .build();
        stockHistoryRepository.save(history);
        log.info("상품 코드: {}의 초기 재고 이력 저장", product.getFullProductCode());

        // 가격 등록
        priceService.registerPrice(product, price, accountSeq);
        log.info("상품 코드: {}에 가격 등록 완료", product.getFullProductCode());
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
        final String normalizedItemCode = requireItemCode(itemCode);
        final String fullCode = productCodeService.buildFullProductCode(normalizedProductCode, normalizedItemCode);
        log.info("단일 상품 조회, 상품 코드: {}", fullCode);
        return productRepository.findByProductCodeAndItemCodeWithStock(normalizedProductCode, normalizedItemCode);
    }
    public List<Product> searchProducts(String keyword) {
        log.info("상품 검색, 키워드: {}", keyword);
        return productRepository.searchAllByKeyword(keyword);
    }

    @Transactional
    public void updateProduct(String originalProductCode, String originalItemCode, Product updatedProduct,
                              Integer piecesPerBox, Integer totalQty, Double price,
                              Long accountSeq, String reason, boolean isAdmin) {
        final String normalizedProductCode = requireProductCode(originalProductCode);
        final String normalizedItemCode = requireItemCode(originalItemCode);
        final String originalFullCode = productCodeService.buildFullProductCode(normalizedProductCode, normalizedItemCode);

        log.info("상품 수정 서비스 호출, 대상 코드: {}", originalFullCode);
        Product product = productRepository.findByProductCodeAndItemCodeWithStock(normalizedProductCode, normalizedItemCode);
        if (product == null) {
            log.error("상품 수정 실패 - 상품을 찾을 수 없음: {}", originalFullCode);
            throw new IllegalArgumentException("Product not found: " + originalFullCode);
        }

        if (isAdmin && updatedProduct.getProductCode() != null) {
            final String candidateProductCode = requireProductCode(updatedProduct.getProductCode());
            if (!candidateProductCode.equals(product.getProductCode())) {
                if (productRepository.existsByProductCodeAndItemCode(candidateProductCode, product.getItemCode())) {
                    String duplicateFullCode = productCodeService.buildFullProductCode(candidateProductCode, product.getItemCode());
                    log.error("상품코드 변경 실패 - 중복된 전체 코드: {}", duplicateFullCode);
                    throw new IllegalStateException("Duplicate product code: " + duplicateFullCode);
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
            if (piecesPerBox != null && !piecesPerBox.equals(stock.getPiecesPerBox())) {
                log.info("박스당 수량 변경: {} -> {}", stock.getPiecesPerBox(), piecesPerBox);
                saveHistory(product, "pieces_per_box", String.valueOf(stock.getPiecesPerBox()),
                        String.valueOf(piecesPerBox), reason, accountSeq);
                stock.setPiecesPerBox(piecesPerBox);
                product.setPiecesPerBox(piecesPerBox);
            }

            if (totalQty != null) {
                int oldTotal = stock.getTotalQty();
                if (!totalQty.equals(oldTotal)) {
                    log.info("총재고 변경: {} -> {}", oldTotal, totalQty);
                    saveHistory(product, "total_qty", String.valueOf(oldTotal),
                            String.valueOf(totalQty), reason, accountSeq);
                    int boxQty = totalQty / stock.getPiecesPerBox();
                    int looseQty = totalQty % stock.getPiecesPerBox();
                    stock.setBoxQty(boxQty);
                    stock.setLooseQty(looseQty);

                    StockHistory history = StockHistory.builder()
                            .product_id(product)
                            .account_seq(accountSeq)
                            .action("ADJUST")
                            .old_total_qty(oldTotal)
                            .change_qty(totalQty - oldTotal)
                            .new_total_qty(totalQty)
                            .reason(reason)
                            .build();
                    stockHistoryRepository.save(history);
                    log.info("재고 이력 저장: productId={}, oldTotal={}, newTotal={}", product.getProductId(), oldTotal, totalQty);
                }
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
}
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
    private final StockRepository stockRepository;
    private final StockHistoryRepository stockHistoryRepository;
    private final ProductChangeHistoryRepository productChangeHistoryRepository;


    @Transactional
    public void registerProduct(Product product, Double price, Integer piecesPerBox, Integer totalQty, Long accountSeq) {
        log.info("상품 등록 서비스 호출, 상품 코드: {}", product.getProductCode());

        // 상품 정보를 먼저 저장
        productRepository.save(product);
        log.info("상품 기본 정보 저장 완료, 상품 코드: {}", product.getProductCode());

        // 재고 정보 저장
        if (piecesPerBox == null) piecesPerBox = 1;
        if (totalQty == null) totalQty = 0;
        Stock stock = Stock.builder()
                .product(product)
                .piecesPerBox(piecesPerBox)
                .totalQty(totalQty)
                .build();
        stockRepository.save(stock);
        log.info("상품 코드: {}에 재고 등록 완료", product.getProductCode());


        // 재고 변동 기록 저장
        StockHistory history = StockHistory.builder()
                .product(product)
                .oldTotalQty(0)
                .changeQty(totalQty)
                .newTotalQty(totalQty)
                .build();
        stockHistoryRepository.save(history);
        log.info("상품 코드: {}의 초기 재고 이력 저장", product.getProductCode());

            // 가격 등록
        priceService.registerPrice(product, price, accountSeq, "상품 등록 시 가격");
            log.info("상품 코드: {}에 가격 등록 완료", product.getProductCode());
        }

        public List<Product> getAllProducts() {
        log.info("상품 목록 조회 서비스 호출");

        // 상품과 해당 가격 목록을 함께 조회
        List<Product> products = productRepository.findAllWithPricesAndStock();

        log.info("상품 목록 조회 서비스 완료, 상품 수: {}", products.size());
        return products;
}

    public Product getProductByCode(String productCode) {
        log.info("단일 상품 조회, 상품 코드: {}", productCode);
        return productRepository.findByProductCodeWithStock(productCode);
    }
    public List<Product> searchProducts(String keyword) {
        log.info("상품 검색, 키워드: {}", keyword);
        return productRepository.searchAllByKeyword(keyword);
    }

    @Transactional
    public void updateProduct(String originalProductCode, Product updatedProduct,
                              Integer piecesPerBox, Integer totalQty, Double price,
                              Long accountSeq, String reason, boolean isAdmin) {
        log.info("상품 수정 서비스 호출, 대상 코드: {}", originalProductCode);
        Product product = productRepository.findByProductCodeWithStock(originalProductCode);
        if (product == null) {
            log.error("상품 수정 실패 - 상품을 찾을 수 없음: {}", originalProductCode);
            throw new IllegalArgumentException("Product not found: " + originalProductCode);
        }

        if (isAdmin && updatedProduct.getProductCode() != null &&
                !updatedProduct.getProductCode().equals(product.getProductCode())) {
            log.info("상품코드 변경: {} -> {}", product.getProductCode(), updatedProduct.getProductCode());
            saveHistory(product, "productCode", product.getProductCode(), updatedProduct.getProductCode(), reason, accountSeq);
            product.setProductCode(updatedProduct.getProductCode());
        }

        if (isAdmin && updatedProduct.getItemCode() != null &&
                !updatedProduct.getItemCode().equals(product.getItemCode())) {
            log.info("아이템코드 변경: {} -> {}", product.getItemCode(), updatedProduct.getItemCode());
            saveHistory(product, "itemCode", product.getItemCode(), updatedProduct.getItemCode(), reason, accountSeq);
            product.setItemCode(updatedProduct.getItemCode());
        }

        if (updatedProduct.getSpec() != null && !updatedProduct.getSpec().equals(product.getSpec())) {
            log.info("규격 변경: {} -> {}", product.getSpec(), updatedProduct.getSpec());
            saveHistory(product, "spec", product.getSpec(), updatedProduct.getSpec(), reason, accountSeq);
            product.setSpec(updatedProduct.getSpec());
        }

        if (updatedProduct.getPdName() != null && !updatedProduct.getPdName().equals(product.getPdName())) {
            log.info("상품명 변경: {} -> {}", product.getPdName(), updatedProduct.getPdName());
            saveHistory(product, "pdName", product.getPdName(), updatedProduct.getPdName(), reason, accountSeq);
            product.setPdName(updatedProduct.getPdName());
        }

        if (updatedProduct.getMinStockQuantity() != null &&
                !updatedProduct.getMinStockQuantity().equals(product.getMinStockQuantity())) {
            log.info("최소재고 변경: {} -> {}", product.getMinStockQuantity(), updatedProduct.getMinStockQuantity());
            saveHistory(product, "minStockQuantity",
                    String.valueOf(product.getMinStockQuantity()),
                    String.valueOf(updatedProduct.getMinStockQuantity()), reason, accountSeq);
            product.setMinStockQuantity(updatedProduct.getMinStockQuantity());
        }

        if (updatedProduct.getActive() != null &&
                !updatedProduct.getActive().equals(product.getActive())) {
            log.info("사용상태 변경: {} -> {}", product.getActive(), updatedProduct.getActive());
            saveHistory(product, "active", String.valueOf(product.getActive()),
                    String.valueOf(updatedProduct.getActive()), reason, accountSeq);
            product.setActive(updatedProduct.getActive());
        }

        Stock stock = product.getStock();
        if (stock != null) {
            if (piecesPerBox != null && !piecesPerBox.equals(stock.getPiecesPerBox())) {
                log.info("박스당 수량 변경: {} -> {}", stock.getPiecesPerBox(), piecesPerBox);
                saveHistory(product, "piecesPerBox", String.valueOf(stock.getPiecesPerBox()),
                        String.valueOf(piecesPerBox), reason, accountSeq);
                stock.setPiecesPerBox(piecesPerBox);
            }

            if (totalQty != null && !totalQty.equals(stock.getTotalQty())) {
                log.info("총재고 변경: {} -> {}", stock.getTotalQty(), totalQty);
                saveHistory(product, "totalQty", String.valueOf(stock.getTotalQty()),
                        String.valueOf(totalQty), reason, accountSeq);
                int oldTotal = stock.getTotalQty();
                stock.setTotalQty(totalQty);

                StockHistory history = StockHistory.builder()
                        .product(product)
                        .oldTotalQty(oldTotal)
                        .changeQty(totalQty - oldTotal)
                        .newTotalQty(totalQty)
                        .build();
                stockHistoryRepository.save(history);
                log.info("재고 이력 저장: productId={}, oldTotal={}, newTotal={}", product.getProductId(), oldTotal, totalQty);
            }
        }

        if (price != null && !price.equals(product.getPrice())) {
            log.info("단가 변경: {} -> {}", product.getPrice(), price);
            saveHistory(product, "price", String.valueOf(product.getPrice()),
                    String.valueOf(price), reason, accountSeq);
            priceService.registerPrice(product, price, accountSeq, reason);;
        }

        productRepository.save(product);
        if (stock != null) {
            stockRepository.save(stock);
        }
        log.info("상품 수정 서비스 완료, 최종 코드: {}", product.getProductCode());
    }

    private void saveHistory(Product product, String field, String oldValue, String newValue,
                             String reason, Long accountSeq) {
        ProductChangeHistory history = ProductChangeHistory.builder()
                .product(product)
                .fieldName(field)
                .oldValue(oldValue)
                .newValue(newValue)
                .reason(reason)
                .changedBy(accountSeq)
                .build();
        productChangeHistoryRepository.save(history);
        log.debug("변경 이력 저장 - productId: {}, field: {}, old: {}, new: {}, reason: {}", product.getProductId(), field, oldValue, newValue, reason);
    }
}
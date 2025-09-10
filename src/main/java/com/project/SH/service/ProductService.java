package com.project.SH.service;

import com.project.SH.domain.Product;
import com.project.SH.domain.Stock;
import com.project.SH.domain.StockHistory;
import com.project.SH.repository.ProductRepository;
import com.project.SH.repository.StockHistoryRepository;
import com.project.SH.repository.StockRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductService implements ProductServiceImpl {

    private final ProductRepository productRepository;
    private final PriceService priceService;
    private final StockRepository stockRepository;
    private final StockHistoryRepository stockHistoryRepository;

    @Transactional
        public void registerProduct(Product product, Double price, Integer piecesPerBox, Integer totalQty, Long accountSeq) {
            log.info("상품 등록 시작, 상품 코드: {}", product.getProductCode());

            // 상품 정보를 먼저 저장
            productRepository.save(product);
            log.info("상품 등록 완료, 상품 코드: {}", product.getProductCode());

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
            priceService.registerPrice(product, price, accountSeq);
            log.info("상품 코드: {}에 가격 등록 완료", product.getProductCode());
        }

        public List<Product> getAllProducts() {
        log.info("상품 목록 조회 시작");

        // 상품과 해당 가격 목록을 함께 조회
        List<Product> products = productRepository.findAllWithPricesAndStock();

        log.info("상품 목록 조회 완료, 상품 수: {}", products.size());
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
}
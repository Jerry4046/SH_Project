package com.project.SH.service;

import com.project.SH.domain.Price;
import com.project.SH.domain.Product;
import com.project.SH.repository.PriceRepository;
import com.project.SH.repository.ProductRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductService implements ProductServiceImpl {

    private final ProductRepository productRepository;
    private final PriceService priceService;

    @Transactional
    public void registerProduct(Product product, String accountUuid) {
        log.info("상품 등록 시작, 상품 코드: {}", product.getProductCode());

        // 상품 정보를 먼저 저장
        productRepository.save(product);
        log.info("상품 등록 완료, 상품 코드: {}", product.getProductCode());

        // 가격 등록
        priceService.registerPrice(product, product.getPrice(), accountUuid);
        log.info("상품 코드: {}에 가격 등록 완료", product.getProductCode());
    }

    public List<Product> getAllProducts() {
        log.info("상품 목록 조회 시작");

        // 상품 목록을 가져옴
        List<Product> products = productRepository.findAll();

        // 각 상품의 가격 목록을 updatedAt 기준으로 내림차순으로 정렬
        for (Product product : products) {
            List<Price> prices = product.getPrices();
            if (prices != null && !prices.isEmpty()) {
                // 가격 목록을 최신 수정일 기준으로 내림차순 정렬
                prices.sort((p1, p2) -> p2.getUpdatedAt().compareTo(p1.getUpdatedAt())); // 내림차순 정렬
            }
        }

        // 가격 목록에서 최신 가격만 남기고, 중복된 상품은 그대로 출력
        log.info("상품 목록 조회 완료, 상품 수: {}", products.size());
        return products;
    }
}

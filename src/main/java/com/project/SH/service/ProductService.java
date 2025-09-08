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
        public void registerProduct(Product product, Double price, Long accountSeq) {
            log.info("상품 등록 시작, 상품 코드: {}", product.getProductCode());

            // 널 값 방지
            if (product.getPiecesPerBox() == null) product.setPiecesPerBox(1);
            if (product.getBoxQty() == null) product.setBoxQty(0);
            if (product.getLooseQty() == null) product.setLooseQty(0);

            // 상품 정보를 먼저 저장
            productRepository.save(product);
            log.info("상품 등록 완료, 상품 코드: {}", product.getProductCode());

            // 가격 등록
            priceService.registerPrice(product, price, accountSeq);
            log.info("상품 코드: {}에 가격 등록 완료", product.getProductCode());
        }

        public List<Product> getAllProducts() {
            log.info("상품 목록 조회 시작");

            // 상품과 해당 가격 목록을 함께 조회
            List<Product> products = productRepository.findAllWithPrices();


            log.info("상품 목록 조회 완료, 상품 수: {}", products.size());
            return products;
        }
    }
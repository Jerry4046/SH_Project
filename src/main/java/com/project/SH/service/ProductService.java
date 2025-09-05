package com.project.SH.service;

import com.project.SH.domain.Product;
import com.project.SH.repository.ProductRepository;
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

    @Transactional
        public void registerProduct(Product product, Double price, Long accountSeq) {
            log.info("상품 등록 시작, 상품 코드: {}", product.getProductCode());

            // 박스 수량과 낱개 수량 계산
            if (product.getPiecesPerBox() != null && product.getPiecesPerBox() > 0 && product.getTotalQty() != null) {
                int box = product.getTotalQty() / product.getPiecesPerBox();
                int loose = product.getTotalQty() % product.getPiecesPerBox();
                product.setBoxQty(box);
                product.setLooseQty(loose);
            } else {
                product.setBoxQty(0);
                product.setLooseQty(product.getTotalQty() != null ? product.getTotalQty() : 0);
            }

            productRepository.save(product);
            log.info("상품 등록 완료, 상품 코드: {}", product.getProductCode());

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
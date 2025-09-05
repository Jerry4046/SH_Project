package com.project.SH.service;

import com.project.SH.domain.Price;
import com.project.SH.domain.Product;
import com.project.SH.repository.PriceRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class PriceService implements PriceServiceImpl {

    private final PriceRepository priceRepository;

        public void registerPrice(Product product, Double price, Long accountSeq) {
            try {
                log.info("가격 등록 시작, 상품 코드: {}, 가격: {}, 수정자 번호: {}", product.getProductCode(), price, accountSeq);

                // 가격 테이블에 새로운 가격 기록 저장
                Price priceRecord = new Price();
                priceRecord.setProduct(product);
                priceRecord.setPrice(price);
                priceRecord.setAccountSeq(accountSeq);  // 수정자 SEQ 설정
                priceRecord.setDescription("상품 등록 시 가격");
                priceRepository.save(priceRecord);

                log.info("가격 등록 성공, 상품 코드: {}", product.getProductCode());
            } catch (Exception e) {
                log.error("가격 등록 실패, 상품 코드: {}, 에러: {}", product.getProductCode(), e.getMessage());
                throw new RuntimeException("가격 등록 실패", e);
            }
        }

        public Double getLatestPrice(Product product) {
            log.info("상품 코드: {}의 최신 가격을 조회", product.getProductCode());
            List<Price> prices = priceRepository.findByProductOrderByCreatedAtDesc(product);
            if (prices != null && !prices.isEmpty()) {
                log.info("가장 최근 가격: {}", prices.get(0).getPrice());
                return prices.get(0).getPrice();  // 가장 최근 가격 반환
            }
            log.warn("상품 코드: {}의 가격이 없습니다.", product.getProductCode());
            return 0.0;  // 가격이 없으면 0 반환
        }
    }
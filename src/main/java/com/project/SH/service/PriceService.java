package com.project.SH.service;

import com.project.SH.domain.Price;
import com.project.SH.domain.Product;
import com.project.SH.repository.PriceRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class PriceService implements PriceServiceImpl {

    private final PriceRepository priceRepository;

    @Override
    public void registerPrice(Product product, Double price, Long accountSeq, String description) {
        try {
            log.info("가격 기록 처리, 상품 코드: {}, 가격: {}, 수정자 번호: {}", product.getProductCode(), price, accountSeq);
            Optional<Price> existingOpt = priceRepository.findTopByProductOrderByCreatedAtAsc(product);
            Price priceRecord;
            LocalDateTime originalCreatedAt = null;
            if (existingOpt.isPresent()) {
                priceRecord = existingOpt.get();
                log.info("기존 가격 업데이트, 기존: {} -> 새: {}", priceRecord.getPrice(), price);
                priceRecord.setPrice(price);
                originalCreatedAt = priceRecord.getCreatedAt();
                priceRecord.setAccountSeq(accountSeq);
                priceRecord.setDescription(description);
                priceRecord.setUpdatedAt(LocalDateTime.now());
            } else {
                log.info("가격 최초 등록");
                priceRecord = new Price();
                priceRecord.setProduct(product);
                priceRecord.setPrice(price);
                priceRecord.setAccountSeq(accountSeq);
                priceRecord.setDescription(description);
            }
            priceRepository.save(priceRecord);
            log.info("가격 기록 저장 완료, 상품 코드: {}, 생성일자: {}, 수정일자: {}", product.getProductCode(),
                    originalCreatedAt != null ? originalCreatedAt : priceRecord.getCreatedAt(), priceRecord.getUpdatedAt());
        } catch (Exception e) {
            log.error("가격 기록 실패, 상품 코드: {}, 에러: {}", product.getProductCode(), e.getMessage());
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
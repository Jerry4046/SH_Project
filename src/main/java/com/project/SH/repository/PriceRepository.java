package com.project.SH.repository;

import com.project.SH.domain.Price;
import com.project.SH.domain.Product;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

// PriceRepository 수정
public interface PriceRepository extends JpaRepository<Price, Long> {

    // 상품 ID로 가격 정보를 조회하는 메서드
    List<Price> findByProductOrderByCreatedAtDesc(Product product);

    // 가장 오래된(최초) 가격 정보를 조회하는 메서드
    Optional<Price> findTopByProductOrderByCreatedAtAsc(Product product);
}

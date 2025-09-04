package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;
import lombok.extern.slf4j.Slf4j;
import java.util.Comparator;


import java.util.List;

@Entity
@Table(name = "product_tb")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Slf4j
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long productId;

    @Column(nullable = false, unique = true, length = 20)
    private String productCode;

    @Column(name = "pd_name", nullable = false, length = 50)
    private String pdName;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Integer stockQuantity = 0;

    @Column(nullable = false)
    private Integer minStockQuantity = 0;

    @Column(nullable = false)
    private Boolean active = true;

    // Price 테이블과 관계 설정
    @OneToMany(mappedBy = "product", fetch = FetchType.LAZY)
    private List<Price> prices;

    // getPrice() 메서드를 통해 Price 테이블에서 가격을 반환
    public Double getPrice() {
        if (prices != null && !prices.isEmpty()) {
            log.info("가장 최근 가격: {}", prices.get(prices.size() - 1).getPrice());
            return prices.stream()
                    .max(Comparator.comparing(Price::getPriceId))
                    .map(Price::getPrice)
                    .orElse(0.0);

        }

        log.warn("가격이 없습니다.");
        return 0.0;  // 가격이 없으면 0 반환
    }
}

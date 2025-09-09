package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;

/**
 * 상품 기본 정보만을 담당하는 엔티티.
 * 재고 관련 정보는 {@link Stock} 엔티티로 분리되었다.
 */

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

    @Column(name = "item_code", nullable = false, length = 10)
    private String itemCode;

    @Column(nullable = false, length = 50)
    private String spec;

    @Column(name = "pd_name", nullable = false, length = 100)
    private String pdName;

    @Column(name = "min_stock_quantity", nullable = false)
    private Integer minStockQuantity = 0;

    @Column(nullable = false)
    private Boolean active = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Stock 테이블과 1:1 관계 설정
    @OneToOne(mappedBy = "product", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Stock stock;

    // Price 테이블과 관계 설정
    @OneToMany(mappedBy = "product", fetch = FetchType.LAZY)
    private List<Price> prices;

    // getPrice() 메서드를 통해 Price 테이블에서 가격을 반환
    public Double getPrice() {
        if (prices != null && !prices.isEmpty()) {
            return prices.stream()
                    .max(Comparator.comparing(Price::getPriceId))
                    .map(Price::getPrice)
                    .orElse(0.0);
        }
        log.warn("가격이 없습니다.");
        return 0.0;
    }

    @Column(name = "account_seq", nullable = false)
    private Long accountSeq;

    // 등록자 정보 연동 (account_seq -> User)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_seq", insertable = false, updatable = false)
    private User user;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
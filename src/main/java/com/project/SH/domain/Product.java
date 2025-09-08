package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
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

    @Column(name = "item_code", nullable = false, length = 20)
    private String itemCode;

    @Column(nullable = false, length = 50)
    private String spec;

    @Column(name = "pd_name", nullable = false, length = 100)
    private String pdName;

    @Column(name = "pieces_per_box", nullable = false)
    private Integer piecesPerBox = 1;

    @Column(name = "box_qty", nullable = false)
    private Integer boxQty = 0;

    @Column(name = "loose_qty", nullable = false)
    private Integer looseQty = 0;

    @Column(name = "total_qty")
    private Integer totalQty;

    @Column(name = "min_stock_quantity", nullable = false)
    private Integer minStockQuantity = 0;

    @Column(nullable = false)
    private Boolean active = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

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
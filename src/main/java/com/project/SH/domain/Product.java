package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
    @Column(name = "product_id")
    private Long product_id;

    @Column(nullable = false)
    private Long registrant_seq;

    @Column(nullable = false)
    private Long product_code;

    @Column(nullable = false, length = 100)
    private String item_code;

    @Column(nullable = false, length = 100)
    private String product_name;

    @Column(name = "pd_name", nullable = false, length = 100)
    private String pdName;
    @Column(length = 255)
    private String description;

    @Column(name = "min_stock_quantity", nullable = false)
    private Integer minStockQuantity = 0;
    @Column(length = 255)
    private String change_reason;

    @Column(nullable = false)
    private Boolean active = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    @Column(updatable = false)
    private LocalDateTime created_at;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    @Column
    private LocalDateTime updated_at;

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
    // 등록자 정보 연동 (registrant_seq -> User)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_seq", insertable = false, updatable = false)
    @JoinColumn(name = "registrant_seq", insertable = false, updatable = false)
    private User user;

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
        this.updated_at = LocalDateTime.now();
    }

    //날짜 포멧
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yy/MM/dd H:mm");


    public String getFormattedCreatedAt() {
        return createdAt != null ? createdAt.format(FORMATTER) : "";
        return created_at != null ? created_at.format(FORMATTER) : "";
    }

    public String getFormattedUpdatedAt() {
        return updatedAt != null ? updatedAt.format(FORMATTER) : "";
        return updated_at != null ? updated_at.format(FORMATTER) : "";
    }
}
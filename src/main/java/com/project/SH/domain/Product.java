package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;

/**
 * 제품 기본 정보를 담당하는 엔티티.
 * 재고 정보는 {@link Stock} 엔티티와 별도로 관리된다.
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

    @Column(name = "account_seq", nullable = false)
    private Long account_seq;

    @Column(name = "product_code", nullable = false, length = 20)
    private String product_code;

    @Column(name = "item_code", length = 10)
    private String item_code;

    @Column(name = "pd_name", nullable = false, length = 100)
    private String pd_name;

    @Column(length = 100)
    private String spec;

    @Column(name = "pieces_per_box", nullable = false)
    @Builder.Default
    private Integer pieces_per_box = 1;

    @Column(name = "min_stock_quantity", nullable = false)
    private Integer min_stock_quantity = 0;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Boolean active = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime created_at;

    @Column(name = "updated_at")
    private LocalDateTime updated_at;

    // Stock 테이블과 1:1 관계
    @OneToOne(mappedBy = "product", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Stock stock;

    // Price 테이블과 관계
    @OneToMany(mappedBy = "product", fetch = FetchType.LAZY)
    private List<Price> prices;

    // 입수량별 변형 (ProductVariant) 테이블과 1:N 관계
    @OneToMany(mappedBy = "product", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ProductVariant> variants;

    // 등록자 정보 (account_seq -> User)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_seq", insertable = false, updatable = false)
    private User user;

    @PrePersist
    protected void onCreate() {
        this.created_at = LocalDateTime.now();
        this.updated_at = this.created_at;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updated_at = LocalDateTime.now();
    }

    // 최신 가격 조회
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

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yy/MM/dd H:mm");

    public String getFormattedCreatedAt() {
        return created_at != null ? created_at.format(FORMATTER) : "";
    }

    public String getFormattedUpdatedAt() {
        return updated_at != null ? updated_at.format(FORMATTER) : "";
    }

    // 기존 camelCase 접근자를 위한 메서드들
    public Long getProductId() { return product_id; }
    public void setProductId(Long product_id) { this.product_id = product_id; }

    public Long getAccountSeq() { return account_seq; }
    public void setAccountSeq(Long account_seq) { this.account_seq = account_seq; }

    public String getProductCode() { return product_code; }
    public void setProductCode(String product_code) { this.product_code = product_code; }

    public String getItemCode() { return item_code; }
    public void setItemCode(String item_code) { this.item_code = item_code; }

    public String getPdName() { return pd_name; }
    public void setPdName(String pd_name) { this.pd_name = pd_name; }

    public Integer getMinStockQuantity() { return min_stock_quantity; }
    public void setMinStockQuantity(Integer min_stock_quantity) { this.min_stock_quantity = min_stock_quantity; }

    public Integer getPiecesPerBox() { return pieces_per_box; }
    public void setPiecesPerBox(Integer pieces_per_box) { this.pieces_per_box = pieces_per_box; }

    public LocalDateTime getCreatedAt() { return created_at; }
    public void setCreatedAt(LocalDateTime created_at) { this.created_at = created_at; }

    public LocalDateTime getUpdatedAt() { return updated_at; }
    public void setUpdatedAt(LocalDateTime updated_at) { this.updated_at = updated_at; }

    @Transient
    public String getFullProductCode() {
        if (product_code == null || product_code.isBlank()) {
            return item_code != null ? item_code : "";
        }
        if (hasExtendedProductCode(product_code)) {
            return product_code;
        }
        if (item_code == null || item_code.isBlank()) {
            return product_code;
        }
        return product_code + "_" + item_code;
    }

    private boolean hasExtendedProductCode(String value) {
        int underscoreCount = 0;
        for (int i = 0; i < value.length(); i++) {
            if (value.charAt(i) == '_') {
                underscoreCount++;
                if (underscoreCount >= 3) {
                    return true;
                }
            }
        }
        return false;
    }
}
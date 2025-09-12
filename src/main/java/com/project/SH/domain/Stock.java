package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 재고 정보를 담당하는 엔티티.
 */
@Entity
@Table(name = "stock_tb")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Stock {

    @Id
    @Column(name = "product_id")
    private Long productId;

    @OneToOne
    @MapsId
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "pieces_per_pack", nullable = false)
    private Integer piecesPerPack = 1;

    @Column(name = "total_qty", nullable = false)
    private Integer totalQty = 0;

    @Column(name = "pack_qty", insertable = false, updatable = false)
    private Integer packQty;

    @Column(name = "single_qty", insertable = false, updatable = false)
    private Integer singleQty;

    @Column(name = "min_stock_qty", nullable = false)
    private Integer minStockQuantity = 0;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

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
package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 현재 재고 정보를 담당하는 엔티티.
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
    private Long product_id;

    @OneToOne
    @MapsId
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "pieces_per_box", nullable = false)
    private Integer pieces_per_box = 1;

    @Column(name = "box_qty", nullable = false)
    private Integer box_qty = 0;

    @Column(name = "loose_qty", nullable = false)
    private Integer loose_qty = 0;

    @Column(name = "total_qty", insertable = false, updatable = false)
    private Integer total_qty;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime created_at;

    @Column(name = "updated_at")
    private LocalDateTime updated_at;

    @PrePersist
    protected void onCreate() {
        this.created_at = LocalDateTime.now();
        this.updated_at = this.created_at;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updated_at = LocalDateTime.now();
    }

    // 기존 camelCase 접근자를 위한 메서드들
    public Long getProductId() { return product_id; }
    public void setProductId(Long product_id) { this.product_id = product_id; }

    public Integer getPiecesPerBox() { return pieces_per_box; }
    public void setPiecesPerBox(Integer pieces_per_box) { this.pieces_per_box = pieces_per_box; }

    public Integer getBoxQty() { return box_qty; }
    public void setBoxQty(Integer box_qty) { this.box_qty = box_qty; }

    public Integer getLooseQty() { return loose_qty; }
    public void setLooseQty(Integer loose_qty) { this.loose_qty = loose_qty; }

    public Integer getTotalQty() { return total_qty; }
    public void setTotalQty(Integer total_qty) { this.total_qty = total_qty; }

    public LocalDateTime getCreatedAt() { return created_at; }
    public void setCreatedAt(LocalDateTime created_at) { this.created_at = created_at; }

    public LocalDateTime getUpdatedAt() { return updated_at; }
    public void setUpdatedAt(LocalDateTime updated_at) { this.updated_at = updated_at; }
}
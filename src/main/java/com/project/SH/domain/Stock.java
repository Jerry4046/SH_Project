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

    @Column(name = "sh_qty", nullable = false)
    private Integer sh_qty = 0;

    @Column(name = "hp_qty", nullable = false)
    private Integer hp_qty = 0;

    @Column(name = "total_qty", nullable = false)
    private Integer total_qty = 0;

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

    public Integer getShQty() { return sh_qty; }
    public void setShQty(Integer sh_qty) {
        this.sh_qty = sanitizeQuantity(sh_qty);
        recalculateTotalQty();
    }

    public Integer getHpQty() { return hp_qty; }
    public void setHpQty(Integer hp_qty) {
        this.hp_qty = sanitizeQuantity(hp_qty);
        recalculateTotalQty();
    }

    public Integer getTotalQty() { return total_qty; }
    public void setTotalQty(Integer total_qty) {
        this.total_qty = sanitizeQuantity(total_qty);
    }

    /**
     * 창고별 수량을 한 번에 업데이트하고 총재고를 다시 계산한다.
     */
    public void updateWarehouseQuantities(Integer shQty, Integer hpQty) {
        this.sh_qty = sanitizeQuantity(shQty);
        this.hp_qty = sanitizeQuantity(hpQty);
        this.total_qty = this.sh_qty + this.hp_qty;
    }

    public LocalDateTime getCreatedAt() { return created_at; }
    public void setCreatedAt(LocalDateTime created_at) { this.created_at = created_at; }

    public LocalDateTime getUpdatedAt() { return updated_at; }
    public void setUpdatedAt(LocalDateTime updated_at) { this.updated_at = updated_at; }

    public void recalculateTotalQty() {
        this.sh_qty = sanitizeQuantity(this.sh_qty);
        this.hp_qty = sanitizeQuantity(this.hp_qty);
        this.total_qty = this.sh_qty + this.hp_qty;
    }

    private int sanitizeQuantity(Integer value) {
        return value != null && value > 0 ? value : 0;
    }
}
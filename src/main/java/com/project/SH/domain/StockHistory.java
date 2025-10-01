package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 재고 변경 이력을 기록하는 엔티티.
 */
@Entity
@Table(name = "stock_history_tb")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StockHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product_id;

    @Column(name = "account_seq", nullable = false)
    private Long account_seq;

    @Column(name = "action", nullable = false, length = 20)
    private String action;

    @Column(name = "change_qty", nullable = false)
    private Integer change_qty;

    @Column(name = "old_sh_qty", nullable = false)
    private Integer old_sh_qty;

    @Column(name = "new_sh_qty", nullable = false)
    private Integer new_sh_qty;

    @Column(name = "old_hp_qty", nullable = false)
    private Integer old_hp_qty;

    @Column(name = "new_hp_qty", nullable = false)
    private Integer new_hp_qty;

    @Column(name = "old_total_qty", nullable = false)
    private Integer old_total_qty;

    @Column(name = "new_total_qty", nullable = false)
    private Integer new_total_qty;

    @Column(name = "reason")
    private String reason;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime created_at;

    @PrePersist
    protected void onCreate() {
        this.created_at = LocalDateTime.now();
    }

    // 기존 camelCase 접근자를 위한 메서드들
    public Product getProduct() { return product_id; }
    public void setProduct(Product product) { this.product_id = product; }

    public Long getAccountSeq() { return account_seq; }
    public void setAccountSeq(Long account_seq) { this.account_seq = account_seq; }

    public Integer getChangeQty() { return change_qty; }
    public void setChangeQty(Integer change_qty) { this.change_qty = change_qty; }

    public Integer getOldShQty() { return old_sh_qty; }
    public void setOldShQty(Integer old_sh_qty) { this.old_sh_qty = old_sh_qty; }

    public Integer getNewShQty() { return new_sh_qty; }
    public void setNewShQty(Integer new_sh_qty) { this.new_sh_qty = new_sh_qty; }

    public Integer getOldHpQty() { return old_hp_qty; }
    public void setOldHpQty(Integer old_hp_qty) { this.old_hp_qty = old_hp_qty; }

    public Integer getNewHpQty() { return new_hp_qty; }
    public void setNewHpQty(Integer new_hp_qty) { this.new_hp_qty = new_hp_qty; }

    public Integer getOldTotalQty() { return old_total_qty; }
    public void setOldTotalQty(Integer old_total_qty) { this.old_total_qty = old_total_qty; }

    public Integer getNewTotalQty() { return new_total_qty; }
    public void setNewTotalQty(Integer new_total_qty) { this.new_total_qty = new_total_qty; }

    public LocalDateTime getCreatedAt() { return created_at; }
    public void setCreatedAt(LocalDateTime created_at) { this.created_at = created_at; }
}
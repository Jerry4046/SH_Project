package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 재고 변동 내역을 기록하는 엔티티.
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
    @Column(name = "history_id")
    private Long historyId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(name = "change_type", nullable = false, length = 20)
    private String changeType;

    @Column(name = "change_qty", nullable = false)
    private Integer changeQty;

    @Column(name = "old_total_qty", nullable = false)
    private Integer oldTotalQty;

    @Column(name = "new_total_qty", nullable = false)
    private Integer newTotalQty;

    @Column(name = "reason")
    private String reason;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
}
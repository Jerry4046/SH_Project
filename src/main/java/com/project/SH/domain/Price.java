package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "price_tb")
@Data
public class Price {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "price_id")
    private Long price_id;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false, foreignKey = @ForeignKey(name = "fk_price_product"))
    private Product product;

    @Column(name = "account_seq", nullable = false)
    private Long account_seq;

    @Column(nullable = false)
    private Double price;

    @Column(length = 3)
    private String currency = "KRW";

    @Column(columnDefinition = "TEXT")
    private String reason;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime created_at;

    @Column(name = "ended_at")
    private LocalDateTime ended_at;

    @PrePersist
    protected void onCreate() {
        this.created_at = LocalDateTime.now();
    }

    // 기존 camelCase 접근자를 위한 메서드들
    public Long getPriceId() { return price_id; }
    public void setPriceId(Long price_id) { this.price_id = price_id; }

    public Long getAccountSeq() { return account_seq; }
    public void setAccountSeq(Long account_seq) { this.account_seq = account_seq; }

    public LocalDateTime getCreatedAt() { return created_at; }
    public void setCreatedAt(LocalDateTime created_at) { this.created_at = created_at; }

    public LocalDateTime getEndedAt() { return ended_at; }
    public void setEndedAt(LocalDateTime ended_at) { this.ended_at = ended_at; }
}
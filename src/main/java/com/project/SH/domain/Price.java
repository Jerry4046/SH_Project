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
    private Long priceId;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false, foreignKey = @ForeignKey(name = "fk_price_product"))
    private Product product;

    @Column(nullable = false)
    private Double price;  // 가격 필드

    @Column(length = 3)
    private String currency = "KRW";

    @Column(columnDefinition = "TEXT")
    private String reason;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "account_seq", nullable = false)
    private Long accountSeq;  // 수정자 회원 SEQ

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = this.createdAt;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
package com.project.SH.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 제품의 입수량별 변형(SKU)을 관리하는 엔티티.
 * 같은 제품이라도 박스당 개수(입수량)가 다르면 별도 변형으로 관리한다.
 */
@Entity
@Table(name = "product_variant_tb",
        uniqueConstraints = @UniqueConstraint(columnNames = {"product_id", "pieces_per_box"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductVariant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "variant_id")
    private Long variantId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    @JsonIgnore
    private Product product;

    @Column(name = "pieces_per_box", nullable = false)
    private Integer piecesPerBox;

    @Column(name = "box_qty", nullable = false)
    @Builder.Default
    private Integer boxQty = 0;

    @Column(name = "loose_qty", nullable = false)
    @Builder.Default
    private Integer looseQty = 0;

    @Column(name = "sub_total_qty", nullable = false)
    @Builder.Default
    private Integer subTotalQty = 0;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = this.createdAt;
        recalculateSubTotal();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
        recalculateSubTotal();
    }

    /**
     * 소계 재계산: boxQty * piecesPerBox + looseQty
     */
    public void recalculateSubTotal() {
        int box = this.boxQty != null ? this.boxQty : 0;
        int pieces = this.piecesPerBox != null ? this.piecesPerBox : 1;
        int loose = this.looseQty != null ? this.looseQty : 0;
        this.subTotalQty = (box * pieces) + loose;
    }

    /**
     * 박스 수량과 낱개 수량을 업데이트하고 소계를 재계산
     */
    public void updateQuantities(int boxQty, int looseQty) {
        this.boxQty = Math.max(0, boxQty);
        this.looseQty = Math.max(0, looseQty);
        recalculateSubTotal();
    }

    /**
     * 총수량으로부터 박스/낱개 역산
     */
    public void setSubTotalAndCalculateBoxLoose(int totalQty) {
        int pieces = this.piecesPerBox != null && this.piecesPerBox > 0 ? this.piecesPerBox : 1;
        this.boxQty = totalQty / pieces;
        this.looseQty = totalQty % pieces;
        this.subTotalQty = totalQty;
    }
}

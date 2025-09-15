package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 상품 정보 변경 이력을 기록하는 엔티티.
 */
@Entity
@Table(name = "product_change_history_tb")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductChangeHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product_id;

    @Column(name = "field_name", nullable = false, length = 50)
    private String field_name;

    @Column(name = "old_value", length = 255)
    private String old_value;

    @Column(name = "new_value", length = 255)
    private String new_value;

    @Column(name = "reason", nullable = false, length = 255)
    private String reason;

    @Column(name = "changed_by", nullable = false)
    private Long changed_by;

    @Column(name = "changed_at", nullable = false)
    private LocalDateTime changed_at;

    @PrePersist
    protected void onCreate() {
        this.changed_at = LocalDateTime.now();
    }

    // 기존 camelCase 접근자를 위한 메서드들
    public Product getProduct() { return product_id; }
    public void setProduct(Product product) { this.product_id = product; }

    public String getFieldName() { return field_name; }
    public void setFieldName(String field_name) { this.field_name = field_name; }

    public String getOldValue() { return old_value; }
    public void setOldValue(String old_value) { this.old_value = old_value; }

    public String getNewValue() { return new_value; }
    public void setNewValue(String new_value) { this.new_value = new_value; }

    public Long getChangedBy() { return changed_by; }
    public void setChangedBy(Long changed_by) { this.changed_by = changed_by; }

    public LocalDateTime getChangedAt() { return changed_at; }
    public void setChangedAt(LocalDateTime changed_at) { this.changed_at = changed_at; }
}
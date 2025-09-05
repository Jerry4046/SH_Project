package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "product_code_tb")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductCode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "company_code", nullable = false, length = 4)
    private String companyCode;

    @Column(name = "type_code", nullable = false, length = 4)
    private String typeCode;

    @Column(name = "category_code", nullable = false, length = 4)
    private String categoryCode;

    @Column(name = "product_number", nullable = false)
    private Integer productNumber;

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

    @Transient
    public String getFullCode() {
        String number = String.format("%04d", productNumber);
        return String.join("_", companyCode, typeCode, categoryCode, number);
    }

    @Transient
    public String getFormattedNumber() {
        return String.format("%04d", productNumber);
    }
}
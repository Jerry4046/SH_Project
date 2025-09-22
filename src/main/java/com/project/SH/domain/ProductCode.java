package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "product_code_tb",
        uniqueConstraints = @UniqueConstraint(columnNames = {"company_code", "type_code", "category_code"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductCode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_code_id")
    private Long id;

    @Column(name = "company_code", nullable = false, length = 4)
    private String companyCode;

    @Column(name = "type_code", nullable = false, length = 4)
    private String typeCode;

    @Column(name = "category_code", nullable = false, length = 4)
    private String categoryCode;

    @Column(name = "description", nullable = true, length = 255)
    private String description;

    @Transient
    public String getProductCode() {
        return String.join("_", companyCode, typeCode, categoryCode);
    }
}
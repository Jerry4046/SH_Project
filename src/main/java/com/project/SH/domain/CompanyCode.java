package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "company_code_tb")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CompanyCode {
    @Id
    @Column(name = "company_code", length = 4)
    private String companyCode;

    @Column(name = "company_name", nullable = false, length = 50)
    private String companyName;
}
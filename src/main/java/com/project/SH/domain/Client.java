package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "client_tb", indexes = {
        @Index(name = "idx_client_company_initial", columnList = "company_initial"),
        @Index(name = "idx_client_branch_name", columnList = "branch_name")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "client_id")
    private Long clientId;

    @Column(name = "client_code", length = 10)
    private String clientCode;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "company_initial", referencedColumnName = "company_code")
    private CompanyCode company;

    @Column(name = "manager_name", nullable = false, length = 50)
    private String managerName;

    @Column(name = "branch_name", length = 100)
    private String branchName;

    @Column(name = "agency_name", length = 100)
    private String agencyName;

    @Column(length = 255)
    private String address;

    @Column(name = "manager_phone", length = 20)
    private String managerPhone;

    @Column(name = "regional_phone", length = 20)
    private String regionalPhone;

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
}
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

    @Column(name = "company_initial", nullable = false, length = 20)
    private String companyInitial;

    @Column(name = "company_name", nullable = false, length = 100)
    private String companyName;

    @Column(name = "branch_name", nullable = false, length = 100)
    private String branchName;

    @Column(length = 20)
    private String phone;

    @Column(length = 50)
    private String ceo;

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
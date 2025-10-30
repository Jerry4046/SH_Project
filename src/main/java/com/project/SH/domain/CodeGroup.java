package com.project.SH.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "code_group_tb")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CodeGroup {

    @Id
    @Column(name = "group_code", length = 20, nullable = false)
    private String groupCode;

    @Column(name = "group_name", length = 50, nullable = false)
    private String groupName;

    @Column(name = "description", length = 200)
    private String description;

    @Column(name = "is_active", nullable = false)
    private boolean active;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
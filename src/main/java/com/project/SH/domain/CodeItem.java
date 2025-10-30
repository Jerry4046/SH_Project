package com.project.SH.domain;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "code_item_tb")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CodeItem {

    @EmbeddedId
    private CodeItemId id;

    @MapsId("groupCode")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "group_code", nullable = false)
    private CodeGroup group;

    @Column(name = "code_name", length = 100, nullable = false)
    private String codeLabel;

    @Column(name = "is_active", nullable = false)
    private boolean active;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public String getGroupCode() {
        return id != null ? id.getGroupCode() : null;
    }

    public String getCode() {
        return id != null ? id.getCode() : null;
    }
}
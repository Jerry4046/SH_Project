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

@Entity
@Table(name = "type_code")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TypeCode {

    @Id
    @Column(name = "type_code", length = 10)
    private String typeCode;

    @Column(name = "type_name", nullable = false, length = 100)
    private String typeName;
}

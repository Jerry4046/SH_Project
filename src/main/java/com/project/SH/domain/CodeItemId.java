package com.project.SH.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class CodeItemId implements Serializable {

    @Column(name = "group_code", length = 20, nullable = false)
    private String groupCode;

    @Column(name = "code", length = 30, nullable = false)
    private String code;
}
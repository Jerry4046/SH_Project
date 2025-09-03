package com.project.SH.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "account_tb")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long seq;

    @Column(nullable = false, unique = true, length = 50)
    private String uuid;

    @Column(nullable = false, length = 10)
    private String name;

    @Column(nullable = false, length = 100)
    private String password;

    @Column(length = 3)
    private String grade = "N";

    @Column
    private Integer situation = 0;


}

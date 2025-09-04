package com.project.SH.repository;

import com.project.SH.domain.ProductCode;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductCodeRepository extends JpaRepository<ProductCode, Long> {
}
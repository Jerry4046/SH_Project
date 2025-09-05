package com.project.SH.repository;

import com.project.SH.domain.ProductCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ProductCodeRepository extends JpaRepository<ProductCode, Long> {
    @Query("SELECT COALESCE(MAX(CAST(pc.productNumber AS int)), 0) FROM ProductCode pc")
    int findMaxProductNumber();
}
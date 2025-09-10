package com.project.SH.repository;

import com.project.SH.domain.ProductChangeHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductChangeHistoryRepository extends JpaRepository<ProductChangeHistory, Long> {
}
package com.project.SH.repository;

import com.project.SH.domain.Product;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    boolean existsByProductCode(String productCode);

    Product findByProductCode(String productCode);

    List<Product> findAll(Sort sort);

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.prices")
    List<Product> findAllWithPrices();
}
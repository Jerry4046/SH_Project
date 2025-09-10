package com.project.SH.repository;

import com.project.SH.domain.Product;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.data.repository.query.Param;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    boolean existsByProductCode(String productCode);

    Product findByProductCode(String productCode);

    List<Product> findAll(Sort sort);

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.prices LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user")
    List<Product> findAllWithPricesAndStock();

    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user WHERE p.productCode = :productCode")
    Product findByProductCodeWithStock(@Param("productCode") String productCode);

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user " +
            "WHERE p.productCode LIKE %:keyword% " +
            "OR p.itemCode LIKE %:keyword% " +
            "OR p.spec LIKE %:keyword% " +
            "OR p.pdName LIKE %:keyword%")
    List<Product> searchAllByKeyword(@Param("keyword") String keyword);
}
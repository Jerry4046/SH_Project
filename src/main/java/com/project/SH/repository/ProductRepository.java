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

    @Query("SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END FROM Product p WHERE p.product_code = :productCode")
    boolean existsByProductCode(@Param("productCode") String productCode);

    @Query("SELECT p FROM Product p WHERE p.product_code = :productCode")
    Product findByProductCode(@Param("productCode") String productCode);

    List<Product> findAll(Sort sort);

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.prices LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user")
    List<Product> findAllWithPricesAndStock();

    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user WHERE p.product_code = :productCode")
    Product findByProductCodeWithStock(@Param("productCode") String productCode);

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user " +
            "WHERE p.product_code LIKE %:keyword% " +
            "OR p.item_code LIKE %:keyword% " +
            "OR p.spec LIKE %:keyword% " +
            "OR p.pd_name LIKE %:keyword%")
    List<Product> searchAllByKeyword(@Param("keyword") String keyword);
}
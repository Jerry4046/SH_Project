package com.project.SH.repository;

import com.project.SH.domain.Product;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    @Query("SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END " +
            "FROM Product p " +
            "WHERE p.product_code = :productCode " +
            "AND ((:itemCode IS NULL AND p.item_code IS NULL) OR p.item_code = :itemCode)")
    boolean existsByProductCodeAndItemCode(@Param("productCode") String productCode,
                                           @Param("itemCode") String itemCode);

    @Query(value = "SELECT * FROM product_tb WHERE product_code = :productCode ORDER BY item_code DESC LIMIT 1",
            nativeQuery = true)
    Optional<Product> findTopByProductCodeOrderByItemCodeDesc(@Param("productCode") String productCode);

    List<Product> findAll(Sort sort);

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.prices LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user")
    List<Product> findAllWithPricesAndStock();

    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user " +
            "WHERE p.product_code = :productCode AND p.item_code = :itemCode")
    Product findByProductCodeAndItemCodeWithStock(@Param("productCode") String productCode,
                                                  @Param("itemCode") String itemCode);

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.stock LEFT JOIN FETCH p.user " +
            "WHERE p.product_code LIKE %:keyword% " +
            "OR p.item_code LIKE %:keyword% " +
            "OR CONCAT(p.product_code, '_', COALESCE(p.item_code, '')) LIKE %:keyword% " +
            "OR p.spec LIKE %:keyword% " +
            "OR p.pd_name LIKE %:keyword%")
    List<Product> searchAllByKeyword(@Param("keyword") String keyword);
}
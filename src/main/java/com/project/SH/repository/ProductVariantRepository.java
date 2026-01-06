package com.project.SH.repository;

import com.project.SH.domain.ProductVariant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductVariantRepository extends JpaRepository<ProductVariant, Long> {

    @Query("SELECT v FROM ProductVariant v WHERE v.product.product_id = :productId")
    List<ProductVariant> findByProductId(@Param("productId") Long productId);

    @Query("SELECT v FROM ProductVariant v WHERE v.product.product_id = :productId AND v.piecesPerBox = :piecesPerBox")
    Optional<ProductVariant> findByProductIdAndPiecesPerBox(@Param("productId") Long productId, @Param("piecesPerBox") Integer piecesPerBox);

    @Query("SELECT COALESCE(SUM(v.subTotalQty), 0) FROM ProductVariant v WHERE v.product.product_id = :productId")
    Integer sumSubTotalByProductId(@Param("productId") Long productId);

    @Modifying
    @Query("DELETE FROM ProductVariant v WHERE v.product.product_id = :productId")
    void deleteByProductId(@Param("productId") Long productId);

    @Query("SELECT CASE WHEN COUNT(v) > 0 THEN true ELSE false END FROM ProductVariant v WHERE v.product.product_id = :productId AND v.piecesPerBox = :piecesPerBox")
    boolean existsByProductIdAndPiecesPerBox(@Param("productId") Long productId, @Param("piecesPerBox") Integer piecesPerBox);

    @Query("SELECT v FROM ProductVariant v JOIN FETCH v.product WHERE v.product.product_id = :productId")
    List<ProductVariant> findByProductIdWithProduct(@Param("productId") Long productId);
}

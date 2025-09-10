package com.project.SH.service;

import com.project.SH.domain.Product;
import java.util.List;

public interface ProductServiceImpl {

    void registerProduct(Product product, Double price, Integer piecesPerBox, Integer totalQty, Long accountSeq);
    List<Product> getAllProducts();
    Product getProductByCode(String productCode);

    void updateProduct(String originalProductCode, Product updatedProduct,
                       Integer piecesPerBox, Integer totalQty, Double price,
                       Long accountSeq, String reason, boolean isAdmin);

}

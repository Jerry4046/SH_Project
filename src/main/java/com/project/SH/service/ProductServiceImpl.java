package com.project.SH.service;

import com.project.SH.domain.Product;
import java.util.List;
import org.springframework.web.multipart.MultipartFile;

public interface ProductServiceImpl {

    void registerProduct(Product product, Double price, Integer piecesPerBox, Integer shQty, Integer hpQty,
                         Long accountSeq, MultipartFile productImage);
    List<Product> getAllProducts();
    Product getProductByCode(String productCode, String itemCode);

    void updateProduct(String originalProductCode, String originalItemCode, Product updatedProduct,
                       Integer piecesPerBox, Integer shQty, Integer hpQty, Double price,
                       Long accountSeq, String reason, boolean isAdmin);


}
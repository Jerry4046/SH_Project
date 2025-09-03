package com.project.SH.service;

import com.project.SH.domain.Product;
import java.util.List;

public interface ProductServiceImpl {

    void registerProduct(Product product, String accountUuid);  // accountUuid를 인자로 추가
    List<Product> getAllProducts();

}



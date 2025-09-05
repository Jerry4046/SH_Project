package com.project.SH.service;

import com.project.SH.domain.ProductCode;
import java.util.List;

public interface ProductCodeServiceImpl {
    List<ProductCode> getAllProductCodes();

    ProductCode createProductCode(String companyCode, String typeCode, String categoryCode);
}
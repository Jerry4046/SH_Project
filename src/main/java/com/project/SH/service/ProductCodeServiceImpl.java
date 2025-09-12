package com.project.SH.service;

import com.project.SH.domain.ProductCode;
import java.util.List;

public interface ProductCodeServiceImpl {
    List<ProductCode> getAllProductCodes();

    ProductCode createProductCode(String companyCode, String typeCode, String categoryCode);

    List<ProductCode> getCompanies();

    List<ProductCode> getTypesByCompanyInitial(String companyInitial);

    List<ProductCode> getCategoriesByCompanyInitialAndTypeCode(String companyInitial, String typeCode);

    java.util.Map<String, String> getCompanyNameMap();

    java.util.Map<String, String> getTypeNameMap();

    java.util.Map<String, String> getCategoryNameMap();
}
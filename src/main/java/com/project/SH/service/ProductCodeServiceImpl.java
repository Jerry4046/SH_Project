package com.project.SH.service;

import com.project.SH.domain.CompanyCode;
import com.project.SH.domain.ProductCode;
import com.project.SH.dto.NextItemCodeResponse;
import java.util.List;


public interface ProductCodeServiceImpl {
    List<ProductCode> getAllProductCodes();

    ProductCode createProductCode(String companyCode, String typeCode, String categoryCode, String description);

    List<CompanyCode> getCompanies();

    List<ProductCode> getTypesByCompanyCode(String companyCode);

    List<ProductCode> getCategoriesByCompanyCodeAndTypeCode(String companyCode, String typeCode);

    java.util.Map<String, String> getCompanyNameMap();

    java.util.Map<String, String> getTypeNameMap();

    java.util.Map<String, String> getCategoryNameMap();

    String getNextItemCodeForBase(String productCode);

    NextItemCodeResponse previewNextItemCode(String companyCode, String typeCode, String categoryCode);

    String buildFullProductCode(String productCode, String itemCode);
}
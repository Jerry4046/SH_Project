package com.project.SH.service;

import com.project.SH.domain.ProductCode;
import com.project.SH.repository.ProductCodeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProductCodeService implements ProductCodeServiceImpl {

    private final ProductCodeRepository productCodeRepository;

    @Override
    public List<ProductCode> getAllProductCodes() {
        return productCodeRepository.findAll();
    }

    @Override
    public ProductCode createProductCode(String companyCode, String typeCode, String categoryCode) {
        return productCodeRepository
                .findByCompanyInitialAndTypeCodeAndCategoryCode(companyCode, typeCode, categoryCode)
                .orElseGet(() -> productCodeRepository.save(ProductCode.builder()
                        .companyInitial(companyCode)
                        .typeCode(typeCode)
                        .categoryCode(categoryCode)
                        .build()));
    }

    @Override
    public List<ProductCode> getCompanies() {
        return productCodeRepository.findByTypeCodeAndCategoryCode("0000", "0000");
    }

    @Override
    public List<ProductCode> getTypesByCompanyInitial(String companyInitial) {
        return productCodeRepository.findByCompanyInitialAndCategoryCode(companyInitial, "0000");
    }

    @Override
    public List<ProductCode> getCategoriesByCompanyInitialAndTypeCode(String companyInitial, String typeCode) {
        return productCodeRepository.findByCompanyInitialAndTypeCodeAndCategoryCodeNot(companyInitial, typeCode, "0000");
    }

    @Override
    public Map<String, String> getCompanyNameMap() {
        List<ProductCode> companies = getCompanies();
        Map<String, String> map = new LinkedHashMap<>();
        for (ProductCode c : companies) {
            map.putIfAbsent(c.getCompanyInitial(), c.getDescription());
        }
        return map;
    }

    @Override
    public Map<String, String> getTypeNameMap() {
        List<ProductCode> types = productCodeRepository.findByCategoryCode("0000");
        Map<String, String> map = new LinkedHashMap<>();
        for (ProductCode t : types) {
            if (!"0000".equals(t.getTypeCode())) {
                map.putIfAbsent(t.getTypeCode(), t.getDescription());
            }
        }
        return map;
    }

    @Override
    public Map<String, String> getCategoryNameMap() {
        List<ProductCode> categories = productCodeRepository.findByCategoryCodeNot("0000");
        Map<String, String> map = new LinkedHashMap<>();
        for (ProductCode cat : categories) {
            map.putIfAbsent(cat.getCategoryCode(), cat.getDescription());
        }
        return map;
    }
}
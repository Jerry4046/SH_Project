package com.project.SH.service;

import com.project.SH.domain.CompanyCode;
import com.project.SH.domain.ProductCode;
import com.project.SH.repository.CompanyCodeRepository;
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
    private final CompanyCodeRepository companyCodeRepository;

    @Override
    public List<ProductCode> getAllProductCodes() {
        return productCodeRepository.findAll();
    }

    @Override
    public ProductCode createProductCode(String companyCode, String typeCode, String categoryCode, String description) {
        companyCodeRepository.findById(companyCode)
                .orElseGet(() -> companyCodeRepository.save(CompanyCode.builder()
                        .companyCode(companyCode)
                        .companyName(description != null ? description : companyCode)
                        .build()));

        return productCodeRepository
                .findByCompanyCodeAndTypeCodeAndCategoryCode(companyCode, typeCode, categoryCode)
                .orElseGet(() -> productCodeRepository.save(ProductCode.builder()
                        .companyCode(companyCode)
                        .typeCode(typeCode)
                        .categoryCode(categoryCode)
                        .description(description)
                        .build()));
    }

    @Override
    public List<CompanyCode> getCompanies() {
        // DB가 반환한 회사 코드를 이름순으로 정렬해서 전달
        // (값이 비어 보이는 문제를 줄이기 위해 명시적으로 정렬 사용)
        return companyCodeRepository.findAll(org.springframework.data.domain.Sort.by("companyName"));
    }

    @Override
    public List<ProductCode> getTypesByCompanyCode(String companyCode) {
        return productCodeRepository.findByCompanyCodeAndCategoryCode(companyCode, "0000");
    }

    @Override
    public List<ProductCode> getCategoriesByCompanyCodeAndTypeCode(String companyCode, String typeCode) {
        return productCodeRepository.findByCompanyCodeAndTypeCodeAndCategoryCodeNot(companyCode, typeCode, "0000");
    }

    @Override
    public Map<String, String> getCompanyNameMap() {
        List<CompanyCode> companies = getCompanies();
        Map<String, String> map = new LinkedHashMap<>();
        for (CompanyCode c : companies) {
            map.putIfAbsent(c.getCompanyCode(), c.getCompanyName());
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
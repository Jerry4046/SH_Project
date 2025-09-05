package com.project.SH.service;

import com.project.SH.domain.ProductCode;
import com.project.SH.repository.ProductCodeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

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
        int nextNumber = productCodeRepository.findMaxProductNumber() + 1;
        String formattedNumber = String.format("%04d", nextNumber);
        String fullCode = String.join("_", companyCode, typeCode, categoryCode, formattedNumber);
        ProductCode code = ProductCode.builder()
                .companyCode(companyCode)
                .typeCode(typeCode)
                .categoryCode(categoryCode)
                .productNumber(formattedNumber)
                .productCode(fullCode)
                .build();
        return productCodeRepository.save(code);
    }
}
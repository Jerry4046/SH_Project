package com.project.SH.controller;

import com.project.SH.domain.CompanyCode;
import com.project.SH.domain.ProductCode;
import com.project.SH.service.ProductCodeService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product-codes")
@RequiredArgsConstructor
public class ProductCodeApiController {

    private final ProductCodeService productCodeService;

    @GetMapping("/companies")
    public List<CompanyCode> getCompanies() {
        return productCodeService.getCompanies();
    }

    @GetMapping("/types")
    public List<ProductCode> getTypes(@RequestParam String companyCode) {
        return productCodeService.getTypesByCompanyCode(companyCode);
    }

    @GetMapping("/categories")
    public List<ProductCode> getCategories(@RequestParam String companyCode,
                                           @RequestParam String typeCode) {
        return productCodeService.getCategoriesByCompanyCodeAndTypeCode(companyCode, typeCode);
    }

    @PostMapping
    public ProductCode createCode(@RequestParam String companyCode,
                                  @RequestParam String typeCode,
                                  @RequestParam String categoryCode,
                                  @RequestParam(required = false) String description) {
        return productCodeService.createProductCode(companyCode, typeCode, categoryCode, description);
    }
}
package com.project.SH.controller;

import com.project.SH.domain.ProductCode;
import com.project.SH.service.ProductCodeService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/product-codes")
@RequiredArgsConstructor
public class ProductCodeApiController {

    private final ProductCodeService productCodeService;

    @GetMapping("/companies")
    public List<ProductCode> getCompanies() {
        return productCodeService.getCompanies();
    }

    @GetMapping("/types")
    public List<ProductCode> getTypes(@RequestParam String companyInitial) {
        return productCodeService.getTypesByCompanyInitial(companyInitial);
    }

    @GetMapping("/categories")
    public List<ProductCode> getCategories(@RequestParam String companyInitial,
                                           @RequestParam String typeCode) {
        return productCodeService.getCategoriesByCompanyInitialAndTypeCode(companyInitial, typeCode);
    }
}
package com.project.SH.controller;

import com.project.SH.domain.ProductCode;
import com.project.SH.service.ProductCodeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.List;


@Controller
@RequiredArgsConstructor
public class CodeController {

    private final ProductCodeService productCodeService;

    @GetMapping("/productcode")
    public String showProductList(Model model) {

        List<ProductCode> codes = productCodeService.getAllProductCodes();
        model.addAttribute("productCodes", codes);
        model.addAttribute("companyNames", productCodeService.getCompanyNameMap());
        model.addAttribute("typeNames", productCodeService.getTypeNameMap());
        model.addAttribute("categoryNames", productCodeService.getCategoryNameMap());
        return "productcode";  // /WEB-INF/views/productcode.jsp
    }

}
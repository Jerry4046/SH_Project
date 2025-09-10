package com.project.SH.controller;

import com.project.SH.config.CustomUserDetails;
import com.project.SH.domain.Product;
import com.project.SH.domain.ProductCode;
import com.project.SH.service.ProductCodeService;
import com.project.SH.service.ProductService;
import com.project.SH.util.CodeNameMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;  // SLF4J 로그 추가
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;



@Controller
@RequiredArgsConstructor
@Slf4j
public class ProductController {

    private final ProductService productService;
    private final ProductCodeService productCodeService;

    @GetMapping("/product/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("companyNames", CodeNameMapper.getCompanyNames());
        model.addAttribute("typeNames", CodeNameMapper.getTypeNames());
        model.addAttribute("categoryNames", CodeNameMapper.getCategoryNames());
        return "productdetail";
    }


    @PostMapping("/product/register")
    public String registerProduct(@ModelAttribute Product product,
                                  @RequestParam Double price,
                                  @RequestParam String companyCode,
                                  @RequestParam String typeCode,
                                  @RequestParam String categoryCode,
                                  @RequestParam Integer piecesPerBox,
                                  @RequestParam Integer totalQty,
                                  @AuthenticationPrincipal CustomUserDetails userDetails,
                                  RedirectAttributes redirectAttributes) {
        log.info("상품 등록 시작(ProductController), 상품명: {}, 단가: {}, 상품코드: {} ", product.getPdName(), product.getPrice(), product.getProductCode());
        try {
            if (userDetails == null || userDetails.getUser() == null) {
                redirectAttributes.addFlashAttribute("error", "로그인이 필요합니다.");
                return "redirect:/login";
            }
            Long createdBySeq = userDetails.getUser().getSeq();
            log.info("현재 로그인된 사용자 번호: {}", createdBySeq);

            // 1) 상품코드 생성
            ProductCode code = productCodeService.createProductCode(companyCode, typeCode, categoryCode);
            product.setProductCode(code.getProductCode());

            // 2) account_seq 채우기
            product.setAccountSeq(createdBySeq);


            // 3) 저장
            productService.registerProduct(product, price, piecesPerBox, totalQty, createdBySeq);

            redirectAttributes.addFlashAttribute("message", "제품 등록 성공");
            log.info("상품 등록 성공, 상품 코드: {}", product.getProductCode());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            log.error("상품 등록 실패, 에러: {}", e.getMessage());
        }
        return "redirect:/inventory";
    }


    @GetMapping("/inventory")
    public String showProductList(Model model) {
        log.info("상품 목록 조회 시작");
        List<Product> products = productService.getAllProducts();
        model.addAttribute("productList", products);
        List<ProductCode> codes = productCodeService.getAllProductCodes();
        model.addAttribute("productCodes", codes);
        model.addAttribute("companyNames", CodeNameMapper.getCompanyNames());
        model.addAttribute("typeNames", CodeNameMapper.getTypeNames());
        model.addAttribute("categoryNames", CodeNameMapper.getCategoryNames());
        log.info("상품 목록 조회 완료, 상품 수: {}", products.size());
        return "inventory";  // /WEB-INF/views/inventory.jsp
    }

    @GetMapping("/product")
    public String showProductCodes(Model model) {
        List<ProductCode> codes = productCodeService.getAllProductCodes();
        model.addAttribute("productCodes", codes);
        model.addAttribute("companyNames", CodeNameMapper.getCompanyNames());
        model.addAttribute("typeNames", CodeNameMapper.getTypeNames());
        model.addAttribute("categoryNames", CodeNameMapper.getCategoryNames());
        List<Product> products = productService.getAllProducts();
        model.addAttribute("productList", products);
        return "product";
    }


    @GetMapping("/product/detail/{productCode}")
    public String showProductDetail(@PathVariable String productCode, Model model) {
        Product product = productService.getProductByCode(productCode);
        model.addAttribute("product", product);
        return "productdetail";
    }

    @GetMapping("/product/details")
    public String showAllProductDetails(@RequestParam(required = false) String keyword, Model model) {
        List<Product> products;
        if (keyword != null && !keyword.isBlank()) {
            products = productService.searchProducts(keyword);
        } else {
            products = productService.getAllProducts();
        }
        model.addAttribute("productList", products);
        model.addAttribute("keyword", keyword);
        return "productdetailall";
    }

    public class ProductRow {
        private LocalDateTime createdAt;
        public String getCreatedAtStr() {
            return createdAt == null ? "" :
                    createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        }
    }
}
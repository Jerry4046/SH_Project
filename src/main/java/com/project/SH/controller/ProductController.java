package com.project.SH.controller;

import com.project.SH.config.CustomUserDetails;
import com.project.SH.domain.Product;
import com.project.SH.domain.ProductCode;
import com.project.SH.service.ProductCodeService;
import com.project.SH.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;  // SLF4J 로그 추가
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;



@Controller
@RequiredArgsConstructor
@Slf4j
public class ProductController {

    private final ProductService productService;
    private final ProductCodeService productCodeService;

    @GetMapping("/product/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("companyNames", productCodeService.getCompanyNameMap());
        model.addAttribute("typeNames", productCodeService.getTypeNameMap());
        model.addAttribute("categoryNames", productCodeService.getCategoryNameMap());
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
            ProductCode code = productCodeService.createProductCode(companyCode, typeCode, categoryCode, null);
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
        log.info("상품 목록 조회 완료, 상품 수: {}", products.size());
        return "inventory";  // /WEB-INF/views/inventory.jsp
    }

    @GetMapping("/product")
    public String showProductCodes(Model model) {
        log.info("상품코드 및 목록 페이지 조회 시작");
        List<ProductCode> codes = productCodeService.getAllProductCodes();
        List<Product> products = productService.getAllProducts();
        model.addAttribute("productList", products);
        log.info("상품코드 및 목록 페이지 조회 완료, 코드 수: {}, 상품 수: {}", codes.size(), products.size());
        return "product";
    }


    @GetMapping("/product/detail/{productCode}")
    public String showProductDetail(@PathVariable String productCode, Model model) {
        log.info("단일 상품 상세 조회, 상품 코드: {}", productCode);
        Product product = productService.getProductByCode(productCode);
        model.addAttribute("product", product);
        return "productdetail";
    }

    @GetMapping("/product/details")
    public String showAllProductDetails(@RequestParam(required = false) String keyword, Model model) {
        log.info("상품 상세 목록 조회 시작, 검색어: {}", keyword);
        List<Product> products;
        if (keyword != null && !keyword.isBlank()) {
            products = productService.searchProducts(keyword);
        } else {
            products = productService.getAllProducts();
        }
        model.addAttribute("productList", products);
        model.addAttribute("keyword", keyword);
        log.info("상품 상세 목록 조회 완료, 상품 수: {}", products.size());
        return "productdetailall";
    }

    @PostMapping("/product/update")
    public String updateProduct(@RequestParam("originalCode") String originalCode,
                                @ModelAttribute Product updatedProduct,
                                @RequestParam(required = false) Integer piecesPerBox,
                                @RequestParam(required = false) Integer boxQty,
                                @RequestParam(required = false) Integer looseQty,
                                @RequestParam(required = false) Integer totalQty,
                                @RequestParam(required = false) Double price,
                                @RequestParam String reason,
                                @AuthenticationPrincipal CustomUserDetails userDetails,
                                RedirectAttributes redirectAttributes) {
        if (userDetails == null || userDetails.getUser() == null) {
            redirectAttributes.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        Long seq = userDetails.getUser().getSeq();
        log.info("상품 수정 요청, 원본 코드: {}, 관리자 여부: {}, 요청자: {}", originalCode, isAdmin, seq);
        log.debug("수정 파라미터 - piecesPerBox: {}, boxQty: {}, looseQty: {}, totalQty: {}, price: {}", piecesPerBox, boxQty, looseQty, totalQty, price);
        if (piecesPerBox != null && boxQty != null) {
            int loose = looseQty != null ? looseQty : 0;
            totalQty = boxQty * piecesPerBox + loose;
            log.info("총재고 계산 완료 - boxQty: {}, looseQty: {}, piecesPerBox: {}, 계산된 totalQty: {}", boxQty, looseQty, piecesPerBox, totalQty);
        }
        try {
            productService.updateProduct(originalCode, updatedProduct, piecesPerBox, totalQty, price, seq, reason, isAdmin);
            redirectAttributes.addFlashAttribute("message", "수정 완료");
            log.info("상품 수정 완료, 코드: {}", originalCode);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            log.error("상품 수정 실패, 코드: {}, 에러: {}", originalCode, e.getMessage());
        }
        return "redirect:/inventory";
    }

    public class ProductRow {
        private LocalDateTime createdAt;
        public String getCreatedAtStr() {
            return createdAt == null ? "" :
                    createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        }
    }
}
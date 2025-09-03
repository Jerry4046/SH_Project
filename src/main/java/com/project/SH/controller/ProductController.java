package com.project.SH.controller;

import com.project.SH.config.CustomUserDetails;
import com.project.SH.domain.Product;
import com.project.SH.service.PriceService;
import com.project.SH.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;  // SLF4J 로그 추가
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class ProductController {

    private final ProductService productService;
    private final PriceService priceService;

    @PostMapping("/product/register")
    public String registerProduct(@ModelAttribute Product product,
                                  @RequestParam Double price,
                                  @AuthenticationPrincipal CustomUserDetails userDetails,
                                  RedirectAttributes redirectAttributes) {
        log.info("상품 등록 시작, 상품 코드: {}, 상품명: {}", product.getProductCode(), product.getPdName());
        try {
            // 현재 로그인된 사용자 정보를 받아옴
            String createdByUuid = userDetails.getUser().getUuid();
            log.info("현재 로그인된 사용자 UUID: {}", createdByUuid);

            // 상품 등록
            productService.registerProduct(product, createdByUuid);

            // 가격 등록
            priceService.registerPrice(product, price, createdByUuid);

            redirectAttributes.addFlashAttribute("message", "제품 등록 성공");
            log.info("상품 등록 성공, 상품 코드: {}", product.getProductCode());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            log.error("상품 등록 실패, 상품 코드: {}, 에러: {}", product.getProductCode(), e.getMessage());
        }
        return "redirect:/inventory";  // 목록 페이지로 리다이렉트
    }

    @GetMapping("/inventory")
    public String showProductList(Model model) {
        log.info("상품 목록 조회 시작");
        List<Product> products = productService.getAllProducts();
        model.addAttribute("productList", products);
        log.info("상품 목록 조회 완료, 상품 수: {}", products.size());
        return "inventory";  // /WEB-INF/views/inventory.jsp
    }
}

package com.project.SH.controller;

import com.project.SH.domain.Product;
import com.project.SH.service.ProductService;
import com.project.SH.service.PriceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j  // SLF4J 로그 추가
public class PriceController {

    private final ProductService productService;
    private final PriceService priceService;

    // 가격 페이지 출력 (상품과 가격 목록)
    @GetMapping("/price")
    public String showPriceList(Model model) {
        log.info("가격 페이지 출력 요청");

        try {
            log.info("상품 목록 조회 시작");
            // 모든 상품과 연관된 가격 정보 조회
            List<Product> products = productService.getAllProducts();  // 모든 상품 조회
            model.addAttribute("productList", products);  // 모델에 상품 목록 추가

            log.info("상품 목록 조회 완료, 상품 수: {}", products.size());  // 상품 목록 수 출력
        } catch (Exception e) {
            log.error("가격 페이지 조회 중 오류 발생: {}", e.getMessage());  // 오류 로그
        }

        return "price";  // price.jsp 페이지로 전달
    }
}

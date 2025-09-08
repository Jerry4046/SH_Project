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

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class ProductController {

    private final ProductService productService;
    private final ProductCodeService productCodeService;

    @PostMapping("/product/register")
    public String registerProduct(@ModelAttribute Product product,
                                  @RequestParam Double price,
                                  @RequestParam String companyCode,
                                  @RequestParam String typeCode,
                                  @RequestParam String categoryCode,
                                  @AuthenticationPrincipal CustomUserDetails userDetails,
                                  RedirectAttributes redirectAttributes) {
        log.info("상품 등록 시작, 상품 코드: {}, 상품명: {}, 총재고: {}", product.getProductCode(), product.getPdName(), product.getTotalQty());
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

            // 2) 재고 입력 값 정규화 (NULL 방지)
            Integer ppb = product.getPiecesPerBox() == null ? 1 : product.getPiecesPerBox();
            Integer box = product.getBoxQty() == null ? 0 : product.getBoxQty();
            Integer loose = product.getLooseQty() == null ? 0 : product.getLooseQty();
            product.setPiecesPerBox(ppb);
            product.setBoxQty(box);
            product.setLooseQty(loose);
            // total_qty는 생성 컬럼이므로 set하지 않습니다.

            // 3) 가장 중요: account_seq 채우기
            product.setAccountSeq(createdBySeq);

            // 4) 저장 (한 번만!)
            productService.registerProduct(product, price, createdBySeq);

            redirectAttributes.addFlashAttribute("message", "제품 등록 성공");
            log.info("상품 등록 성공, 상품 코드: {}, 총재고: {}", product.getProductCode(), product.getTotalQty());
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
}
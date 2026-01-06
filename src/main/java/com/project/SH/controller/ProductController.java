package com.project.SH.controller;

import com.project.SH.config.CustomUserDetails;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.SH.domain.CompanyCode;
import com.project.SH.domain.Product;
import com.project.SH.domain.ProductCode;
import com.project.SH.domain.ProductVariant;
import com.project.SH.service.ImageStorageService;
import com.project.SH.service.ProductCodeService;
import com.project.SH.service.ProductService;
import com.project.SH.domain.CodeItem;
import com.project.SH.service.CodeItemService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;  // SLF4J 로그 추가
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;



@Controller
@RequiredArgsConstructor
@Slf4j
public class ProductController {

    private static final String COMPANY_CODE_GROUP = "PD_CP";
    private static final String TYPE_CODE_GROUP = "PD_TY";
    private static final String CATEGORY_CODE_GROUP = "PD_CT";

    private final ProductService productService;
    private final ProductCodeService productCodeService;
    private final ImageStorageService imageStorageService;
    private final CodeItemService codeItemService;

    @GetMapping("/product/register")
    public String showRegisterForm(Model model) {
        List<CodeItem> companyCodes = codeItemService.search(COMPANY_CODE_GROUP, null, true);
        List<CodeItem> typeCodes = codeItemService.search(TYPE_CODE_GROUP, null, true);
        List<CodeItem> categoryCodes = codeItemService.search(CATEGORY_CODE_GROUP, null, true);

        model.addAttribute("companyCodes", companyCodes);
        model.addAttribute("typeCodes", typeCodes);
        model.addAttribute("categoryCodes", categoryCodes);

        Map<String, Object> lookup = buildCodeLookup(companyCodes, typeCodes, categoryCodes);
        model.addAttribute("codeHierarchyJson", writeHierarchyJson(lookup));
        return "productdetail";
    }


    @PostMapping("/product/register")
    public String registerProduct(@ModelAttribute Product product,
                                  @RequestParam Double price,
                                  @RequestParam String companyCode,
                                  @RequestParam String typeCode,
                                  @RequestParam String categoryCode,
                                  @RequestParam Integer piecesPerBox,
                                  @RequestParam Integer shQty,
                                  @RequestParam Integer hpQty,
                                  @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                  @AuthenticationPrincipal CustomUserDetails userDetails,
                                  RedirectAttributes redirectAttributes) {
        log.info("상품 등록 시작(ProductController), 제품명: {}, 단가: {}, 기본코드: {} ", product.getPdName(), price, product.getProductCode());
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
            productService.registerProduct(product, price, piecesPerBox, shQty, hpQty, createdBySeq, imageFile);

            redirectAttributes.addFlashAttribute("message", "제품 등록 성공");
            log.info("상품 등록 성공, 상품 코드: {}", product.getFullProductCode());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "관리자에 문의하시오");
            log.error("상품 등록 실패, 에러: {}", e.getMessage());
        }
        return "redirect:/inventory";
    }


    @GetMapping("/inventory")
    public String showProductList(Model model) {
        log.info("상품 목록 조회 시작");
        List<Product> products = productService.getAllProducts();
        model.addAttribute("productList", products);
        model.addAttribute("productImageUrls", buildProductImageMap(products));
        model.addAttribute("productVariantsMap", buildProductVariantsMap(products));
        log.info("상품 목록 조회 완료, 상품 수: {}", products.size());
        return "inventory";  // /WEB-INF/views/inventory.jsp
    }

    @GetMapping("/product")
    public String showProductCodes(Model model) {
        log.info("상품코드 및 목록 페이지 조회 시작");
        List<ProductCode> codes = productCodeService.getAllProductCodes();
        List<Product> products = productService.getAllProducts();
        List<CompanyCode> companies = productCodeService.getCompanies();

        Map<String, CompanyHierarchy> hierarchy = buildCompanyHierarchy(companies, codes);
        String hierarchyJson = writeHierarchyJson(hierarchy);

        model.addAttribute("companies", companies);
        model.addAttribute("productList", products);
        model.addAttribute("codeHierarchyJson", hierarchyJson);
        log.info("상품코드 및 목록 페이지 조회 완료, 코드 수: {}, 상품 수: {}", codes.size(), products.size());
        return "product";
    }


    @GetMapping("/product/detail/{productCode}")
    public String showProductDetail(@PathVariable String productCode,
                                    @RequestParam(value = "itemCode", required = false) String itemCode,
                                    Model model) {
        Product product = productService.getProductByCode(productCode, itemCode);
        if (product != null) {
            log.info("단일 상품 상세 조회, 상품 코드: {}", product.getProductCode());
            imageStorageService.findLatestImageUrlByProductName(product.getPdName())
                    .ifPresent(url -> model.addAttribute("productImageUrl", url));
        } else {
            String referenceCode = (itemCode == null || itemCode.isBlank())
                    ? productCode
                    : productCodeService.buildFullProductCode(productCode, itemCode);
            log.warn("단일 상품 상세 조회 실패, 요청 코드: {}", referenceCode);
        }
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
                                @RequestParam("originalItemCode") String originalItemCode,
                                @ModelAttribute Product updatedProduct,
                                @RequestParam(required = false) Integer piecesPerBox,
                                @RequestParam(required = false) Integer shQty,
                                @RequestParam(required = false) Integer hpQty,
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
        String originalFullCode = productCodeService.buildFullProductCode(originalCode, originalItemCode);
        log.info("상품 수정 요청, 원본 코드: {}, 관리자 여부: {}, 요청자: {}", originalFullCode, isAdmin, seq);
        log.debug("수정 파라미터 - piecesPerBox: {}, shQty: {}, hpQty: {}, price: {}",
                piecesPerBox, shQty, hpQty, price);
        try {
            productService.updateProduct(originalCode, originalItemCode, updatedProduct,
                    piecesPerBox, shQty, hpQty, totalQty, price, seq, reason, isAdmin);
            redirectAttributes.addFlashAttribute("message", "수정 완료");
            log.info("상품 수정 완료, 코드: {}", originalFullCode);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            log.error("상품 수정 실패, 코드: {}, 에러: {}", originalFullCode, e.getMessage());
        }
        return "redirect:/inventory";
    }

    private Map<String, CompanyHierarchy> buildCompanyHierarchy(List<CompanyCode> companies, List<ProductCode> codes) {
        Map<String, CompanyHierarchy> hierarchy = new LinkedHashMap<>();

        if (companies != null) {
            for (CompanyCode company : companies) {
                if (company == null) {
                    continue;
                }
                CompanyHierarchy companyHierarchy = hierarchy.computeIfAbsent(
                        company.getCompanyCode(),
                        key -> new CompanyHierarchy()
                );
                companyHierarchy.name = company.getCompanyName();
            }
        }

        if (codes == null || codes.isEmpty()) {
            return hierarchy;
        }

        Map<String, String> typeNames = new LinkedHashMap<>();
        for (ProductCode code : codes) {
            if (code == null) {
                continue;
            }
            String typeCode = code.getTypeCode();
            if ("0000".equals(code.getCategoryCode())
                    && typeCode != null && !typeCode.isBlank()
                    && !"0000".equals(typeCode)) {
                String key = code.getCompanyCode() + "|" + typeCode;
                String description = code.getDescription() != null ? code.getDescription() : typeCode;
                typeNames.putIfAbsent(key, description);
            }
        }

        for (ProductCode code : codes) {
            if (code == null) {
                continue;
            }
            CompanyHierarchy companyHierarchy = hierarchy.computeIfAbsent(code.getCompanyCode(), key -> {
                CompanyHierarchy data = new CompanyHierarchy();
                data.name = key;
                return data;
            });

            String typeCode = code.getTypeCode();
            String typeKey = typeCode == null ? null : code.getCompanyCode() + "|" + typeCode;
            String fallbackTypeName = (typeCode != null && !typeCode.isBlank()) ? typeCode : "";
            String typeName = typeNames.getOrDefault(typeKey, fallbackTypeName);

            if ("0000".equals(code.getCategoryCode())) {
                if (!"0000".equals(code.getTypeCode())) {
                    companyHierarchy.addTypeIfAbsent(code.getTypeCode(), typeName);
                }
            } else {
                String categoryName = code.getDescription() != null ? code.getDescription() : code.getCategoryCode();
                companyHierarchy.addTypeIfAbsent(code.getTypeCode(), typeName);
                companyHierarchy.addCategoryIfAbsent(code.getTypeCode(), code.getCategoryCode(), categoryName);
            }
        }

        return hierarchy;
    }

    
    private Map<Long, List<ProductVariant>> buildProductVariantsMap(List<Product> products) {
        Map<Long, List<ProductVariant>> variantsMap = new HashMap<>();
        for (Product product : products) {
            if (product == null) {
                continue;
            }
            Long productId = product.getProductId();
            if (productId == null) {
                continue;
            }
            List<ProductVariant> variants = productService.getVariantsByProductId(productId);
            if (variants != null && !variants.isEmpty()) {
                variantsMap.put(productId, variants);
            }
        }
        return variantsMap;
    }

    private Map<Long, String> buildProductImageMap(List<Product> products) {
        Map<Long, String> imageMap = new HashMap<>();
        for (Product product : products) {
            if (product == null) {
                continue;
            }
            Long productId = product.getProductId();
            if (productId == null) {
                continue;
            }
            Optional<String> imageUrl = imageStorageService.findLatestImageUrlByProductName(product.getPdName());
            imageUrl.ifPresent(url -> imageMap.put(productId, url));
        }
        return imageMap;
    }

    private String writeHierarchyJson(Object hierarchy) {
        try {
            return new ObjectMapper().writeValueAsString(hierarchy);
        } catch (JsonProcessingException e) {
            log.error("코드 계층 JSON 직렬화 실패", e);
            return "{}";
        }
    }

    private Map<String, Object> buildCodeLookup(List<CodeItem> companies,
                                                List<CodeItem> types,
                                                List<CodeItem> categories) {
        Map<String, Object> lookup = new LinkedHashMap<>();
        lookup.put("companyGroupCode", COMPANY_CODE_GROUP);
        lookup.put("typeGroupCode", TYPE_CODE_GROUP);
        lookup.put("categoryGroupCode", CATEGORY_CODE_GROUP);
        lookup.put("companies", toCodeNameList(companies));
        lookup.put("types", toCodeNameList(types));
        lookup.put("categories", toCodeNameList(categories));
        return lookup;
    }

    private List<CodeName> toCodeNameList(List<CodeItem> items) {
        if (items == null || items.isEmpty()) {
            return List.of();
        }
        List<CodeName> result = new ArrayList<>(items.size());
        for (CodeItem item : items) {
            if (item == null || item.getCode() == null || item.getCode().isBlank()) {
                continue;
            }
            result.add(new CodeName(item.getCode(), item.getCodeLabel()));
        }
        return result;
    }

    private static class CompanyHierarchy {
        public String name;
        public final List<CodeName> types = new ArrayList<>();
        public final Map<String, List<CodeName>> categories = new LinkedHashMap<>();

        public void addTypeIfAbsent(String code, String displayName) {
            if (code == null || code.isBlank() || "0000".equals(code)) {
                return;
            }
            boolean exists = types.stream().anyMatch(t -> t.code.equals(code));
            if (!exists) {
                types.add(new CodeName(code, displayName != null ? displayName : code));
            }
        }

        public void addCategoryIfAbsent(String typeCode, String categoryCode, String displayName) {
            if (typeCode == null || typeCode.isBlank() || categoryCode == null || categoryCode.isBlank()) {
                return;
            }
            List<CodeName> categoryList = categories.computeIfAbsent(typeCode, key -> new ArrayList<>());
            boolean exists = categoryList.stream().anyMatch(cat -> cat.code.equals(categoryCode));
            if (!exists) {
                categoryList.add(new CodeName(categoryCode, displayName != null ? displayName : categoryCode));
            }
        }
    }

    private static class CodeName {
        public final String code;
        public final String name;

        private CodeName(String code, String name) {
            this.code = code;
            this.name = name;
        }
    }
}
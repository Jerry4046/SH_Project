package com.project.SH.controller;

import com.project.SH.config.CustomUserDetails;
import com.project.SH.domain.ProductVariant;
import com.project.SH.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 제품 입수량별 변형(ProductVariant) 관리 REST API 컨트롤러
 */
@RestController
@RequestMapping("/api/products/{productId}/variants")
@RequiredArgsConstructor
@Slf4j
public class ProductVariantController {

    private final ProductService productService;

    /**
     * 제품의 변형 목록 조회
     */
    @GetMapping
    public ResponseEntity<List<ProductVariant>> getVariants(@PathVariable Long productId) {
        List<ProductVariant> variants = productService.getVariantsByProductId(productId);
        return ResponseEntity.ok(variants);
    }

    /**
     * 변형 추가
     */
    @PostMapping
    public ResponseEntity<?> addVariant(
            @PathVariable Long productId,
            @RequestBody Map<String, Integer> payload,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Integer piecesPerBox = payload.get("piecesPerBox");
        Integer boxQty = payload.getOrDefault("boxQty", 0);
        Integer looseQty = payload.getOrDefault("looseQty", 0);

        if (userDetails == null || userDetails.getUser() == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }

        try {
            ProductVariant variant = productService.addVariant(productId, piecesPerBox, boxQty, looseQty);
            log.info("변형 추가 완료 - productId: {}, piecesPerBox: {}, variantId: {}",
                    productId, piecesPerBox, variant.getVariantId());
            return ResponseEntity.ok(variant);
        } catch (IllegalStateException e) {
            log.warn("변형 추가 실패 - productId: {}, 사유: {}", productId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (IllegalArgumentException e) {
            log.warn("변형 추가 실패 - productId: {}, 사유: {}", productId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * 변형 수정
     */
    @PutMapping("/{variantId}")
    public ResponseEntity<?> updateVariant(
            @PathVariable Long productId,
            @PathVariable Long variantId,
            @RequestBody Map<String, Integer> payload,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Integer boxQty = payload.get("boxQty");
        Integer looseQty = payload.get("looseQty");

        if (userDetails == null || userDetails.getUser() == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }

        try {
            ProductVariant variant = productService.updateVariant(variantId, boxQty, looseQty);
            log.info("변형 수정 완료 - variantId: {}, boxQty: {}, looseQty: {}",
                    variantId, boxQty, looseQty);
            return ResponseEntity.ok(variant);
        } catch (IllegalArgumentException e) {
            log.warn("변형 수정 실패 - variantId: {}, 사유: {}", variantId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * 변형 삭제
     */
    @DeleteMapping("/{variantId}")
    public ResponseEntity<?> deleteVariant(
            @PathVariable Long productId,
            @PathVariable Long variantId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        if (userDetails == null || userDetails.getUser() == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }

        try {
            productService.deleteVariant(variantId);
            log.info("변형 삭제 완료 - variantId: {}", variantId);
            return ResponseEntity.ok(Map.of("message", "삭제 완료"));
        } catch (Exception e) {
            log.warn("변형 삭제 실패 - variantId: {}, 사유: {}", variantId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * 변형 합계 검증
     */
    @GetMapping("/validate")
    public ResponseEntity<Map<String, Object>> validateVariants(@PathVariable Long productId) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean isValid = productService.validateVariantSum(productId);
            Integer variantSum = productService.getVariantSum(productId);
            result.put("valid", isValid);
            result.put("variantSum", variantSum);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            result.put("valid", false);
            result.put("error", e.getMessage());
            return ResponseEntity.ok(result);
        }
    }
}

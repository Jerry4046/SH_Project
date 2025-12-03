package com.project.SH.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.project.SH.dto.PurchaseOrderSearchRequest;
import com.project.SH.service.EcountApiService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/ecount")
public class EcountController {

    private final EcountApiService ecountApiService;

    public EcountController(EcountApiService ecountApiService) {
        this.ecountApiService = ecountApiService;
    }

    // /api/ecount/session-id 로 GET 요청 → SESSION_ID 값만 문자열로 리턴
    @GetMapping("/session-id")
    public ResponseEntity<String> getSessionId() {
        String sessionId = ecountApiService.getSessionId();
        return ResponseEntity.ok(sessionId);
    }

    @GetMapping("/products")
    public ResponseEntity<JsonNode> getProduct(
            @RequestParam("prodCd") String prodCd,
            @RequestParam(value = "prodType", required = false) String prodType
    ) {
        JsonNode response = ecountApiService.viewBasicProduct(prodCd, prodType);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/purchase-orders")
    public ResponseEntity<JsonNode> getPurchaseOrders(@ModelAttribute PurchaseOrderSearchRequest request) {
        JsonNode response = ecountApiService.getPurchaseOrderList(
                request.baseDateFrom(),
                request.baseDateTo(),
                request.prodCd(),
                request.custCd(),
                request.pageCurrent(),
                request.pageSize()
        );

        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleBadRequest(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(ex.getMessage());
    }
}
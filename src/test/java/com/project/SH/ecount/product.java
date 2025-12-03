package com.project.SH.ecount;

import com.fasterxml.jackson.databind.JsonNode;
import com.project.SH.service.EcountApiService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class product {

    private static final Logger log = LoggerFactory.getLogger(product.class);

    @Autowired
    private EcountApiService ecountApiService;

    @Test
    @DisplayName("품목 코드로 기본 제품 정보를 조회한다")
    void viewBasicProduct() {
        JsonNode response = ecountApiService.viewBasicProduct("", null);

        log.info("제품 조회 응답: {}", response.toPrettyString());
        assertNotNull(response, "제품 조회 응답이 null이면 안 됩니다.");
    }
}
package com.project.SH.ecount;

import com.fasterxml.jackson.databind.JsonNode;
import com.project.SH.service.EcountApiService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class purchase {

    private static final Logger log = LoggerFactory.getLogger(purchase.class);
    private static final DateTimeFormatter YYYYMMDD = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Autowired
    private EcountApiService ecountApiService;

    @Test
    @DisplayName("최근 7일 발주서를 조회한다")
    void fetchPurchaseOrdersWithSession() {
        LocalDate today = LocalDate.now();
        LocalDate sevenDaysAgo = today.minusDays(7);

        String baseDateFrom = sevenDaysAgo.format(YYYYMMDD);
        String baseDateTo = today.format(YYYYMMDD);

        JsonNode response = ecountApiService.getPurchaseOrderList(
                baseDateFrom,
                baseDateTo,
                "",
                "",
                null,
                null
        );

        log.info("발주서 조회 응답: {}", response.toPrettyString());
        assertNotNull(response, "발주서 조회 응답이 null이면 안 됩니다.");
    }
}
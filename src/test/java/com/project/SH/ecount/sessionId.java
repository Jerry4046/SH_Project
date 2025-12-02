package com.project.SH.ecount;

import com.project.SH.service.EcountApiService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class sessionId {

    private static final Logger log = LoggerFactory.getLogger(sessionId.class);

    @Autowired
    private EcountApiService ecountApiService;

    @Test
    @DisplayName("이카운트 SESSION_ID를 조회한다")
    void fetchSessionId() {
        String sessionId = ecountApiService.getSessionId();

        log.info("발급받은 SESSION_ID: {}", sessionId);

        assertNotNull(sessionId, "SESSION_ID는 null이면 안 됩니다.");
        assertFalse(sessionId.isBlank(), "SESSION_ID는 비어 있으면 안 됩니다.");
    }
}
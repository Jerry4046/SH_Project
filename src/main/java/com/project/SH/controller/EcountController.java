package com.project.SH.controller;

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

}
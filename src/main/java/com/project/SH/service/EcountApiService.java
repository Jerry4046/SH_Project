package com.project.SH.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class EcountApiService {

    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${ecount.com-code}")
    private String comCode;

    @Value("${ecount.user-id}")
    private String userId;

    @Value("${ecount.api-cert-key}")
    private String apiCertKey;

    @Value("${ecount.zone}")
    private String zone;

    // SESSION_ID 얻기 (파이썬 login()과 동일)
    public String getSessionId() {

        String url = "https://sboapi" + zone + ".ecount.com/OAPI/V2/OAPILogin";

        try {
            // 1) 요청 바디 구성 (순서 유지)
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("COM_CODE", comCode);
            body.put("USER_ID", userId);
            body.put("API_CERT_KEY", apiCertKey);
            body.put("LAN_TYPE", "ko-KR");
            body.put("ZONE", zone);

            ObjectMapper mapper = new ObjectMapper();
            String jsonBody = mapper.writeValueAsString(body);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setAccept(List.of(MediaType.APPLICATION_JSON));

            HttpEntity<String> entity = new HttpEntity<>(jsonBody, headers);

            // 2) 디버그용 요청 로그
            System.out.println("=== [ECOUNT LOGIN REQUEST BODY] ===");
            System.out.println("URL  : " + url);
            System.out.println("BODY : " + jsonBody);
            System.out.println("==================================");

            // 3) 로그인 호출
            ResponseEntity<String> resp = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    entity,
                    String.class
            );

            String respBody = resp.getBody();
            System.out.println("=== [ECOUNT LOGIN RESPONSE RAW] ===");
            System.out.println(respBody);
            System.out.println("===================================");

            // 🔥🔥🔥 여기부터가 너가 물어본 부분 🔥🔥🔥
            // 4) SESSION_ID 파싱
            JsonNode root = mapper.readTree(respBody);

            // Data 노드
            JsonNode dataNode = root.path("Data").isMissingNode()
                    ? root.path("data")
                    : root.path("Data");

            // Data.Datas 노드
            JsonNode datasNode = dataNode.path("Datas").isMissingNode()
                    ? dataNode.path("datas")
                    : dataNode.path("Datas");

            String sessionId = datasNode.path("SESSION_ID").asText(null);

            if (sessionId == null || sessionId.isEmpty()) {
                throw new IllegalStateException("SESSION_ID not found in response: " + respBody);
            }

            return sessionId;

        } catch (HttpStatusCodeException e) {
            System.out.println("=== [ECOUNT LOGIN ERROR RAW] ===");
            System.out.println(e.getResponseBodyAsString());
            System.out.println("================================");
            throw new IllegalStateException(
                    "ECOUNT 로그인 실패: " + e.getStatusCode() + " / body = " + e.getResponseBodyAsString(), e
            );
        } catch (Exception e) {
            throw new IllegalStateException("ECOUNT 로그인 처리 중 예외: " + e.getMessage(), e);
        }
    }

    // 파이썬의 GetListInventoryBalanceStatusByLocation 호출 자바 버전
    public JsonNode getInventoryBalance(String baseDate, String prodCd, String whCd) {

        String sessionId = getSessionId(); // 먼저 로그인

        String url = "https://sboapi" + zone +
                ".ecount.com/OAPI/V2/InventoryBalance/GetListInventoryBalanceStatusByLocation" +
                "?SESSION_ID=" + sessionId;

        Map<String, Object> body = new HashMap<>();
        body.put("PROD_CD", prodCd == null ? "" : prodCd);
        body.put("WH_CD", whCd == null ? "" : whCd);
        body.put("BASE_DATE", baseDate); // "20230115" 같은 형식

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(List.of(MediaType.APPLICATION_JSON));

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

        ResponseEntity<JsonNode> resp = restTemplate.exchange(
                url,
                HttpMethod.POST,
                entity,
                JsonNode.class
        );

        JsonNode root = resp.getBody();
        if (root == null) {
            throw new IllegalStateException("InventoryBalance response is empty");
        }

        return root;
    }
}
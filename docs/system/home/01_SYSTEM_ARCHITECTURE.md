# 홈/대시보드 시스템 구상도

문서 버전: 1.0.0 | 생성일: 2026-01-12

---

## 1. 시스템 개요

### 1.1 목적
- 로그인 후 메인 대시보드 제공
- 주요 지표 요약 표시 (매출, 제품, 입출고)
- Google 캘린더 연동

---

## 2. 데이터 흐름
- 로그인 성공 → HomeController → 세션 정보 저장 (username, grade)
- home.jsp 렌더링 → Google Calendar iframe + 요약 카드

---

## 3. 관련 파일
- HomeController.java (controller/) - 홈 컨트롤러
- home.jsp (views/) - 홈 화면

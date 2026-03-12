# 홈/대시보드 화면 정의서

문서 버전: 1.0.0 | 생성일: 2026-01-12

---

## 1. 홈 화면 (SCR-HOME-001)
- 경로: /home

---

## 2. 화면 요소

### 2.1 Google Calendar
- 타입: iframe
- 크기: 800 x 400

### 2.2 요약 카드
- 매출 정보 (초록 border-success): 금일/주간/분기 매출
- 제품 정보 (파랑 border-primary): 총 제품 수, 총 재고 수량
- 입출고 정보 (노랑 border-warning): 금일 입고, 금일 출고

---

## 3. 데이터 바인딩 (현재 미연동)
- todaySales, weeklySales, quarterSales - 매출
- totalProducts, totalStock - 제품/재고
- todayStockIn, todayStockOut - 입출고

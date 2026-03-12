# 02. 요구사항 명세서 - 제품 관리 (Product)

문서 버전: 1.1.0 | 생성일: 2026-01-12

---

## 목적

- 제품(Product) 모듈의 요구사항(REQ)을 기능 단위로 정리합니다.

---

## 범위 (In / Out)

- **In**: 제품 조회/등록/수정, 변형, 이미지, 재고 상태 표시
- **Out**: 외부 상품 연동

---

## 용어(정의)

- **REQ-PRD-\***: 제품 모듈 요구사항 ID

---

## 기능 요구사항

### REQ-PRD-001: 제품 목록 조회

- 유형/카테고리/검색어 필터
- 재고 상태 표시(정상/부족/없음)
- 페이징, 정렬

### REQ-PRD-002: 제품 등록

- 코드 조합(회사/유형/카테고리/아이템)
- 필수값: 제품명, 규격, 입수량
- 변형(variants) 등록

### REQ-PRD-003: 제품 상세 조회

- 기본 정보, 변형 목록, 이미지, 재고 현황

### REQ-PRD-004: 제품 수정

- 수정 사유 입력 필수
- 변경 이력 기록

### REQ-PRD-005: 변형 관리

- 입수량별 BOX/낱개 수량 관리
- 합계 검증

### REQ-PRD-006: 이미지 관리

- 업로드 → WebP 변환 → 저장
- 미리보기 제공

### REQ-PRD-007: 재고상태 표시

- 현재 재고 vs 최소 재고 비교
- 상태 뱃지 표시

---

## 데이터 항목(핵심)

- product_tb: product_id, product_code, item_code, pd_name, spec, pieces_per_box, min_stock_quantity, active
- product_variant_tb: variant_id, product_id, pieces_per_box, box_qty, loose_qty, sub_total_qty

---

## 예외/에러 케이스

- 코드 중복/필수값 누락
- 변형 합계 불일치
- 이미지 변환 실패

---

## 관련 화면/테이블/코드 링크

- 화면: /inventory, /product/register, /product/detail/...
- 테이블: product_tb, product_variant_tb
- 코드: ProductService, Variant API

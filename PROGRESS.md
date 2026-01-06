# 진행상황 (Variant Management - Full B)

## 목표
- 동일 제품명이라도 `입수량(piecesPerBox)`이 다른 경우를 **제품(Product) + 변형(ProductVariant)** 구조로 관리
- **제품 총재고 = 변형 합계** 불변조건을 유지
- `inventory.jsp`에서 **입수량 셀 클릭 → 모달에서 변형(입수량별) 재고를 인라인 편집/추가/삭제/저장**하는 UX 구현

## 구현 완료 내역 (핵심)

### 1) DB/도메인 구조 (Full B)
- `product_variant_tb` 테이블 신설
  - `product_id + pieces_per_box` 유니크
  - 변형별 수량 컬럼: `box_qty`, `loose_qty`, `sub_total_qty`
- `ProductVariant` 엔티티 추가
- `Product` ↔ `ProductVariant` 1:N 관계 추가

### 2) Repository / Service
- `ProductVariantRepository` 생성
  - Spring Data 메서드명 필드 불일치 이슈 대응을 위해 `@Query` 기반으로 수정
- `ProductService`에 변형 관련 로직 추가
  - 변형 CRUD
  - **검증(변형 합계 = 제품 총재고)** 로직

### 3) Controller / API
- 변형 관리 REST API 추가: `ProductVariantController`
  - `GET  /api/products/{productId}/variants` : 변형 목록 조회
  - `POST /api/products/{productId}/variants` : 변형 추가
  - `PUT  /api/products/{productId}/variants/{variantId}` : 변형 수정
  - `DELETE /api/products/{productId}/variants/{variantId}` : 변형 삭제
  - `GET  /api/products/{productId}/variants/validate` : 변형 합계 검증

### 4) 기존 데이터 마이그레이션
- `V2__migrate_product_variants.sql` 작성
  - 기존 제품 데이터의 입수량/재고를 변형 테이블로 이관

## UI 구현 완료 내역 (`inventory.jsp`)

### 1) 테이블 UX 개선
- 숫자 컬럼 오른쪽 정렬 적용
  - 입수량, BOX, 낱개, 총재고, 단가, 최소재고
- 표 너비 조정, 헤더/데이터 정렬 불일치 수정, 제품명 말줄임 처리

### 2) 변형 관리 모달 (인라인 편집)
- **입수량 셀(파란색 텍스트)** 클릭 시 모달 오픈
- 모달 내 기능
  - 변형 목록 표시
  - BOX/낱개 인라인 편집
  - 소계 및 변형 합계 자동 계산
  - 변형 합계 vs 총재고 일치/불일치 경고 표시
  - 새 입수량 추가(+ 버튼)
  - 삭제(🗑 버튼)
  - 저장 시 추가/수정/삭제 API 호출

## 해결한 이슈 / 버그 수정

### 1) 변형 조회 시 JSON 파싱 오류
- 증상
  - `SyntaxError: Unexpected token '}', ... is not valid JSON`
- 원인
  - `ProductVariant` → `Product` 참조로 인해 JSON 직렬화 시 순환 참조 발생
- 조치
  - `ProductVariant.product`에 `@JsonIgnore` 적용

### 2) 입수량(변형) 저장이 안되는 문제
- 원인
  - 프론트는 JSON body(`Content-Type: application/json`)로 전송
  - 백엔드는 `@RequestParam`으로 파라미터를 받도록 구현되어 바인딩 실패
- 조치
  - `ProductVariantController`의 추가/수정 API를 `@RequestBody Map<String, Integer>` 기반으로 수정

### 3) Bootstrap CSS 경로 오타
- `bootstrap.mi n.css` 형태로 공백이 들어가 스타일이 깨지는 문제 발생
- `bootstrap.min.css`로 복구

## 남은 작업 / 확인 필요
- 서버 재기동 후, 아래 항목 최종 확인
  - 변형 추가/수정/삭제가 DB에 반영되는지
  - 저장 후 목록 새로고침 시 입수량 표시가 기대대로 갱신되는지
  - 변형 합계와 총재고 불일치 시 저장이 차단되는지
- (정리) `inventory.jsp`에 일시적으로 추가된 디버깅 `console.log`가 있다면, 최종 배포 전 제거 권장

## 관련 파일 목록
- `src/main/java/com/project/SH/domain/ProductVariant.java`
- `src/main/java/com/project/SH/repository/ProductVariantRepository.java`
- `src/main/java/com/project/SH/service/ProductService.java`
- `src/main/java/com/project/SH/controller/ProductVariantController.java`
- `src/main/webapp/WEB-INF/views/inventory.jsp`
- `src/main/resources/db/migration/V2__migrate_product_variants.sql`

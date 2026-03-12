# SH Project 변경 이력 (CHANGELOG)

> **⚠️ 경고: 이 문서는 프로젝트의 핵심 변경 이력입니다. 절대 삭제하지 마십시오.**
> 
> 모든 기능 추가, 수정, 삭제는 반드시 이 문서에 기록해야 합니다.

---

## 문서 규칙

### 버전 형식
- **MAJOR.MINOR.PATCH** (예: 1.2.3)
- MAJOR: 대규모 변경, 호환성 깨짐
- MINOR: 새 기능 추가
- PATCH: 버그 수정, 소규모 개선

### 변경 유형
- **[추가]** - 새로운 기능
- **[수정]** - 기존 기능 변경
- **[삭제]** - 기능 제거
- **[버그수정]** - 버그 해결
- **[개선]** - 성능/UX 개선
- **[보안]** - 보안 관련 변경
- **[문서]** - 문서화 작업

---

## [1.13.0] - 2026-03-06

### [문서] 모듈별 명세서 5종 체계 완성

- **주문**: `docs/system/order/04_SCREEN_DEFINITION.md` 신규 작성 (화면 정의서)
- **캘린더**: `02_REQUIREMENTS_SPEC.md`, `03_FUNCTION_SPEC.md`, `05_ERD_SPEC.md` 신규 작성
- **홈/대시보드**: `02_REQUIREMENTS_SPEC.md`, `03_FUNCTION_SPEC.md`, `05_ERD_SPEC.md` 신규 작성
- **단가**: `02_REQUIREMENTS_SPEC.md`, `03_FUNCTION_SPEC.md`, `05_ERD_SPEC.md` 신규 작성
- **마스터 명세**: `docs/system/00_MASTER_SPEC.md` 문서화 완료 현황 갱신 (버전 1.1.0)

---

## [1.12.0] - 2026-01-22

### 주문 시스템 DB 마이그레이션 실행

#### [추가] Client 엔티티 수정
- `forceLotte` 필드 추가 (롯데택배 강제 적용 여부)

#### [추가] CourierFare 엔티티 생성
- `@C:\SHProject\src\main\java\com\project\SH\domain\CourierFare.java`
- 택배사별 요금 코드와 금액 관리

#### [추가] MariaDB 마이그레이션 실행 완료
- `product_tb`: star_mark, pack_qty, fare_code, material 컬럼 추가
- `courier_fare_tb`: 테이블 생성
- `client_tb`: force_lotte 컬럼 추가

---

## [1.11.0] - 2026-01-22

### 주문 시스템 테이블 마이그레이션

#### [추가] Product 엔티티 컬럼 추가
- `star_mark`: 별표 대상 여부 (비슷한 제품 구분용)
- `pack_qty`: 합포 기준값 (비닐제품만 해당, 배수일 때만 분할)
- `fare_code`: 택배비 코드 (courier_fare_tb 참조)
- `material`: 재질 (VINYL/PAPER/OTHER) - 파일접수 시 자동 분류용

#### [추가] 마이그레이션 스크립트 작성
- `V4__add_product_order_columns.sql`
- product_tb 컬럼 추가 (star_mark, pack_qty, fare_code, material)
- courier_fare_tb 테이블 생성
- client_tb.force_lotte 컬럼 추가

#### [문서] 합포 규칙 상세화
- 수량이 pack_qty의 배수일 때만 분할
- 예: pack_qty=3, 수량=6 → 3개 × 2행
- 예: pack_qty=3, 수량=5 → 5묶음 × 1행 (배수 아님)

---

## [1.10.0] - 2026-01-22

### 주문 시스템 데이터 구조 상세화

#### [문서] 택배비 테이블 설계
- **별도 테이블**: `courier_fare_tb` (택배사코드, 요금코드, 택배요금)
- **제품 연결**: `product_tb.fare_code` → `courier_fare_tb.fare_code`
- **롯데택배**: 데이터만 저장, 실제 요금은 택배사에서 무게/크기 기준 자동 부여

#### [문서] 제품 테이블 확장 컬럼 정의
- `star_mark`: 별표 대상 여부 (비슷한 제품 구분용, 1이면 `_★★` 자동 추가)
- `pack_qty`: 합포 기준값 (비닐제품만 해당, 예: 3이면 3개씩 합포)
- `fare_code`: 택배비 코드 (courier_fare_tb 참조)
- `material`: 재질 (비닐/종이/기타) - 선택적 컬럼

#### [문서] 거래처 테이블 확장 컬럼 정의
- `force_lotte`: 롯데택배 강제 적용 여부 (특정 대리점 관리용)
- 대리점 추가 시 이 컬럼을 1로 설정하여 확장 가능

#### [문서] 출고 상태 및 버튼 UI 정의
- **초기 상태**: 선발주 등록 시 "미출고"로 시작
- **출고 버튼**: 일괄 출고, 부분 출고, 상태별 화면 표시
- **저장 버튼**: 저장 시 진짜 출고된 것으로 표시

---

## [1.9.0] - 2026-01-22

### 주문 시스템 프로세스 요구사항 상세화

#### [문서] 선발주 등록 프로세스 정의
- **등록 경로**: 주문 탭에서 직접 입력 (문자/전화 주문 접수 시)
- **주문 유형**: "선발주"로 선택하여 등록
- **입력 정보**: 거래처, 제품, 수량, 배송지 등

#### [문서] 출고 처리 프로세스 정의
- **출고 상태 기준**: 회사에서 제품이 나갔나 안 나갔나를 기준으로 판단
- **선발주/파일주문 동일**: 주문 방식만 다르고 출고 방식은 동일
- **출고 흐름**: 주문 등록 → 매칭 → 매칭 안 된 부분만 출고 상태 변환

#### [문서] 매칭 타이밍 정의
- **파일 업로드 직후**: 자동 매칭 수행
- **결과 표시**: "매칭 N건 처리됨" 메시지 (상세 표시 불필요)

#### [문서] 제품 DB 연동 방식 정의
- **DB 테이블 조회**: 엑셀 파일(product_db.xls) 대신 DB 테이블 사용
- **조회 대상**: 제품명, 재질, 배송비, 별표 대상, pref/unit 등

---

## [1.8.0] - 2026-01-22

### 주문 시스템 UI 요구사항 상세화

#### [문서] 선발주 탭 UI 요구사항 추가
- **기본 뷰**: 미차감(미매칭 + 잔량 있음) 선발주만 표시
- **전체 보기**: 검색란 영역에 토글 버튼/이벤트 도구 배치
- **전체 보기 시**: 매칭 완료 포함, 차감 일시/매칭 정보 표시
- **잔량 컬럼**: 선발주 목록에 잔량 정보 표시
- **잔량 있는 선발주**: 미차감 선발주로 취급하여 기본 뷰에 표시

#### [문서] 파일접수 화면 UI 요구사항 추가
- **업로드 → 표시 흐름**: 업로드 → 가공 → 표 형태 출력 → DB 저장 없이 임시 보관
- **접수 확정**: 접수 버튼 클릭 시 DB 저장
- **임시 상태**: 접수 전 새로고침 시 데이터 소실 허용
- **인라인 편집**: 제품명, 주소, 전화번호 등 편집 가능

---

## [1.7.0] - 2026-01-21

### 주문 시스템 설계 및 거래처 오류 수정

#### [문서] 주문 시스템 설계 문서 작성
- **설명**: 주문 시스템 전체 설계 문서 작성
- **관련 파일**: `docs/system/order/` (4개 문서)
- **문서 목록**:
  - `01_SYSTEM_ARCHITECTURE.md` - 시스템 아키텍처
  - `02_REQUIREMENTS_SPEC.md` - 요구사항 명세서
  - `03_FUNCTION_SPEC.md` - 기능 명세서
  - `05_ERD_SPEC.md` - ERD 명세서

#### [문서] 주문 시스템 핵심 기능 설계
- **일반접수**: 단건 주문 등록 (정상주문/선발주)
- **파일접수**: 엑셀 업로드 → 서비스단 가공 → 웹 표시
- **자동 매칭**: 선발주 + 파일주문 중복 시 수량 차감
- **데이터 가공**: 접두사/접미사, 비닐/종이 분류, 택배구분
- **송장 생성**: 로젠/롯데 택배사 양식 변환

#### [버그수정] 거래처 등록 오류 수정
- **증상**: "등록되지 않은 회사 코드입니다" 오류
- **원인**: ClientController가 `code_item_tb`의 `PD_CP` 그룹을 조회하지만, ClientService는 `company_code_tb` 테이블에서 검증
- **해결**:
  - `CompanyCodeService.java` 구현 (company_code_tb CRUD)
  - `ClientController.java` 수정 (CompanyCodeService 사용)
  - `V3__insert_company_codes.sql` 생성 (초기 회사 코드 데이터)

#### [추가] 파일 가공 프로젝트 분석
- **SP엑셀 변환기** (`C:\Users\USER\PyCharmMiscProject`)
  - 서울우유 업로드 엑셀 가공
  - step2: 선발주 차감/매칭
  - step3: DB 비교 → 비닐/종이/미분류 분류
  - step4: 분할/접두사/택배비 설정
  - step6: 송장 생성
- **SH동원 프로젝트** (`C:\SH동원 프로젝트\DongWon`)
  - 동원 엑셀 가공

---

## [1.6.0] - 2026-01-21

### 입출고/주문 백엔드 및 프론트엔드 구현

#### [추가] Domain 클래스 생성
- `Inbound.java`, `InboundHistory.java` - 입고 마스터/이력
- `Outbound.java`, `OutboundHistory.java` - 출고 마스터/이력
- `Order.java`, `OrderHistory.java` - 주문 마스터/이력
- `ProductClientMapping.java` - 제품-대리점 매핑
- `SystemLog.java` - 시스템 로그

#### [추가] Repository 클래스 생성
- `InboundRepository.java`, `InboundHistoryRepository.java`
- `OutboundRepository.java`, `OutboundHistoryRepository.java`
- `OrderRepository.java`, `OrderHistoryRepository.java`
- `ProductClientMappingRepository.java`, `SystemLogRepository.java`

#### [추가] Service 클래스 생성
- `InboundService.java` - 입고 CRUD + 재고 연동 + 이력 관리
- `OutboundService.java` - 출고 CRUD + 재고 연동 + 이력 관리
- `OrderService.java` - 주문 CRUD + 주문번호 자동생성 + 매칭 기능
- `StockService.java` - 재고 증감/조정 + 이력 관리
- `CodeService.java` - 공통코드 조회

#### [추가] Controller 클래스 생성
- `InboundController.java` - `/inbound` 경로
- `OutboundController.java` - `/outbound` 경로
- `OrderController.java` - `/order` 경로

#### [추가] JSP 화면 생성
- `inbound/list.jsp`, `inbound/register.jsp`, `inbound/detail.jsp`
- `outbound/list.jsp`, `outbound/register.jsp`, `outbound/detail.jsp`
- `order/list.jsp`, `order/register.jsp`, `order/detail.jsp`

#### [수정] 헤더 메뉴 추가
- **관련 파일**: `common/header.jsp`
- **변경 내용**: 입고, 출고, 주문 메뉴 추가

---

## [1.5.0] - 2026-01-13

### 개발 가이드라인 문서 작성

#### [문서] 유연한 개발을 위한 가이드라인 작성
- **설명**: 모듈러 방식의 유연한 개발을 위한 가이드라인 문서 작성
- **관련 파일**: `docs/DEVELOPMENT_GUIDE.md`
- **주요 내용**:
  - 모듈 독립성 원칙 (순서 무관 개발)
  - 모듈 의존성 다이어그램
  - 기능 추가 체크리스트
  - 코드 구조 가이드
  - DB 확장 가이드
  - API 설계 규칙
- **목적**: 파이프라인 방식이 아닌, 언제든 유연하게 기능 추가/수정 가능

---

## [1.4.0] - 2026-01-13

### 캘린더 시스템 문서화

#### [문서] 캘린더 시스템 문서 작성
- **설명**: 캘린더 시스템 별도 모듈로 분리하여 문서화
- **관련 파일**: `docs/system/calendar/` (2개 문서)
- **문서 목록**:
  - `01_SYSTEM_ARCHITECTURE.md` - 시스템 구상도
  - `04_SCREEN_DEFINITION.md` - 화면 정의서
- **현재 구현**: Google Calendar iframe 임베드 (읽기 전용)
- **향후 계획**: Google Calendar API 연동, 자동 일정 생성

---

## [1.3.0] - 2026-01-13

### 주문-출고-송장 시나리오 설계 업데이트

#### [수정] 주문번호 체계 설계
- **설명**: 회사별 업로드 분리를 위한 주문번호 이중 체계 도입
- **관련 파일**: `docs/system/inout/03_FUNCTION_SPEC.md`, `docs/system/inout/05_ERD_SPEC.md`
- **변경 내용**:
  - `internal_order_no`: 내부 주문번호 (자동생성, SH-YYYYMMDD-NNNN 형식)
  - `external_order_no`: 외부 주문번호 (A사 등 자체 주문시스템 있는 경우)
  - `company_code`: 회사코드 (송장파일 분리용)

#### [수정] 출고 테이블에 운송장번호 컬럼 추가
- **설명**: 택배사 업로드 후 운송장번호 저장
- **관련 파일**: `docs/system/inout/05_ERD_SPEC.md`
- **변경 내용**: `outbound_tb.tracking_no` 컬럼 추가

#### [문서] 주문-출고-송장 전체 시나리오 문서화
- **설명**: 주문 접수부터 출고 완료까지 전체 흐름 문서화
- **관련 파일**: `docs/system/inout/03_FUNCTION_SPEC.md`
- **시나리오**:
  1. 주문 접수 → 내부/외부 주문번호 생성
  2. 접수 처리 → 출고 테이블 등록
  3. 출고 확정 → 재고 차감 + 송장파일 생성 (회사별 분리)
  4. 택배사 업로드 (A사: 포털, 기타: 일반 택배사)
  5. 운송장번호 입력 → outbound_tb.tracking_no 저장
  6. 출고 완료

---

## [1.2.0] - 2026-01-12

### 전체 시스템 문서화 완료

#### [문서] 전체 시스템 마스터 문서 작성
- **설명**: 전체 프로젝트 시스템 명세서 작성
- **관련 파일**: `docs/system/00_MASTER_SPEC.md`
- **내용**: 시스템 구성도, 메뉴 구조, 화면 목록, API 목록, ERD 개요

#### [문서] 제품 관리 시스템 문서화
- **관련 파일**: `docs/system/product/` (5개 문서)
- **내용**: 시스템구상도, 요구사항명세서, 기능명세서, 화면정의서, ERD명세서

#### [문서] 거래처 관리 시스템 문서화
- **관련 파일**: `docs/system/client/` (5개 문서)
- **내용**: 시스템구상도, 요구사항명세서, 기능명세서, 화면정의서, ERD명세서

#### [문서] 코드 관리 시스템 문서화
- **관련 파일**: `docs/system/code/` (5개 문서)
- **내용**: 시스템구상도, 요구사항명세서, 기능명세서, 화면정의서, ERD명세서

#### [문서] 인증/사용자 시스템 문서화
- **관련 파일**: `docs/system/auth/` (5개 문서)
- **내용**: 시스템구상도, 요구사항명세서, 기능명세서, 화면정의서, ERD명세서

#### [문서] 홈/대시보드 시스템 문서화
- **관련 파일**: `docs/system/home/` (2개 문서)
- **내용**: 시스템구상도, 화면정의서

#### [문서] 단가 관리 시스템 문서화
- **관련 파일**: `docs/system/price/` (2개 문서)
- **내용**: 시스템구상도, 화면정의서

---

## [1.1.0] - 2026-01-12

### 입출고/주문 시스템 설계 문서화

#### [문서] 입출고/주문 시스템 설계 문서 작성
- **설명**: 입출고/주문 기능 개발을 위한 설계 문서 전체 작성
- **관련 파일**: `docs/inout/` 폴더 내 5개 문서
- **문서 목록**:
  - `01_SYSTEM_ARCHITECTURE.md` - 시스템 구상도
  - `02_REQUIREMENTS_SPEC.md` - 요구사항 명세서
  - `03_FUNCTION_SPEC.md` - 기능 명세서
  - `04_SCREEN_DEFINITION.md` - 화면 정의서
  - `05_ERD_SPEC.md` - ERD 명세서 (임시 구조, 개발 직전 확정)

#### [문서] 주요 설계 내용
- **입고 관리**: 등록/수정/삭제, 상태관리(정상입고/부분입고/미입고/반품/폐기), 발주서 연동
- **출고 관리**: 등록/수정/삭제, 검토단계, 창고선택(본창고/거래처창고), 재고연동
- **주문 관리**: 파일업로드/직접입력, 선발주-정상주문 매칭(이중출고 방지), 택배사 지정
- **송장 관리**: 택배사별 송장파일 생성, 송장번호 입력
- **이력/로그**: 모든 변경 이력 추적, 시스템 로그 기록

#### [문서] 신규 테이블 설계 (임시)
- `inbound_tb` - 입고 마스터
- `inbound_history_tb` - 입고 이력
- `outbound_tb` - 출고 마스터
- `outbound_history_tb` - 출고 이력
- `order_tb` - 주문 마스터
- `order_history_tb` - 주문 이력
- `product_client_mapping_tb` - 제품-대리점 매핑
- `system_log_tb` - 시스템 로그

#### [문서] 신규 코드 그룹 설계
- `FC_CODE` - 생산공장코드
- `IN_STATUS` - 입고상태
- `OUT_STATUS` - 출고상태
- `ORD_TYPE` - 주문종류
- `ORD_STATUS` - 주문상태
- `DLV_COMPANY` - 택배사

---

## [1.0.0] - 2026-01-12

### 초기 릴리스 - 전체 시스템 문서화

#### [문서] 코드 문서화
- `docs/CODE_DOCUMENTATION.md` 생성
- 전체 프로젝트 구조 문서화
- 모든 도메인 엔티티 상세 문서화
- Repository/Service/Controller 계층 문서화
- API 엔드포인트 목록 정리
- 데이터베이스 스키마 문서화

#### [문서] 변경 이력 추적
- `docs/CHANGELOG.md` 생성 (본 문서)
- 변경 이력 기록 규칙 정립

---

## 기존 구현 내역 (문서화 이전)

### 핵심 기능

#### [추가] 제품 관리 시스템
- **Product 엔티티** (`product_tb`)
  - 제품 기본 정보 관리
  - 제품 코드 체계: `회사코드_유형코드_카테고리코드_순번`
  - 관련 파일: `domain/Product.java`, `repository/ProductRepository.java`, `service/ProductService.java`

- **ProductController**
  - 제품 등록/수정/조회/검색 기능
  - 경로: `/product/**`, `/inventory`

#### [추가] 재고 관리 시스템
- **Stock 엔티티** (`stock_tb`)
  - 창고별 재고 관리 (SH창고, HP창고)
  - 총재고 자동 계산
  - 관련 파일: `domain/Stock.java`, `repository/StockRepository.java`

- **StockHistory 엔티티** (`stock_history_tb`)
  - 재고 변경 이력 추적
  - 액션 유형: IN(입고), OUT(출고), ADJUST(조정)
  - 관련 파일: `domain/StockHistory.java`, `repository/StockHistoryRepository.java`

#### [추가] 제품 변형 관리 (Full B 구조)
- **ProductVariant 엔티티** (`product_variant_tb`)
  - 동일 제품의 입수량별 변형(SKU) 관리
  - `product_id + pieces_per_box` 유니크 제약
  - 변형별 수량: box_qty, loose_qty, sub_total_qty
  - 관련 파일: `domain/ProductVariant.java`, `repository/ProductVariantRepository.java`

- **ProductVariantController** (REST API)
  - 변형 CRUD API
  - 변형 합계 검증 API
  - 경로: `/api/products/{productId}/variants`

#### [추가] 제품 변경 이력
- **ProductChangeHistory 엔티티** (`product_change_history_tb`)
  - 제품 정보 변경 이력 추적
  - 추적 필드: product_code, item_code, spec, pd_name, active, min_stock_quantity, pieces_per_box, sh_qty, hp_qty, total_qty, price
  - 관련 파일: `domain/ProductChangeHistory.java`, `repository/ProductChangeHistoryRepository.java`

#### [추가] 가격 관리
- **Price 엔티티** (`price_tb`)
  - 제품별 가격 이력 관리
  - 통화 지원 (기본: KRW)
  - 관련 파일: `domain/Price.java`, `repository/PriceRepository.java`, `service/PriceService.java`

#### [추가] 거래처 관리
- **Client 엔티티** (`client_tb`)
  - 거래처 정보 관리
  - 회사코드 연동
  - 관련 파일: `domain/Client.java`, `repository/ClientRepository.java`, `service/ClientService.java`

- **ClientApiController** (REST API)
  - 거래처 CRUD API
  - 경로: `/api/clients`

#### [추가] 코드 관리 시스템
- **ProductCode 엔티티** (`product_code_tb`)
  - 제품 코드 조합 관리
  - 회사코드 + 유형코드 + 카테고리코드

- **CodeGroup/CodeItem 엔티티**
  - 범용 코드 관리
  - 관련 파일: `domain/CodeGroup.java`, `domain/CodeItem.java`

- **CompanyCode/TypeCode/CategoryCode 엔티티**
  - 제품 코드 구성요소 관리

#### [추가] 사용자 인증
- **User 엔티티** (`account_tb`)
  - 사용자 계정 관리
  - 등급 시스템 (기본: N)

- **Spring Security 설정**
  - BCrypt 비밀번호 암호화
  - 역할 기반 접근 제어
  - 관련 파일: `config/SecurityConfig.java`, `config/CustomUserDetails.java`

#### [추가] 이미지 관리
- **ImageStorageService**
  - 제품 이미지 저장/조회
  - WebP 변환 지원
  - 관련 파일: `service/ImageStorageService.java`

### 해결된 이슈

#### [버그수정] 변형 조회 시 JSON 파싱 오류
- **증상**: `SyntaxError: Unexpected token '}', ... is not valid JSON`
- **원인**: `ProductVariant` → `Product` 참조로 인한 순환 참조
- **해결**: `ProductVariant.product`에 `@JsonIgnore` 적용

#### [버그수정] 입수량(변형) 저장 실패
- **원인**: 프론트(JSON body) vs 백엔드(`@RequestParam`) 불일치
- **해결**: `ProductVariantController`를 `@RequestBody Map<String, Integer>` 기반으로 수정

#### [버그수정] Bootstrap CSS 경로 오타
- **증상**: 스타일 깨짐
- **원인**: `bootstrap.mi n.css` (공백 포함)
- **해결**: `bootstrap.min.css`로 수정

### UI 개선

#### [개선] inventory.jsp 테이블 UX
- 숫자 컬럼 오른쪽 정렬
- 표 너비 조정
- 헤더/데이터 정렬 일치
- 제품명 말줄임 처리

#### [추가] 변형 관리 모달
- 입수량 셀 클릭 시 모달 오픈
- 변형 목록 인라인 편집
- BOX/낱개 편집
- 소계 및 변형 합계 자동 계산
- 변형 합계 vs 총재고 일치/불일치 경고
- 새 입수량 추가/삭제 기능

---

## 변경 이력 작성 템플릿

```markdown
## [버전] - YYYY-MM-DD

### [변경유형] 제목
- **설명**: 변경 내용 상세 설명
- **관련 파일**: 변경된 파일 목록
- **영향 범위**: 영향받는 기능/모듈
- **작성자**: 담당자명
```

---

## 향후 작업 목록 (TODO)

### 확인 필요
- [ ] 서버 재기동 후 변형 추가/수정/삭제 DB 반영 확인
- [ ] 저장 후 목록 새로고침 시 입수량 표시 갱신 확인
- [ ] 변형 합계와 총재고 불일치 시 저장 차단 확인

### 정리 필요
- [ ] `inventory.jsp` 디버깅 `console.log` 제거 (배포 전)

---

> **⚠️ 중요: 모든 코드 변경 시 이 문서를 업데이트하십시오.**
> 
> 변경 이력이 없는 코드 수정은 추적이 불가능합니다.

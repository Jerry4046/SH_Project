# SH Project 코드 문서화

> **⚠️ 경고: 이 문서는 프로젝트의 핵심 기록입니다. 절대 삭제하지 마십시오.**
> 
> **문서 생성일**: 2026-01-12
> **최종 수정일**: 2026-01-12
> **문서 버전**: 1.0.0

---

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [기술 스택](#2-기술-스택)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [도메인 엔티티](#4-도메인-엔티티)
5. [DTO (Data Transfer Objects)](#5-dto-data-transfer-objects)
6. [Repository 계층](#6-repository-계층)
7. [Service 계층](#7-service-계층)
8. [Controller 계층](#8-controller-계층)
9. [설정 클래스](#9-설정-클래스)
10. [API 엔드포인트 목록](#10-api-엔드포인트-목록)
11. [데이터베이스 스키마](#11-데이터베이스-스키마)

---

## 1. 프로젝트 개요

SH Project는 **재고 관리 시스템**으로, 제품 등록/수정/조회, 재고 관리, 거래처 관리, 가격 관리 등의 기능을 제공합니다.

### 주요 기능
- **제품 관리**: 제품 등록, 수정, 조회, 검색
- **재고 관리**: 창고별 재고 관리 (SH창고, HP창고), 재고 이력 추적
- **변형 관리**: 동일 제품의 입수량별 변형(SKU) 관리
- **거래처 관리**: 거래처 등록 및 조회
- **가격 관리**: 제품별 가격 이력 관리
- **코드 관리**: 회사코드, 유형코드, 카테고리코드 관리

---

## 2. 기술 스택

| 구분 | 기술 |
|------|------|
| **Language** | Java 17+ |
| **Framework** | Spring Boot 3.x |
| **ORM** | Spring Data JPA (Hibernate) |
| **Security** | Spring Security |
| **Build Tool** | Gradle |
| **Database** | MySQL/MariaDB |
| **View** | JSP |
| **기타** | Lombok, Jackson |

---

## 3. 프로젝트 구조

```
src/main/java/com/project/SH/
├── ShApplication.java              # 메인 애플리케이션
├── ServletInitializer.java         # 서블릿 초기화
├── Test.java                       # 테스트 클래스
│
├── config/                         # 설정 클래스
│   ├── CustomUserDetails.java      # 사용자 인증 정보
│   ├── FileCountMaxEnforcerFilter.java
│   ├── MultipartConfig.java        # 파일 업로드 설정
│   ├── SecurityConfig.java         # Spring Security 설정
│   └── WebConfig.java              # 웹 설정
│
├── controller/                     # 컨트롤러 계층
│   ├── ClientApiController.java    # 거래처 REST API
│   ├── ClientController.java       # 거래처 페이지
│   ├── CodeController.java         # 코드 관리
│   ├── CodeLookupApiController.java
│   ├── CodeManagementController.java
│   ├── EcountController.java       # 이카운트 연동
│   ├── HomeController.java         # 홈 페이지
│   ├── InOutController.java        # 입출고 관리
│   ├── InventoryController.java    # 재고 페이지 (비활성화)
│   ├── LoginController.java        # 로그인
│   ├── PriceController.java        # 가격 관리
│   ├── ProductCodeApiController.java
│   ├── ProductController.java      # 제품 관리 (메인)
│   ├── ProductVariantController.java # 제품 변형 REST API
│   └── SignUpController.java       # 회원가입
│
├── dao/                            # DAO 계층
│   └── UserDao.java
│
├── domain/                         # 엔티티 클래스
│   ├── CategoryCode.java           # 카테고리 코드
│   ├── Client.java                 # 거래처
│   ├── CodeGroup.java              # 코드 그룹
│   ├── CodeItem.java               # 코드 항목
│   ├── CodeItemId.java             # 코드 항목 복합키
│   ├── CompanyCode.java            # 회사 코드
│   ├── DailyMemo.java              # 일일 메모
│   ├── Price.java                  # 가격
│   ├── Product.java                # 제품 (핵심)
│   ├── ProductChangeHistory.java   # 제품 변경 이력
│   ├── ProductCode.java            # 제품 코드
│   ├── ProductVariant.java         # 제품 변형 (입수량별)
│   ├── Stock.java                  # 재고
│   ├── StockHistory.java           # 재고 변경 이력
│   ├── TypeCode.java               # 유형 코드
│   └── User.java                   # 사용자
│
├── dto/                            # DTO 클래스
│   ├── ClientResponse.java         # 거래처 응답
│   ├── CreateClientRequest.java    # 거래처 생성 요청
│   ├── DailyMemoResponse.java      # 일일 메모 응답
│   ├── DailyMemoSaveRequest.java   # 일일 메모 저장 요청
│   ├── NextItemCodeResponse.java   # 다음 아이템 코드 응답
│   └── PurchaseOrderSearchRequest.java # 발주 검색 요청
│
├── repository/                     # Repository 계층
│   ├── CategoryCodeRepository.java
│   ├── ClientRepository.java
│   ├── CodeGroupRepository.java
│   ├── CodeItemRepository.java
│   ├── CompanyCodeRepository.java
│   ├── DailyMemoRepository.java
│   ├── PriceRepository.java
│   ├── ProductChangeHistoryRepository.java
│   ├── ProductCodeRepository.java
│   ├── ProductRepository.java      # 제품 (핵심)
│   ├── ProductVariantRepository.java
│   ├── StockHistoryRepository.java
│   ├── StockRepository.java
│   └── TypeCodeRepository.java
│
└── service/                        # Service 계층
    ├── ClientService.java          # 거래처 서비스
    ├── ClientServiceImpl.java
    ├── CodeGroupService.java
    ├── CodeGroupServiceImpl.java
    ├── CodeItemService.java
    ├── CodeItemServiceImpl.java
    ├── CompanyCodeService.java
    ├── CustomUserDetailsService.java # 사용자 인증 서비스
    ├── EcountApiService.java       # 이카운트 API 연동
    ├── ImageStorageService.java    # 이미지 저장 서비스
    ├── PriceService.java
    ├── PriceServiceImpl.java
    ├── ProductCodeService.java
    ├── ProductCodeServiceImpl.java
    ├── ProductService.java         # 제품 서비스 (핵심)
    ├── ProductServiceImpl.java
    ├── SignUpService.java
    └── SignUpServiceImpl.java
```

---

## 4. 도메인 엔티티

### 4.1 Product (제품)

**테이블명**: `product_tb`

**설명**: 제품 기본 정보를 담당하는 핵심 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `product_id` | Long | 제품 ID (PK) | AUTO_INCREMENT |
| `account_seq` | Long | 등록자 계정 번호 | NOT NULL |
| `product_code` | String | 제품 코드 | NOT NULL, 20자 |
| `item_code` | String | 아이템 코드 | 10자 |
| `pd_name` | String | 제품명 | NOT NULL, 100자 |
| `spec` | String | 규격 | 100자 |
| `pieces_per_box` | Integer | 박스당 입수량 | NOT NULL, 기본값 1 |
| `min_stock_quantity` | Integer | 최소 재고 수량 | NOT NULL, 기본값 0 |
| `description` | String | 설명 | TEXT |
| `active` | Boolean | 사용 여부 | NOT NULL, 기본값 true |
| `created_at` | LocalDateTime | 생성일시 | |
| `updated_at` | LocalDateTime | 수정일시 | |

**관계**:
- `Stock` (1:1) - 재고 정보
- `Price` (1:N) - 가격 이력
- `ProductVariant` (1:N) - 입수량별 변형
- `User` (N:1) - 등록자

**주요 메서드**:
```java
// 최신 가격 조회
public Double getPrice()

// 전체 제품 코드 조회 (product_code + item_code)
public String getFullProductCode()

// 날짜 포맷팅
public String getFormattedCreatedAt()
public String getFormattedUpdatedAt()
```

---

### 4.2 ProductVariant (제품 변형)

**테이블명**: `product_variant_tb`

**설명**: 동일 제품의 입수량별 변형(SKU)을 관리하는 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `variant_id` | Long | 변형 ID (PK) | AUTO_INCREMENT |
| `product_id` | Long | 제품 ID (FK) | NOT NULL |
| `pieces_per_box` | Integer | 박스당 입수량 | NOT NULL |
| `box_qty` | Integer | 박스 수량 | NOT NULL, 기본값 0 |
| `loose_qty` | Integer | 낱개 수량 | NOT NULL, 기본값 0 |
| `sub_total_qty` | Integer | 소계 수량 | NOT NULL, 기본값 0 |
| `created_at` | LocalDateTime | 생성일시 | |
| `updated_at` | LocalDateTime | 수정일시 | |

**유니크 제약조건**: `(product_id, pieces_per_box)`

**주요 메서드**:
```java
// 소계 재계산: boxQty * piecesPerBox + looseQty
public void recalculateSubTotal()

// 수량 업데이트
public void updateQuantities(int boxQty, int looseQty)

// 총수량으로부터 박스/낱개 역산
public void setSubTotalAndCalculateBoxLoose(int totalQty)
```

---

### 4.3 Stock (재고)

**테이블명**: `stock_tb`

**설명**: 현재 재고 정보를 담당하는 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `product_id` | Long | 제품 ID (PK, FK) | |
| `sh_qty` | Integer | SH창고 수량 | NOT NULL, 기본값 0 |
| `hp_qty` | Integer | HP창고 수량 | NOT NULL, 기본값 0 |
| `total_qty` | Integer | 총 재고 수량 | NOT NULL, 기본값 0 |
| `created_at` | LocalDateTime | 생성일시 | |
| `updated_at` | LocalDateTime | 수정일시 | |

**주요 메서드**:
```java
// 창고별 수량 업데이트 및 총재고 재계산
public void updateWarehouseQuantities(Integer shQty, Integer hpQty)

// 총재고 재계산
public void recalculateTotalQty()
```

---

### 4.4 StockHistory (재고 변경 이력)

**테이블명**: `stock_history_tb`

**설명**: 재고 변경 이력을 기록하는 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | Long | 이력 ID (PK) | AUTO_INCREMENT |
| `product_id` | Long | 제품 ID (FK) | NOT NULL |
| `account_seq` | Long | 변경자 계정 번호 | NOT NULL |
| `action` | String | 액션 (IN/OUT/ADJUST) | NOT NULL, 20자 |
| `change_qty` | Integer | 변경 수량 | NOT NULL |
| `old_sh_qty` | Integer | 변경 전 SH창고 수량 | NOT NULL |
| `new_sh_qty` | Integer | 변경 후 SH창고 수량 | NOT NULL |
| `old_hp_qty` | Integer | 변경 전 HP창고 수량 | NOT NULL |
| `new_hp_qty` | Integer | 변경 후 HP창고 수량 | NOT NULL |
| `old_total_qty` | Integer | 변경 전 총재고 | NOT NULL |
| `new_total_qty` | Integer | 변경 후 총재고 | NOT NULL |
| `reason` | String | 변경 사유 | |
| `created_at` | LocalDateTime | 생성일시 | |

---

### 4.5 ProductChangeHistory (제품 변경 이력)

**테이블명**: `product_change_history_tb`

**설명**: 상품 정보 변경 이력을 기록하는 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | Long | 이력 ID (PK) | AUTO_INCREMENT |
| `product_id` | Long | 제품 ID (FK) | NOT NULL |
| `field_name` | String | 변경된 필드명 | NOT NULL, 50자 |
| `old_value` | String | 변경 전 값 | 255자 |
| `new_value` | String | 변경 후 값 | 255자 |
| `reason` | String | 변경 사유 | NOT NULL, 255자 |
| `changed_by` | Long | 변경자 계정 번호 | NOT NULL |
| `changed_at` | LocalDateTime | 변경일시 | NOT NULL |

---

### 4.6 Client (거래처)

**테이블명**: `client_tb`

**설명**: 거래처 정보를 관리하는 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `client_id` | Long | 거래처 ID (PK) | AUTO_INCREMENT |
| `client_code` | String | 거래처 코드 | 10자 |
| `company_initial` | String | 회사 코드 (FK) | NOT NULL |
| `manager_name` | String | 담당자명 | NOT NULL, 50자 |
| `branch_name` | String | 지점명 | 100자 |
| `agency_name` | String | 대리점명 | 100자 |
| `address` | String | 주소 | 255자 |
| `manager_phone` | String | 담당자 전화번호 | 20자 |
| `regional_phone` | String | 지역 전화번호 | 20자 |
| `created_at` | LocalDateTime | 생성일시 | |
| `updated_at` | LocalDateTime | 수정일시 | |

**인덱스**:
- `idx_client_company_initial` (company_initial)
- `idx_client_branch_name` (branch_name)

---

### 4.7 Price (가격)

**테이블명**: `price_tb`

**설명**: 제품 가격 정보를 관리하는 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `price_id` | Long | 가격 ID (PK) | AUTO_INCREMENT |
| `product_id` | Long | 제품 ID (FK) | NOT NULL |
| `account_seq` | Long | 등록자 계정 번호 | NOT NULL |
| `price` | Double | 가격 | NOT NULL |
| `currency` | String | 통화 | 3자, 기본값 'KRW' |
| `reason` | String | 변경 사유 | TEXT |
| `created_at` | LocalDateTime | 생성일시 | |
| `ended_at` | LocalDateTime | 종료일시 | |

---

### 4.8 User (사용자)

**테이블명**: `account_tb`

**설명**: 사용자 계정 정보를 관리하는 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `seq` | Long | 계정 번호 (PK) | AUTO_INCREMENT |
| `uuid` | String | 사용자 ID | NOT NULL, UNIQUE, 50자 |
| `name` | String | 이름 | NOT NULL, 10자 |
| `password` | String | 비밀번호 (암호화) | NOT NULL, 100자 |
| `grade` | String | 등급 | 3자, 기본값 'N' |
| `situation` | Integer | 상태 | 기본값 0 |

---

### 4.9 ProductCode (제품 코드)

**테이블명**: `product_code_tb`

**설명**: 제품 코드 조합을 관리하는 엔티티

| 필드명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `product_code_id` | Long | 코드 ID (PK) | AUTO_INCREMENT |
| `company_code` | String | 회사 코드 | NOT NULL, 4자 |
| `type_code` | String | 유형 코드 | NOT NULL, 4자 |
| `category_code` | String | 카테고리 코드 | NOT NULL, 4자 |
| `description` | String | 설명 | 255자 |

**유니크 제약조건**: `(company_code, type_code, category_code)`

---

### 4.10 CodeGroup / CodeItem (코드 그룹/항목)

**테이블명**: `code_group_tb`, `code_item_tb`

**설명**: 범용 코드 관리를 위한 엔티티

**CodeGroup 필드**:
| 필드명 | 타입 | 설명 |
|--------|------|------|
| `group_code` | String | 그룹 코드 (PK) |
| `group_name` | String | 그룹명 |
| `description` | String | 설명 |
| `is_active` | boolean | 활성화 여부 |
| `created_at` | LocalDateTime | 생성일시 |

**CodeItem 필드**:
| 필드명 | 타입 | 설명 |
|--------|------|------|
| `group_code` | String | 그룹 코드 (PK, FK) |
| `code` | String | 코드 (PK) |
| `code_name` | String | 코드명 |
| `is_active` | boolean | 활성화 여부 |
| `created_at` | LocalDateTime | 생성일시 |

---

### 4.11 CompanyCode / TypeCode / CategoryCode

**설명**: 제품 코드 구성요소를 관리하는 엔티티

**CompanyCode** (`company_code_tb`):
- `company_code` (PK): 회사 코드 (4자)
- `company_name`: 회사명

**TypeCode** (`type_code`):
- `type_code` (PK): 유형 코드 (10자)
- `type_name`: 유형명

**CategoryCode** (`category_code`):
- `category_code` (PK): 카테고리 코드 (10자)
- `category_name`: 카테고리명

---

## 5. DTO (Data Transfer Objects)

### 5.1 ClientResponse

**용도**: 거래처 조회 응답

```java
public class ClientResponse {
    private Long clientId;
    private String clientCode;
    private String companyCode;
    private String companyName;
    private String branchName;
    private String agencyName;
    private String address;
    private String managerName;
    private String regionalPhone;  // 포맷팅된 전화번호
    private String managerPhone;   // 포맷팅된 전화번호
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

### 5.2 CreateClientRequest

**용도**: 거래처 생성 요청

```java
public record CreateClientRequest(
    @NotBlank String companyCode,
    @Size(max = 100) String branchName,
    @Size(max = 100) String agencyName,
    @Size(max = 255) String address,
    @NotBlank @Size(max = 50) String managerName,
    @Pattern(regexp = "[0-9\\-]*") String regionalPhone,
    @NotBlank @Pattern(regexp = "[0-9\\-]+") String managerPhone
) {}
```

### 5.3 NextItemCodeResponse

**용도**: 다음 아이템 코드 응답

```java
public record NextItemCodeResponse(
    String productCode,
    String itemCode,
    String fullProductCode
) {}
```

### 5.4 PurchaseOrderSearchRequest

**용도**: 발주 검색 요청

```java
public record PurchaseOrderSearchRequest(
    String baseDateFrom,
    String baseDateTo,
    String prodCd,
    String custCd,
    Integer pageCurrent,
    Integer pageSize
) {}
```

---

## 6. Repository 계층

### 6.1 ProductRepository

**주요 메서드**:

| 메서드 | 설명 |
|--------|------|
| `existsByProductCodeAndItemCode()` | 제품코드+아이템코드 중복 확인 |
| `findTopByProductCodeOrderByItemCodeDesc()` | 특정 제품코드의 최신 아이템코드 조회 |
| `findTopByProductCodeStartingWith()` | 제품코드 접두사로 최신 항목 조회 |
| `existsByProductCode()` | 제품코드 존재 여부 확인 |
| `existsByAccountSeqAndProductCode()` | 계정+제품코드 중복 확인 |
| `findByProductCode()` | 제품코드로 조회 |
| `findAllWithPricesAndStock()` | 가격/재고 포함 전체 조회 |
| `findByProductCodeWithStock()` | 재고 포함 단일 조회 |
| `searchAllByKeyword()` | 키워드 검색 |

### 6.2 ProductVariantRepository

**주요 메서드**:

| 메서드 | 설명 |
|--------|------|
| `findByProductId()` | 제품 ID로 변형 목록 조회 |
| `findByProductIdAndPiecesPerBox()` | 제품 ID + 입수량으로 변형 조회 |
| `sumSubTotalByProductId()` | 제품의 변형 합계 조회 |
| `deleteByProductId()` | 제품의 모든 변형 삭제 |
| `existsByProductIdAndPiecesPerBox()` | 중복 입수량 확인 |

### 6.3 ClientRepository

**주요 메서드**:

| 메서드 | 설명 |
|--------|------|
| `findAllByOrderByCreatedAtDesc()` | 생성일 내림차순 전체 조회 (회사 정보 포함) |

---

## 7. Service 계층

### 7.1 ProductService

**핵심 서비스**: 제품 및 변형 관리

**주요 메서드**:

| 메서드 | 설명 |
|--------|------|
| `registerProduct()` | 제품 등록 (재고, 가격, 이미지 포함) |
| `getAllProducts()` | 전체 제품 조회 |
| `getProductByCode()` | 제품코드로 단일 조회 |
| `searchProducts()` | 키워드 검색 |
| `updateProduct()` | 제품 수정 (이력 기록 포함) |
| `getVariantsByProductId()` | 변형 목록 조회 |
| `addVariant()` | 변형 추가 |
| `updateVariant()` | 변형 수정 |
| `deleteVariant()` | 변형 삭제 |
| `validateVariantSum()` | 변형 합계 검증 |
| `getVariantSum()` | 변형 합계 조회 |

**제품 등록 프로세스**:
1. 제품 코드 생성 (회사_유형_카테고리_순번)
2. 제품 기본 정보 저장
3. 재고 정보 저장
4. 재고 변동 이력 저장
5. 가격 등록
6. 이미지 폴더 생성 및 이미지 저장

**제품 수정 프로세스**:
1. 기존 제품 조회
2. 변경 사항 감지 및 이력 저장
3. 재고 변경 시 재고 이력 저장
4. 가격 변경 시 새 가격 등록

### 7.2 ClientService

**주요 메서드**:

| 메서드 | 설명 |
|--------|------|
| `createClient()` | 거래처 생성 |
| `getClients()` | 거래처 목록 조회 |

---

## 8. Controller 계층

### 8.1 ProductController

**경로**: `/product/**`, `/inventory`

**주요 엔드포인트**:

| HTTP | 경로 | 설명 |
|------|------|------|
| GET | `/product/register` | 제품 등록 폼 |
| POST | `/product/register` | 제품 등록 처리 |
| GET | `/inventory` | 재고 목록 페이지 |
| GET | `/product` | 제품코드 관리 페이지 |
| GET | `/product/detail/{productCode}` | 제품 상세 |
| GET | `/product/details` | 전체 제품 상세 목록 |
| POST | `/product/update` | 제품 수정 |

### 8.2 ProductVariantController

**경로**: `/api/products/{productId}/variants`

**REST API 엔드포인트**:

| HTTP | 경로 | 설명 |
|------|------|------|
| GET | `/api/products/{productId}/variants` | 변형 목록 조회 |
| POST | `/api/products/{productId}/variants` | 변형 추가 |
| PUT | `/api/products/{productId}/variants/{variantId}` | 변형 수정 |
| DELETE | `/api/products/{productId}/variants/{variantId}` | 변형 삭제 |
| GET | `/api/products/{productId}/variants/validate` | 변형 합계 검증 |

### 8.3 ClientApiController

**경로**: `/api/clients`

**REST API 엔드포인트**:

| HTTP | 경로 | 설명 |
|------|------|------|
| GET | `/api/clients` | 거래처 목록 조회 |
| POST | `/api/clients` | 거래처 생성 |

---

## 9. 설정 클래스

### 9.1 SecurityConfig

**Spring Security 설정**:

```java
- CSRF 비활성화
- 공개 경로: /css/**, /js/**, /images/**, /media/**, /api/images/**, 
            /image-manager, /signup, /inventory
- 관리자 전용: /codes/**, /api/codes/**
- 나머지: 인증 필요
- 로그인 성공 시: /home 이동
- 비밀번호 암호화: BCryptPasswordEncoder
```

---

## 10. API 엔드포인트 목록

### 10.1 제품 관련

| HTTP | 경로 | 설명 | 인증 |
|------|------|------|------|
| GET | `/inventory` | 재고 목록 | 공개 |
| GET | `/product/register` | 등록 폼 | 필요 |
| POST | `/product/register` | 등록 처리 | 필요 |
| GET | `/product` | 코드 관리 | 필요 |
| GET | `/product/detail/{code}` | 상세 조회 | 필요 |
| POST | `/product/update` | 수정 | 필요 |

### 10.2 변형 관련 (REST API)

| HTTP | 경로 | 설명 | 인증 |
|------|------|------|------|
| GET | `/api/products/{id}/variants` | 목록 | 필요 |
| POST | `/api/products/{id}/variants` | 추가 | 필요 |
| PUT | `/api/products/{id}/variants/{vid}` | 수정 | 필요 |
| DELETE | `/api/products/{id}/variants/{vid}` | 삭제 | 필요 |
| GET | `/api/products/{id}/variants/validate` | 검증 | 필요 |

### 10.3 거래처 관련 (REST API)

| HTTP | 경로 | 설명 | 인증 |
|------|------|------|------|
| GET | `/api/clients` | 목록 | 필요 |
| POST | `/api/clients` | 생성 | 필요 |

---

## 11. 데이터베이스 스키마

### 11.1 테이블 관계도

```
account_tb (User)
    │
    ├──< product_tb (Product)
    │       │
    │       ├── stock_tb (Stock) [1:1]
    │       │
    │       ├──< price_tb (Price) [1:N]
    │       │
    │       ├──< product_variant_tb (ProductVariant) [1:N]
    │       │
    │       ├──< stock_history_tb (StockHistory) [1:N]
    │       │
    │       └──< product_change_history_tb (ProductChangeHistory) [1:N]
    │
    └──< price_tb (Price)

company_code_tb (CompanyCode)
    │
    └──< client_tb (Client) [1:N]

product_code_tb (ProductCode)
    - company_code
    - type_code
    - category_code

code_group_tb (CodeGroup)
    │
    └──< code_item_tb (CodeItem) [1:N]
```

---

## 부록: 변경 이력 추적 가이드

### A. 제품 변경 이력 (`product_change_history_tb`)

추적되는 필드:
- `product_code` - 제품 코드
- `item_code` - 아이템 코드
- `spec` - 규격
- `pd_name` - 제품명
- `active` - 사용 상태
- `min_stock_quantity` - 최소 재고
- `pieces_per_box` - 박스당 수량
- `sh_qty` - SH창고 수량
- `hp_qty` - HP창고 수량
- `total_qty` - 총재고
- `price` - 가격

### B. 재고 변경 이력 (`stock_history_tb`)

액션 유형:
- `IN` - 입고 (초기 등록 포함)
- `OUT` - 출고
- `ADJUST` - 조정

---

> **⚠️ 이 문서는 프로젝트의 핵심 기록입니다.**
> 
> 모든 기능 추가, 수정, 삭제는 반드시 CHANGELOG.md에 기록해야 합니다.

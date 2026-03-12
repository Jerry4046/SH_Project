# SH Project 개발 가이드라인

> **⚠️ 경고: 이 문서는 프로젝트의 핵심 개발 가이드입니다. 절대 삭제하지 마십시오.**
> 
> **문서 버전**: 1.0.0 | **생성일**: 2026-01-13

---

## 1. 개발 철학

### 1.1 핵심 원칙

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          유연한 개발 원칙                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ✅ 모듈 독립성     - 각 모듈은 독립적으로 개발/수정 가능                    │
│  ✅ 순서 무관       - 기능 추가 순서에 제약 없음                             │
│  ✅ 점진적 확장     - 작은 단위로 기능 추가 가능                             │
│  ✅ 느슨한 결합     - 모듈 간 의존성 최소화                                  │
│  ✅ 코드 재사용     - 공통 컴포넌트 활용                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 개발 방식

```
❌ 파이프라인 방식 (순차적)
   A → B → C → D → E
   (A 완료 후 B, B 완료 후 C...)

✅ 모듈러 방식 (유연)
   ┌───┐  ┌───┐  ┌───┐
   │ A │  │ B │  │ C │
   └───┘  └───┘  └───┘
      ↑      ↑      ↑
      └──────┼──────┘
             │
        언제든 추가/수정 가능
```

---

## 2. 모듈 구조

### 2.1 독립 모듈 목록

각 모듈은 **독립적으로 개발 가능**합니다. 순서 없이 필요한 모듈부터 개발하세요.

| 모듈 | 의존성 | 독립 개발 | 설명 |
|------|--------|-----------|------|
| **인증** | 없음 | ✅ | 로그인/로그아웃 |
| **제품** | 코드 | ✅ | 제품 CRUD |
| **재고** | 제품 | ✅ | 재고 관리 |
| **거래처** | 코드 | ✅ | 거래처 CRUD |
| **코드** | 없음 | ✅ | 공통코드 관리 |
| **단가** | 제품 | ✅ | 가격 이력 |
| **입고** | 제품, 재고 | ✅ | 입고 관리 |
| **출고** | 제품, 재고, 주문 | ⚠️ | 출고 관리 |
| **주문** | 제품, 거래처 | ✅ | 주문 관리 |
| **캘린더** | 없음 | ✅ | 일정 관리 |

### 2.2 모듈 의존성 다이어그램

```
                    ┌─────────┐
                    │  코드   │ ← 기반 모듈 (먼저 개발 권장)
                    └────┬────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
    ┌─────────┐    ┌─────────┐    ┌─────────┐
    │  제품   │    │ 거래처  │    │  인증   │
    └────┬────┘    └────┬────┘    └─────────┘
         │               │
         ├───────────────┤
         │               │
         ▼               ▼
    ┌─────────┐    ┌─────────┐
    │  재고   │    │  주문   │
    └────┬────┘    └────┬────┘
         │               │
         └───────┬───────┘
                 │
                 ▼
    ┌─────────────────────┐
    │   입고  │   출고    │
    └─────────────────────┘

[독립 모듈 - 언제든 추가 가능]
┌─────────┐  ┌─────────┐  ┌─────────┐
│ 캘린더  │  │  단가   │  │  기타   │
└─────────┘  └─────────┘  └─────────┘
```

---

## 3. 기능 추가 가이드

### 3.1 새 기능 추가 체크리스트

```
□ 1. 어떤 모듈에 속하는지 확인
□ 2. 의존하는 모듈이 있는지 확인
□ 3. 필요한 테이블/컬럼 확인
□ 4. 기존 코드에 영향 있는지 확인
□ 5. 구현
□ 6. CHANGELOG.md 업데이트
```

### 3.2 기능 추가 예시

#### 예시 1: 독립 기능 추가 (의존성 없음)
```
[새 기능] 캘린더에 알림 기능 추가

영향 범위: calendar 모듈만
의존성: 없음
추가 작업:
  - CalendarService.java 수정
  - calendar.jsp 수정
  - CHANGELOG.md 업데이트
```

#### 예시 2: 기존 모듈 확장
```
[새 기능] 제품에 이미지 다중 업로드 추가

영향 범위: product 모듈
의존성: 없음 (기존 product_tb 활용)
추가 작업:
  - product_image_tb 테이블 추가 (선택)
  - ProductImageService.java 추가
  - productdetail.jsp 수정
  - CHANGELOG.md 업데이트
```

#### 예시 3: 모듈 간 연동
```
[새 기능] 출고 시 캘린더 자동 일정 생성

영향 범위: outbound, calendar 모듈
의존성: 출고 → 캘린더
추가 작업:
  - OutboundService.java에서 CalendarService 호출
  - CalendarService.java에 일정 생성 메서드 추가
  - CHANGELOG.md 업데이트
```

---

## 4. 코드 구조 가이드

### 4.1 패키지 구조

```
src/main/java/com/project/SH/
├── controller/          # 컨트롤러 (모듈별)
│   ├── ProductController.java
│   ├── ClientController.java
│   ├── InboundController.java    # 새 모듈 추가 시
│   └── ...
├── service/             # 서비스 (비즈니스 로직)
│   ├── ProductService.java
│   ├── ClientService.java
│   ├── InboundService.java       # 새 모듈 추가 시
│   └── ...
├── repository/          # 리포지토리 (DB 접근)
│   ├── ProductRepository.java
│   └── ...
├── domain/              # 엔티티
│   ├── Product.java
│   ├── Inbound.java              # 새 테이블 추가 시
│   └── ...
├── dto/                 # DTO (데이터 전송 객체)
│   └── ...
└── config/              # 설정
    └── ...
```

### 4.2 새 모듈 추가 시 필요 파일

```
[새 모듈: 입고(Inbound)]

1. 엔티티
   domain/Inbound.java

2. 리포지토리
   repository/InboundRepository.java

3. 서비스
   service/InboundService.java

4. 컨트롤러
   controller/InboundController.java
   controller/InboundApiController.java (REST API용)

5. 화면
   views/inbound.jsp
   views/inbound-detail.jsp (선택)

6. 문서
   docs/system/inbound/01_SYSTEM_ARCHITECTURE.md
   docs/system/inbound/...
```

### 4.3 공통 컴포넌트 활용

```java
// 공통 코드 조회 (어느 모듈에서든 사용 가능)
@Autowired
private CodeService codeService;

List<CodeItem> statusCodes = codeService.getCodesByGroup("IN_STATUS");

// 공통 응답 형식
return ResponseEntity.ok(Map.of(
    "success", true,
    "data", result,
    "message", "처리 완료"
));
```

---

## 5. 데이터베이스 확장 가이드

### 5.1 테이블 추가 원칙

```
✅ 권장
- 새 테이블 생성 시 기존 테이블에 영향 없음
- FK 관계는 필요한 경우에만 설정
- 코드 테이블 활용 (상태, 유형 등)

⚠️ 주의
- 기존 테이블 컬럼 수정 시 영향 범위 확인
- NOT NULL 컬럼 추가 시 기본값 설정 필수
```

### 5.2 컬럼 추가 예시

```sql
-- 기존 테이블에 컬럼 추가 (안전)
ALTER TABLE product_tb 
ADD COLUMN new_field VARCHAR(100) DEFAULT NULL;

-- 기존 데이터에 영향 없음
```

### 5.3 코드 테이블 활용

```sql
-- 새 상태 코드 추가 (기존 코드에 영향 없음)
INSERT INTO code_group_tb (group_code, group_name, is_active) 
VALUES ('NEW_STATUS', '새상태코드', 1);

INSERT INTO code_item_tb (group_code, code, code_name, is_active) 
VALUES ('NEW_STATUS', 'STATUS1', '상태1', 1);
```

---

## 6. API 설계 가이드

### 6.1 RESTful API 규칙

```
[기본 패턴]
GET    /api/{모듈}          - 목록 조회
GET    /api/{모듈}/{id}     - 단건 조회
POST   /api/{모듈}          - 등록
PUT    /api/{모듈}/{id}     - 수정
DELETE /api/{모듈}/{id}     - 삭제

[예시]
GET    /api/inbound         - 입고 목록
POST   /api/inbound         - 입고 등록
PUT    /api/inbound/123     - 입고 수정
DELETE /api/inbound/123     - 입고 삭제
```

### 6.2 응답 형식 통일

```json
{
  "success": true,
  "data": { ... },
  "message": "처리 완료",
  "timestamp": "2026-01-13T16:00:00"
}
```

---

## 7. 화면 개발 가이드

### 7.1 JSP 템플릿 구조

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>페이지 제목</title>
</head>
<body>
<div class="container mt-4">
    <!-- 페이지 내용 -->
</div>

<script>
// JavaScript 코드
</script>
</body>
</html>
```

### 7.2 공통 UI 컴포넌트

```
[재사용 가능한 컴포넌트]
- header.jsp: 공통 헤더/네비게이션
- Bootstrap 5: 스타일링
- 테이블 템플릿: 목록 화면
- 모달 템플릿: 상세/등록 폼
- 검색 필터: 검색 UI
```

---

## 8. 개발 워크플로우

### 8.1 기능 개발 순서 (권장, 필수 아님)

```
1. [선택] 문서 작성 (설계)
   └─ 복잡한 기능일 경우 권장

2. [필수] DB 스키마 (필요시)
   └─ 테이블/컬럼 추가

3. [필수] 백엔드 개발
   └─ Entity → Repository → Service → Controller

4. [필수] 프론트엔드 개발
   └─ JSP 화면 + JavaScript

5. [필수] 테스트

6. [필수] CHANGELOG 업데이트
```

### 8.2 빠른 프로토타이핑

```
[간단한 기능은 바로 구현]

1. Controller에 엔드포인트 추가
2. JSP에 UI 추가
3. 테스트
4. CHANGELOG 업데이트

※ 문서화는 나중에 해도 됨
```

---

## 9. 주의사항

### 9.1 하지 말아야 할 것

```
❌ 기존 API 시그니처 변경 (파라미터, 반환값)
❌ 기존 테이블 컬럼 삭제
❌ 공통 컴포넌트 임의 수정
❌ 하드코딩 (코드 테이블 활용)
❌ CHANGELOG 미기록
```

### 9.2 해야 할 것

```
✅ 새 기능은 새 파일/메서드로 추가
✅ 기존 코드 수정 시 영향 범위 확인
✅ 코드 테이블 활용 (상태, 유형 등)
✅ 모든 변경 CHANGELOG 기록
✅ 주석/문서 유지
```

---

## 10. 빠른 참조

### 10.1 새 모듈 추가 체크리스트

```
□ Entity 클래스 생성
□ Repository 인터페이스 생성
□ Service 클래스 생성
□ Controller 클래스 생성
□ JSP 화면 생성
□ 헤더 메뉴 추가 (필요시)
□ CHANGELOG 업데이트
□ 문서화 (선택)
```

### 10.2 기존 모듈 수정 체크리스트

```
□ 영향 범위 확인
□ 기존 테스트 통과 확인
□ 새 기능 테스트
□ CHANGELOG 업데이트
```

---

> **핵심 메시지**: 순서에 얽매이지 말고, 필요한 기능을 필요한 시점에 추가하세요. 
> 모듈 간 결합도를 낮게 유지하면 언제든 유연하게 확장할 수 있습니다.

# 05. ERD 명세서 - 입출고 관리 (InOut)

문서 버전: 1.0.0 | 생성일: 2026-01-12

---

## 1. 주요 테이블

### inbound_tb (입고 마스터)

| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| inbound_id | BIGINT | PK |
| inbound_no | VARCHAR | 입고번호 |
| status | VARCHAR | 상태 |

### inbound_item_tb (입고 상세)

| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| item_id | BIGINT | PK |
| inbound_id | BIGINT | FK → inbound_tb |
| product_id | BIGINT | FK → product_tb |
| qty | INT | 수량 |

### outbound_tb (출고 마스터)

| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| outbound_id | BIGINT | PK |
| outbound_no | VARCHAR | 출고번호 |
| status | VARCHAR | 상태 |

### outbound_item_tb (출고 상세)

| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| item_id | BIGINT | PK |
| outbound_id | BIGINT | FK → outbound_tb |
| product_id | BIGINT | FK → product_tb |
| qty | INT | 수량 |

### stock_tb (재고)

| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| stock_id | BIGINT | PK |
| product_id | BIGINT | FK → product_tb |
| sh_qty | INT | SH 창고 수량 |
| hp_qty | INT | HP 창고 수량 |

---

## 2. ERD 다이어그램

```mermaid
erDiagram
    PRODUCT_TB ||--o{ INBOUND_ITEM_TB : receives
    PRODUCT_TB ||--o{ OUTBOUND_ITEM_TB : ships
    PRODUCT_TB ||--|| STOCK_TB : has
    INBOUND_TB ||--o{ INBOUND_ITEM_TB : contains
    OUTBOUND_TB ||--o{ OUTBOUND_ITEM_TB : contains
    ORDER_TB ||--o{ OUTBOUND_TB : fulfills

    INBOUND_TB {
        BIGINT inbound_id PK
        VARCHAR inbound_no
        VARCHAR status
        DATE inbound_date
    }

    INBOUND_ITEM_TB {
        BIGINT item_id PK
        BIGINT inbound_id FK
        BIGINT product_id FK
        INT qty
    }

    OUTBOUND_TB {
        BIGINT outbound_id PK
        VARCHAR outbound_no
        VARCHAR status
        DATE outbound_date
        VARCHAR tracking_no
    }

    OUTBOUND_ITEM_TB {
        BIGINT item_id PK
        BIGINT outbound_id FK
        BIGINT product_id FK
        INT qty
    }

    STOCK_TB {
        BIGINT stock_id PK
        BIGINT product_id FK
        INT sh_qty
        INT hp_qty
        INT total_qty
    }
```

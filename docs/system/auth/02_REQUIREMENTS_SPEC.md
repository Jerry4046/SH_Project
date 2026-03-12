# 02. 요구사항 명세서 - 인증/사용자 (Auth)

문서 버전: 1.0.0 | 생성일: 2026-01-12

---

## 1. 기능 요구사항

### REQ-AUTH-001: 로그인

- 입력: 아이디(uuid), 비밀번호
- 처리: Spring Security 폼 로그인
- 성공: /home 이동, 세션 생성
- 실패: 에러 메시지 표시

### REQ-AUTH-002: 로그아웃

- 처리: 세션 무효화, /login 이동

### REQ-AUTH-003: 회원가입 (관리자 전용)

- 입력: 아이디, 이름, 비밀번호, 등급
- 처리: BCrypt 암호화 후 저장
- 검증: 아이디 중복 체크

### REQ-AUTH-004: 권한 제어

- 사용자 등급에 따른 메뉴 접근 제어
- 관리자 전용: /codes/manage, /signup

---

## 2. 데이터 항목 (account_tb)

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| seq | BIGINT | PK, 자동증가 | 시퀀스 |
| uuid | VARCHAR(50) | 필수, UNIQUE | 로그인 ID |
| name | VARCHAR(50) | 필수 | 사용자명 |
| password | VARCHAR(255) | 필수 | BCrypt 암호화 |
| grade | CHAR(1) | 필수 | 등급 (A/N) |
| situation | VARCHAR(20) | - | 상태 |

---

## 3. 비기능 요구사항

- **NFR-AUTH-001**: 비밀번호 암호화 - BCrypt
- **NFR-AUTH-002**: 세션 타임아웃 - 30분

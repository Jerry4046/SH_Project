# 01. 시스템 구상도 - 인증/사용자 (Auth)

문서 버전: 1.0.0 | 생성일: 2026-01-12

---

## 1. 시스템 개요

### 1.1 목적

- 사용자 인증 및 세션 관리
- 권한 기반 접근 제어
- 회원 관리 (관리자 전용)

---

## 2. 인증 흐름

### 2.1 로그인 프로세스

- 아이디/비밀번호 입력
- Spring Security 인증 (BCrypt 비밀번호 검증)
- 성공 시: 세션 생성 → /home 이동
- 실패 시: 에러 메시지 표시

### 2.2 세션 관리

- Spring Security 기반 세션 관리
- 세션 타임아웃: 30분
- 로그아웃 시 세션 무효화

---

## 3. 권한 체계

| 등급 | 코드 | 권한 |
|------|------|------|
| 관리자 | A | 전체 기능 + 회원관리 + 코드관리 |
| 일반 | N | 기본 기능 (제품/주문/입출고/거래처) |

---

## 4. 관련 파일

### Backend:

- User.java (domain/) - 사용자 엔티티
- UserRepository.java (repository/) - 사용자 리포지토리
- SecurityConfig.java (config/) - Spring Security 설정
- CustomUserDetails.java (config/) - 사용자 상세 정보
- CustomUserDetailsService.java (config/) - 사용자 로드 서비스

### Frontend:

- login.jsp (views/) - 로그인 화면
- signup.jsp (views/) - 회원가입 화면
- header.jsp (views/common/) - 공통 헤더

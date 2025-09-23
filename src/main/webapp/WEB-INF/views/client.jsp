<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %> <!-- ✅ 헤더 콘텐츠 -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>거래처 목록</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-4 border-0">
                    <div class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-between">
                        <div>
                            <h1 class="h3 mb-1">거래처 목록</h1>
                            <p class="text-muted mb-0">주요 거래처 정보를 한눈에 확인하세요.</p>
                        </div>
                        <a href="#" class="btn btn-primary mt-3 mt-sm-0" role="button" aria-disabled="true">거래처 등록</a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th scope="col">회사 이름</th>
                                <th scope="col">지점명</th>
                                <th scope="col">대리점명</th>
                                <th scope="col">주소</th>
                                <th scope="col">성함</th>
                                <th scope="col">연락처</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td class="fw-semibold">에이비씨 상사</td>
                                <td>서울 강남지점</td>
                                <td>강남 대리점</td>
                                <td>서울특별시 강남구 테헤란로 123</td>
                                <td>김철수</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">02-1234-5678</span></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">스타물산</td>
                                <td>부산 해운대지점</td>
                                <td>해운대 대리점</td>
                                <td>부산광역시 해운대구 센텀로 45</td>
                                <td>이영희</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">051-987-6543</span></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">굿모닝 유통</td>
                                <td>대구 중구지점</td>
                                <td>중구 직영 대리점</td>
                                <td>대구광역시 중구 동성로 89</td>
                                <td>박민수</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">053-222-3333</span></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">헤리티지 트레이딩</td>
                                <td>광주 첨단지점</td>
                                <td>첨단 파트너 대리점</td>
                                <td>광주광역시 북구 첨단과기로 77</td>
                                <td>최수정</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">062-444-5555</span></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">네오텍</td>
                                <td>대전 둔산지점</td>
                                <td>둔산 프리미엄 대리점</td>
                                <td>대전광역시 서구 둔산대로 102</td>
                                <td>정우성</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">042-666-7777</span></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
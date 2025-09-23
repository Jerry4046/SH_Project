<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- ✅ Bootstrap CSS (static 경로 기준) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.min.css">

<!-- ✅ 커스텀 CSS (optional) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">

<!-- ✅ 상단 네비게이션 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">재고관리 시스템</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/inventory">제품</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/sales">매출</a></li>
                <li class="nav-item"><a class="nav-link" href="report.jsp">송장</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/price">단가맵</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client">거래처</a></li>
                <li class="nav-item"><a class="nav-link" href="stockIn.jsp">입고 관리</a></li>
                <li class="nav-item"><a class="nav-link" href="stockOut.jsp">출고 관리</a></li>
            </ul>
        </div>

        <!-- 🔹 세션 사용자 정보 출력 -->
        <span class="navbar-text text-white me-3">
            사용자 : ${sessionScope.grade eq 'A' ? '관리자' : sessionScope.username}
        </span>

        <!-- 🔹 관리자 회원관리 버튼 -->
        <c:if test="${sessionScope.grade eq 'A'}">
            <span class="navbar-text text-white me-3">
                <a class="btn btn-outline-light me-3" href="${pageContext.request.contextPath}/signup">회원관리</a>
            </span>
        </c:if>

        <c:if test="${sessionScope.grade ne 'A'}">
            <span class="navbar-text text-white me-3">
                <a class="btn btn-outline-light me-3">권한없음</a>
            </span>
        </c:if>

        <!-- 🔹 로그아웃 버튼 -->
        <a class="btn btn-outline-light me-3" href="${pageContext.request.contextPath}/logout">로그아웃</a>
    </div>
</nav>

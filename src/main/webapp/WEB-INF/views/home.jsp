<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %> <!-- ✅ 헤더 콘텐츠 -->

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SH실업 재고관리 시스템</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- ✅ Bootstrap CSS (static 경로 기준) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.min.css">

    <!-- ✅ 커스텀 CSS (optional) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<!-- ✅ 메인 콘텐츠 -->
<div class="container mt-4">
    <div class="row">
        <!-- 1. 매출 카드 -->
        <div class="col-md-4">
            <div class="card border-success mb-4">
                <div class="card-header bg-success text-white">
                    매출 정보
                </div>
                <div class="card-body">
                    <ul class="list-group">
                        <li class="list-group-item">금일 매출: <strong>${todaySales}</strong></li>
                        <li class="list-group-item">주간 매출: <strong>${weeklySales}</strong></li>
                        <li class="list-group-item">분기 매출: <strong>${quarterSales}</strong></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 2. 제품 카드 -->
        <div class="col-md-4">
            <div class="card border-primary mb-4">
                <div class="card-header bg-primary text-white">
                    제품 정보
                </div>
                <div class="card-body">
                    <ul class="list-group">
                        <li class="list-group-item">총 제품 수: <strong>${totalProducts}</strong></li>
                        <li class="list-group-item">총 재고 수량: <strong>${totalStock}</strong></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 3. 입고 카드 -->
        <div class="col-md-4">
            <div class="card border-warning mb-4">
                <div class="card-header bg-warning text-dark">
                    입출고 정보
                </div>
                <div class="card-body">
                    <ul class="list-group">
                        <li class="list-group-item">금일 입고: <strong>${todayStockIn}</strong></li>
                        <li class="list-group-item">금일 출고: <strong>${todayStockOut}</strong></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ✅ Bootstrap JS -->
<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>

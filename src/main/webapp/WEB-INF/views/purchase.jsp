<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>발주서 조회</title>
    <link rel="stylesheet" href="<c:url value='/css/bootstrap.min.css'/>">
    <style>
        .table-container {
            overflow-x: auto;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="mb-1">발주서 조회</h2>
            <p class="mb-0 text-muted">조회 기간: ${baseDateFrom} ~ ${baseDateTo}</p>
        </div>
        <div>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/home">홈으로</a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="table-container mb-4">
                <table class="table table-bordered table-striped align-middle text-center">
                    <thead class="table-light">
                    <tr>
                        <c:forEach var="col" items="${columns}">
                            <th scope="col">${col}</th>
                        </c:forEach>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <c:forEach var="col" items="${columns}">
                                <td>${order[col]}</td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">표시할 발주서가 없습니다.</div>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty rawResponse}">
        <div class="card">
            <div class="card-header">원본 응답</div>
            <div class="card-body">
                <pre class="mb-0" style="white-space: pre-wrap; word-break: break-all;">${fn:escapeXml(rawResponse)}</pre>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
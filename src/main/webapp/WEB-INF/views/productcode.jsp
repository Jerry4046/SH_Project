<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>상품 코드 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="container mt-5">
    <h2>상품 코드 선택</h2>
    <select name="productCode" class="form-select mt-3">
        <option value="">선택</option>
        <c:forEach var="code" items="${productCodes}">
            <option value="${code.fullCode}">${code.fullCode}</option>
        </c:forEach>
    </select>
</div>
</body>
</html>
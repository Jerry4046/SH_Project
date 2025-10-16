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
            <option value="${code.productCode}">
                            ${companyNames[code.companyInitial]}_${typeNames[code.typeCode]}_${categoryNames[code.categoryCode]}
            </option>
        </c:forEach>
    </select>

    <h3 class="mt-4">상품 목록</h3>
    <table class="table table-hover mt-2">
        <thead>
        <tr>
            <th>상품코드</th>
            <th>제품명</th>
            <th>단가</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="product" items="${productList}">
            <tr>
                <td>${product.fullProductCode}</td>
                <td>${product.pdName}</td>
                <td>${product.getPrice()}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
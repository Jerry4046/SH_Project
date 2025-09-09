<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>제품 전체 상세</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container mt-5">
    <h2>제품 전체 상세 정보</h2>
    <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>등록자</th>
                <th>상품코드</th>
                <th>제품코드</th>
                <th>규격</th>
                <th>제품이름</th>
                <th>박스당 수량</th>
                <th>박스재고</th>
                <th>낱개</th>
                <th>총재고</th>
                <th>최소재고</th>
                <th>사용상태</th>
                <th>생성일자</th>
                <th>업데이트 일자</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="product" items="${productList}">
                <tr class="${product.active ? '' : 'text-muted'}">
                    <td><c:out value="${product.user.name}"/></td>
                    <td>${product.productCode}</td>
                    <td>${product.itemCode}</td>
                    <td>${product.spec}</td>
                    <td>${product.pdName}</td>
                    <td>${product.stock.piecesPerBox}</td>
                    <td>${product.stock.boxQty} BOX</td>
                    <td>${product.stock.looseQty} 장</td>
                    <td>${product.stock.totalQty} 장</td>
                    <td>${product.minStockQuantity} 장</td>
                    <td>
                        <c:choose>
                            <c:when test="${product.active}">
                                <span class="badge bg-success">사용중</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">미사용</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${product.createdAt}</td>
                    <td>${product.updatedAt}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
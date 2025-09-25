<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>제품 전체 상세</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">제품 전체 상세 정보</h2>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/product/register" class="btn btn-outline-primary">등록</a>
            <button type="button" class="btn btn-outline-warning" onclick="showPendingAlert('수정');">수정</button>
            <button type="button" class="btn btn-outline-danger" onclick="showPendingAlert('삭제');">삭제</button>
        </div>
    </div>

    <div class="mb-3">
        <input type="text" class="form-control" placeholder="상품명, 제품코드, 상품코드를 검색하세요" id="searchInput">
    </div>

    <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>등록자</th>
                <th>상품코드</th>
                <th>제품코드</th>
                <th>규격</th>
                <th>제품이름</th>
                <th>입수량</th>
                <th>BOX</th>
                <th>낱개</th>
                <th>총재고</th>
                <th>최소재고</th>
                <th>단가</th>
                <th>사용여부</th>
                <th>생성일자</th>
                <th>수정일자</th>
            </tr>
            </thead>
            <tbody id="productTable">
            <c:forEach var="product" items="${productList}">
                <tr class="${product.active ? '' : 'text-muted'}">
                    <td><c:out value="${product.user.name}"/></td>
                    <td>${product.fullProductCode}</td>
                    <td>${product.itemCode}</td>
                    <td>${product.spec}</td>
                    <td>${product.pdName}</td>
                    <td><c:out value="${empty product.stock.piecesPerBox ? 0 : product.stock.piecesPerBox}"/> ea</td>
                    <td><c:out value="${empty product.stock.boxQty ? 0 : product.stock.boxQty}"/> BOX</td>
                    <td><c:out value="${empty product.stock.looseQty ? 0 : product.stock.looseQty}"/> ea</td>
                    <td><c:out value="${empty product.stock.totalQty ? 0 : product.stock.totalQty}"/> ea</td>
                    <td>${product.minStockQuantity} ea</td>
                    <td>${product.getPrice()} 원</td>
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
                        <td>${product.formattedCreatedAt}</td>
                        <td>${product.formattedUpdatedAt}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script>
    function filterTable() {
        const input = document.getElementById("searchInput").value.toLowerCase();
        const rows = document.querySelectorAll("#productTable tr");

        rows.forEach(row => {
            const productCodeCell = row.cells[1];
            const itemCodeCell = row.cells[2];
            const nameCell = row.cells[4];
            if (!productCodeCell || !nameCell) return;

            const productCode = productCodeCell.textContent.toLowerCase();
            const itemCode = itemCodeCell ? itemCodeCell.textContent.toLowerCase() : "";
            const name = nameCell.textContent.toLowerCase();

            row.style.display = (productCode.includes(input) || itemCode.includes(input) || name.includes(input)) ? "" : "none";
            });
    }

    document.getElementById("searchInput").addEventListener("input", filterTable);
</script>

</body>
</html>
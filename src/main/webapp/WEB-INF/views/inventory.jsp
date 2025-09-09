<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>제품 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" /> <!-- ✅ 헤더 포함 -->

<div class="container mt-5">

    <!-- 제목 + 버튼 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>제품 목록</h2>
        <div class="d-flex gap-2">
            <a href="/product/detail" class="btn btn-outline-primary" onclick="toggleRegisterRow()">상세</a>
            <a href="#" class="btn btn-outline-primary" onclick="toggleRegisterRow()">등록</a>
            <a href="/product/edit" class="btn btn-outline-warning">수정</a>
            <a href="/product/delete" class="btn btn-outline-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        </div>
    </div>

    <!-- 검색창 -->
    <div class="mb-3">
        <input type="text" class="form-control" placeholder="상품명을 검색하세요" id="searchInput" onkeyup="filterTable()">
    </div>

    <!-- 테이블 -->
    <div class="table-responsive">
            <form id="registerForm" action="${pageContext.request.contextPath}/product/register" method="post">
                <table class="table table-hover align-middle text-center">
                    <thead class="table-light">
                        <tr>
                            <th>상품명</th>
                            <th>박스당 수량</th>
                            <th>박스재고</th>
                            <th>낱개</th>
                            <th>총재고</th>
                            <th>단가</th>
                            <th>최소재고</th>
                            <th>사용여부</th>
                            <th>상세</th>
                        </tr>
                    </thead>
                            <tbody id="productTable">
                                <tr id="registerRow" style="display:none;">
                                    <td><input type="text" name="pdName" class="form-control form-control-sm" required></td>
                                    <td><input type="number" name="piecesPerBox" class="form-control form-control-sm" min="1" value="1" required></td>
                                    <td class="text-muted">-</td>
                                    <td class="text-muted">-</td>
                                    <td><input type="number" name="totalQty" class="form-control form-control-sm" min="0" value="0" required></td>
                                    <td><input type="number" name="price" class="form-control form-control-sm" required></td>
                                    <td><input type="number" name="minStockQuantity" class="form-control form-control-sm" min="0" value="0" required></td>
                                    <td>
                            <td>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="active" value="true" checked>
                                    <label class="form-check-label">사용</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="active" value="false">
                                    <label class="form-check-label">미사용</label>
                                </div>
                                <div class="mt-1">
                                    <input type="hidden" name="companyCode" value="">
                                    <input type="hidden" name="typeCode" value="">
                                    <input type="hidden" name="categoryCode" value="">
                                    <input type="hidden" name="itemCode" value="">
                                    <input type="hidden" name="spec" value="">
                                </div>
                            </td>
                            <td class="text-muted">-</td>
                        </tr>
                         <c:forEach var="product" items="${productList}">
                                                    <tr class="${product.active ? '' : 'text-muted'}">
                                                        <td>${product.pdName}</td>
                                                        <td>${product.piecesPerBox}</td>
                                                        <td>${product.totalQty / product.piecesPerBox}</td>
                                                        <td>${product.totalQty % product.piecesPerBox}</td>
                                                        <td>${product.totalQty}</td>
                                                        <td>${product.getPrice()}</td>
                                                        <td>${product.minStockQuantity}</td>
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
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/product/detail/${product.productCode}" class="btn btn-sm btn-outline-primary">상세</a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </form>
                            </div>
                        </div>

<!-- ✅ 검색 필터 + 등록행 토글 스크립트 -->
<script>
    function filterTable() {
        const input = document.getElementById("searchInput").value.toLowerCase();
        const rows = document.querySelectorAll("#productTable tr");

        rows.forEach(row => {
            if (row.id === "registerRow") return;

            const nameCell = row.cells[0];
            if (!nameCell) return;
            const name = nameCell.textContent.toLowerCase();

            row.style.display = name.includes(input) ? "" : "none";
        });
    }

    function toggleRegisterRow() {
        const row = document.getElementById("registerRow");
        row.style.display = row.style.display === "none" ? "" : "none";
    }

</script>

</body>
</html>

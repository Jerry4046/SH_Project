<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>제품 상세</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container mt-5">
    <c:choose>
        <c:when test="${empty product}">
            <h2>제품 등록</h2>
            <form action="${pageContext.request.contextPath}/product/register" method="post" class="mt-3">
                <div class="mb-3">
                    <label class="form-label">회사</label>
                    <select name="companyCode" id="companyCode" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="entry" items="${companyNames}">
                            <option value="${entry.key}">${entry.value}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">유형</label>
                    <select name="typeCode" id="typeCode" class="form-select" disabled>
                        <option value="">선택하세요</option>
                        <c:forEach var="entry" items="${typeNames}">
                            <option value="${entry.key}">${entry.value}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">카테고리</label>
                    <select name="categoryCode" id="categoryCode" class="form-select" disabled>
                        <option value="">선택하세요</option>
                        <c:forEach var="entry" items="${categoryNames}">
                            <option value="${entry.key}">${entry.value}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">아이템 코드</label>
                    <input type="text" name="itemCode" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">규격</label>
                    <input type="text" name="spec" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">상품명</label>
                    <input type="text" name="pdName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">박스당 수량</label>
                    <input type="number" name="piecesPerBox" class="form-control" min="1" value="1" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">총재고</label>
                    <input type="number" name="totalQty" class="form-control" min="0" value="0" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">단가</label>
                    <input type="number" name="price" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">최소재고</label>
                    <input type="number" name="minStockQuantity" class="form-control" min="0" value="0" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">사용여부</label>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="active" value="true" checked>
                        <label class="form-check-label">사용</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="active" value="false">
                        <label class="form-check-label">미사용</label>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">등록</button>
            </form>
        </c:when>
        <c:otherwise>
            <h2>제품 상세 정보</h2>
            <div class="table-responsive">
                <table class="table table-hover align-middle text-center">
                    <thead class="table-light">
                    <tr>
                        <th>사용자Seq</th>
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
                    <tr class="${product.active ? '' : 'text-muted'}">
                        <td>${product.accountSeq}</td>
                        <td>${product.productCode}</td>
                        <td>${product.itemCode}</td>
                        <td>${product.spec}</td>
                        <td>${product.pdName}</td>
                        <td>${product.piecesPerBox}</td>
                        <td>${product.totalQty / product.piecesPerBox}</td>
                        <td>${product.totalQty % product.piecesPerBox}</td>
                        <td>${product.totalQty}</td>
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
                        <td>${product.createdAt}</td>
                        <td>${product.updatedAt}</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    const companySelect = document.getElementById('companyCode');
    const typeSelect = document.getElementById('typeCode');
    const categorySelect = document.getElementById('categoryCode');

    function updateTypeCategory() {
        if (!companySelect || !typeSelect || !categorySelect) return;
        if (!companySelect.value) {
            typeSelect.value = '';
            categorySelect.value = '';
            typeSelect.disabled = true;
            categorySelect.disabled = true;
        } else {
            typeSelect.disabled = false;
            categorySelect.disabled = false;
        }
    }

    if (companySelect) {
        companySelect.addEventListener('change', updateTypeCategory);
        updateTypeCategory();
    }
</script>

</body>
</html>
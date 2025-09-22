<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>단가맵</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" /> <!-- 헤더 포함 -->

<div class="container mt-5">

    <!-- 제목 + 버튼 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>단가맵</h2>
        <div class="d-flex gap-2">
            <a href="/product/edit" class="btn btn-outline-warning">수정</a>
            <a href="/product/delete" class="btn btn-outline-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        </div>
    </div>
    
    <!-- 검색창 -->
    <div class="mb-3">
        <input type="text" class="form-control" placeholder="상품명 또는 상품코드를 검색하세요" id="searchInput" onkeyup="filterTable()">
    </div>

    <!-- 테이블 -->
    <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
                <tr>
                    <th>상품코드</th>
                    <th>상품명</th>
                    <th>단가</th>
                    <th>수정일자</th>
                    <th>생성일자</th>
                    <th>수정이유</th>
                    <th>사용여부</th>
                </tr>
            </thead>
            <tbody id="productTable">

                <!-- 상품 목록 출력 -->
                <c:forEach var="product" items="${productList}">
                    <c:forEach var="price" items="${product.prices}">
                        <tr class="${product.active ? '' : 'text-muted'}">
                            <td>${product.productCode}</td>
                            <td>${product.pdName}</td>
                            <td>${price.price}</td> <!-- 단가 -->
                            <td>${price.updatedAt}</td> <!-- 수정일자 -->
                            <td>${price.createdAt}</td> <!-- 생성일자 -->
                            <td>${price.reason}</td> <!-- 수정이유 -->
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
                        </tr>
                    </c:forEach>
                </c:forEach>

            </tbody>
        </table>
    </div>
</div>

<!-- 검색 필터 + 등록행 토글 스크립트 -->
<script>
    // 필터 기능
    function filterTable() {
        const input = document.getElementById("searchInput").value.toLowerCase();
        const rows = document.querySelectorAll("#productTable tr");

        rows.forEach(row => {
            // 등록행은 필터에서 제외
            const nameCell = row.cells[1]; // 상품명
            const codeCell = row.cells[0]; // 상품코드

            if (!nameCell || !codeCell) return;

            const name = nameCell.textContent.toLowerCase();
            const code = codeCell.textContent.toLowerCase();

            if (name.includes(input) || code.includes(input)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    }

    // 테이블 정렬: '수정일자'를 기준으로 내림차순 정렬
    function sortTableByDate() {
        const rows = Array.from(document.querySelectorAll("#productTable tr"));
        const sortedRows = rows.sort((rowA, rowB) => {
            const updatedAtA = new Date(rowA.cells[3].textContent); // 수정일자 (4번째 열)
            const updatedAtB = new Date(rowB.cells[3].textContent);

            return updatedAtB - updatedAtA; // 내림차순 정렬
        });

        const tableBody = document.querySelector("#productTable");
        sortedRows.forEach(row => tableBody.appendChild(row)); // 정렬된 행을 다시 테이블에 추가
    }

    // 페이지 로드 후 자동으로 정렬 적용
    window.onload = sortTableByDate;
</script>

</body>
</html>

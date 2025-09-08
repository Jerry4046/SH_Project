<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>재고 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" /> <!-- ✅ 헤더 포함 -->

<div class="container mt-5">

    <!-- 제목 + 버튼 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>재고 목록</h2>
        <div class="d-flex gap-2">
            <a href="/product/detail" class="btn btn-outline-primary" onclick="toggleRegisterRow()">상세</a>
            <a href="#" class="btn btn-outline-primary" onclick="toggleRegisterRow()">등록</a>
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
            <form id="registerForm" action="${pageContext.request.contextPath}/product/register" method="post">
                <table class="table table-hover align-middle text-center">
                    <thead class="table-light">
                        <tr>
                            <th>상품코드</th>
                            <th>품목코드</th>
                            <th>상품명</th>
                            <th>규격</th>
                            <th>박스당 수량</th>
                            <th>총재고</th>
                            <th>단가</th>
                            <th>최소재고</th>
                            <th>사용여부</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody id="productTable">

                        <!-- ✅ 등록 입력 행 (기본은 숨김) -->
                        <tr id="registerRow" style="display:none;">
                        <td>
                            <div class="d-flex gap-1">
                                <select id="companyCode" name="companyCode" class="form-select form-select-sm" required>
                                    <option value="">회사</option>
                                </select>
                                <select id="typeCode" name="typeCode" class="form-select form-select-sm" style="display:none;" required>
                                    <option value="">종류</option>
                                </select>
                                <select id="categoryCode" name="categoryCode" class="form-select form-select-sm" style="display:none;" required>
                                    <option value="">분류</option>
                                </select>
                            </div>
                        </td>
                        <td><input type="text" name="itemCode" class="form-control form-control-sm"></td>
                        <td><input type="text" name="pdName" class="form-control form-control-sm" required></td>
						<td><input type="text" name="spec" class="form-control form-control-sm" required></td>
                        <td><input type="number" name="piecesPerBox" class="form-control form-control-sm" min="1" value="1" required></td>
                        <td><input type="number" name="totalQty" class="form-control form-control-sm" min="0" value="0" required></td>
						<td><input type="number" name="price" class="form-control form-control-sm" required></td>
						<td><input type="number" name="minStockQuantity" class="form-control form-control-sm" min="0" value="0" required></td>
                        <td>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" value="true" checked>
                                <label class="form-check-label">사용</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="active" value="false">
                                <label class="form-check-label">미사용</label>
                            </div>
                        </td>
                        <td>
                            <button type="submit" class="btn btn-sm btn-success">저장</button>
                            <button type="button" class="btn btn-sm btn-secondary" onclick="toggleRegisterRow()">취소</button>
                        </td>

                    </tr>
                    <!-- ✅ 기존 상품 목록 -->
                    <c:forEach var="product" items="${productList}">
                        <tr class="${product.active ? '' : 'text-muted'}">
                            <td>${product.productCode}</td>
                            <td>${product.itemCode}</td>
                            <td>${product.pdName}</td>
                            <td>${product.spec}</td>
                            <td>${product.piecesPerBox}</td>
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
                            <td></td>
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
            // 등록행은 필터에서 제외
            if (row.id === "registerRow") return;

            const nameCell = row.cells[2]; // 상품명
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

    function toggleRegisterRow() {
        const row = document.getElementById("registerRow");
        row.style.display = row.style.display === "none" ? "" : "none";
    }


    const productCodes = [
        <c:forEach var="code" items="${productCodes}">
        {company:'${code.companyCode}', type:'${code.typeCode}', category:'${code.categoryCode}'},
        </c:forEach>
    ];

    const companyNames = {
        <c:forEach var="entry" items="${companyNames}">
        '${entry.key}': '${entry.value}',
        </c:forEach>
    };

    const typeNames = {
        <c:forEach var="entry" items="${typeNames}">
        '${entry.key}': '${entry.value}',
        </c:forEach>
    };

    const categoryNames = {
        <c:forEach var="entry" items="${categoryNames}">
        '${entry.key}': '${entry.value}',
        </c:forEach>
    };

    const companySelect = document.getElementById('companyCode');
    const typeSelect = document.getElementById('typeCode');
    const categorySelect = document.getElementById('categoryCode');

    const companies = new Set(productCodes.map(c => c.company));
    companies.forEach(comp => {
        const option = document.createElement('option');
        option.value = comp;
        option.textContent = companyNames[comp] || comp;
        companySelect.appendChild(option);
    });

    companySelect.addEventListener('change', () => {
        const selectedCompany = companySelect.value;
        typeSelect.innerHTML = '<option value="">종류</option>';
        categorySelect.innerHTML = '<option value="">분류</option>';
        categorySelect.style.display = 'none';
        if (selectedCompany) {
            const types = new Set();
            productCodes.filter(c => c.company === selectedCompany)
                .forEach(c => types.add(c.type));
            types.forEach(t => {
                const option = document.createElement('option');
                option.value = t;
                option.textContent = typeNames[t] || t;
                typeSelect.appendChild(option);
            });
            typeSelect.style.display = '';
        } else {
            typeSelect.style.display = 'none';
        }
    });

    typeSelect.addEventListener('change', () => {
        const selectedCompany = companySelect.value;
        const selectedType = typeSelect.value;
        categorySelect.innerHTML = '<option value="">분류</option>';
        if (selectedType) {
            const categories = new Set();
            productCodes.filter(c => c.company === selectedCompany && c.type === selectedType)
                .forEach(c => categories.add(c.category));
            categories.forEach(cat => {
                const option = document.createElement('option');
                option.value = cat;
                option.textContent = categoryNames[cat] || cat;
                categorySelect.appendChild(option);
            });
            categorySelect.style.display = '';
        } else {
            categorySelect.style.display = 'none';
        }
    });

</script>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>제품 관리</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>제품 목록</h2>
        <button type="button" class="btn btn-outline-primary" onclick="toggleRegisterRow()">등록</button>
    </div>

    <form id="registerForm" action="${pageContext.request.contextPath}/product/register" method="post">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>상품코드</th>
                <th>아이템코드</th>
                <th>스펙</th>
                <th>상품명</th>
                <th>유닛이름</th>
                <th>Pieces/Box</th>
                <th>총재고</th>
                <th>최소재고</th>
                <th>단가</th>
                <th>사용여부</th>
                <th></th>
            </tr>
            </thead>
            <tbody id="productTable">
            <tr id="registerRow" style="display:none;">
                <td>
                    <div class="d-flex gap-1">
                        <select id="companyCode" name="companyCode" class="form-select form-select-sm" required>
                            <option value="">회사</option>
                        </select>
                        <select id="typeCode" name="typeCode" class="form-select form-select-sm" required disabled>
                            <option value="">종류</option>
                        </select>
                        <select id="categoryCode" name="categoryCode" class="form-select form-select-sm" required disabled>
                            <option value="">분류</option>
                        </select>
                    </div>
                </td>
                <td>
                    <div class="d-flex flex-column">
                        <input type="text" name="itemCode" id="registerItemCode" class="form-control form-control-sm mb-1" readonly>
                        <small class="text-muted" id="registerFullCodePreview">회사, 종류, 분류를 선택하면 제품 코드가 자동으로 생성됩니다.</small>
                    </div>
                </td>
                <td><input type="text" name="spec" class="form-control form-control-sm" required></td>
                <td><input type="text" name="pdName" class="form-control form-control-sm" required></td>
                <td><input type="text" name="unitName" class="form-control form-control-sm" required></td>
                <td><input type="number" name="piecesPerBox" class="form-control form-control-sm" required></td>
                <td><input type="number" name="totalQty" class="form-control form-control-sm" required></td>
                <td><input type="number" name="minStockQuantity" class="form-control form-control-sm" value="0" required></td>
                <td><input type="number" step="0.01" name="price" class="form-control form-control-sm" required></td>
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

            <c:forEach var="product" items="${productList}">
                <tr class="${product.active ? '' : 'text-muted'}">
                    <td>${product.fullProductCode}</td>
                    <td>${product.itemCode}</td>
                    <td>${product.spec}</td>
                    <td>${product.pdName}</td>
                    <td>${product.unitName}</td>
                    <td>${product.stock.piecesPerBox}</td>
                    <td>${product.stock.totalQty}</td>
                    <td>${product.minStockQuantity}</td>
                    <td>${product.getPrice()}</td>
                    <td>
                        <c:choose>
                            <c:when test="${product.active}"><span class="badge bg-success">사용중</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">미사용</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </form>
</div>

<script>
    function toggleRegisterRow() {
        const row = document.getElementById('registerRow');
        const show = row.style.display === 'none';
        row.style.display = show ? '' : 'none';

        const ctx = '${pageContext.request.contextPath}';
        const companySelect = document.getElementById('companyCode');
        const typeSelect = document.getElementById('typeCode');
        const categorySelect = document.getElementById('categoryCode');
        const itemCodeInput = document.getElementById('registerItemCode');
        const fullCodePreview = document.getElementById('registerFullCodePreview');
        const fullCodeDefaultText = fullCodePreview ? fullCodePreview.textContent : '';

        function resetItemPreview() {
            if (itemCodeInput) {
                itemCodeInput.value = '';
            }
            if (fullCodePreview) {
                fullCodePreview.textContent = fullCodeDefaultText;
                fullCodePreview.classList.remove('text-danger');
            }
        }

        async function refreshRegisterItemCode() {
            if (!itemCodeInput) {
                return;
            }
            const company = companySelect ? companySelect.value : '';
            const type = typeSelect ? typeSelect.value : '';
            const category = categorySelect ? categorySelect.value : '';

            if (!company || !type || !category) {
                resetItemPreview();
                return;
            }

            try {
                if (fullCodePreview) {
                    fullCodePreview.classList.remove('text-danger');
                }
            const response = await fetch(`${ctx}/api/product-codes/next-item?companyCode=${encodeURIComponent(company)}&typeCode=${encodeURIComponent(type)}&categoryCode=${encodeURIComponent(category)}`);
                if (!response.ok) {
                    throw new Error('failed to fetch next item code');
                }
                const data = await response.json();
                itemCodeInput.value = data.itemCode || '';
                if (fullCodePreview) {
                    fullCodePreview.textContent = data.fullProductCode || fullCodeDefaultText;
                }
            } catch (error) {
                console.error(error);
                if (fullCodePreview) {
                    fullCodePreview.textContent = '아이템 코드를 불러오지 못했습니다.';
                    fullCodePreview.classList.add('text-danger');
                }
                itemCodeInput.value = '';
            }
        }

        if (row.dataset.initialized === 'true') {
            if (show) {
                refreshRegisterItemCode();
            }
            return;
        }
        row.dataset.initialized = 'true';

        async function loadCompanies() {
            const res = await fetch(`${ctx}/api/product-codes/companies`);
            const data = await res.json();
            data.forEach(c => {
                const option = document.createElement('option');
                option.value = c.companyCode;
                option.textContent = c.companyName;
                companySelect.appendChild(option);
            });
            resetItemPreview();
        }

        companySelect.addEventListener('change', async () => {
            const selectedCompany = companySelect.value;
            typeSelect.innerHTML = '<option value="">종류</option>';
            categorySelect.innerHTML = '<option value="">분류</option>';
            categorySelect.disabled = true;
            resetItemPreview();
            if (selectedCompany) {
                const res = await fetch(`${ctx}/api/product-codes/types?companyCode=${selectedCompany}`);
                const data = await res.json();
                data.forEach(t => {
                    const option = document.createElement('option');
                    option.value = t.typeCode;
                    option.textContent = t.description || t.typeCode;
                    typeSelect.appendChild(option);
                });
                typeSelect.disabled = false;
            } else {
                typeSelect.disabled = true;
            }
            await refreshRegisterItemCode();
        });

        typeSelect.addEventListener('change', async () => {
            const selectedCompany = companySelect.value;
            const selectedType = typeSelect.value;
            categorySelect.innerHTML = '<option value="">분류</option>';
            if (selectedType) {
                const res = await fetch(`${ctx}/api/product-codes/categories?companyCode=${selectedCompany}&typeCode=${selectedType}`);
                const data = await res.json();
                data.forEach(cat => {
                    const option = document.createElement('option');
                    option.value = cat.categoryCode;
                    option.textContent = cat.description || cat.categoryCode;
                    categorySelect.appendChild(option);
                });
                categorySelect.disabled = false;
            } else {
                categorySelect.disabled = true;
            }
            await refreshRegisterItemCode();
        });

        categorySelect.addEventListener('change', refreshRegisterItemCode);

        loadCompanies();
        if (show) {
            refreshRegisterItemCode();
        }
    }
  </script>
</body>
</html>
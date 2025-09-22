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
                    <div class="d-flex gap-1 align-items-start">
                        <div class="flex-fill">
                            <select id="companyCode" name="companyCode" class="form-select form-select-sm" required>
                                <option value="">선택하시오</option>
                                <option value="__custom__">직접입력</option>
                                <c:forEach var="company" items="${companies}">
                                    <option value="${company.companyCode}">
                                        <c:out value="${empty company.companyName ? company.companyCode : company.companyName}" />
                                    </option>
                                </c:forEach>
                            </select>
                            <input type="text" id="companyCodeCustom" class="form-control form-control-sm mt-1" placeholder="회사 코드를 입력하세요" style="display:none;" disabled>
                        </div>
                        <div class="flex-fill">
                            <select id="typeCode" name="typeCode" class="form-select form-select-sm" required disabled>
                                <option value="">선택하시오</option>
                            </select>
                            <input type="text" id="typeCodeCustom" class="form-control form-control-sm mt-1" placeholder="타입 코드를 입력하세요" style="display:none;" disabled>
                        </div>
                        <div class="flex-fill">
                            <select id="categoryCode" name="categoryCode" class="form-select form-select-sm" required disabled>
                                <option value="">선택하시오</option>
                            </select>
                            <input type="text" id="categoryCodeCustom" class="form-control form-control-sm mt-1" placeholder="카테고리 코드를 입력하세요" style="display:none;" disabled>
                        </div>
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
    const codeHierarchy = <c:out value='${empty codeHierarchyJson ? "{}" : codeHierarchyJson}' escapeXml='false' /> || {};
    let registerInitialized = false;
    const registerState = {
        companySelect: null,
        typeSelect: null,
        categorySelect: null,
        companyCustomInput: null,
        typeCustomInput: null,
        categoryCustomInput: null
    };

    function toggleRegisterRow() {
        const row = document.getElementById('registerRow');
        const show = row.style.display === 'none';
        row.style.display = show ? '' : 'none';

        if (show) {
            if (!registerInitialized) {
                initializeRegisterForm();
                registerInitialized = true;
            }
            resetRegisterForm();
        }
    }

    function initializeRegisterForm() {
        registerState.companySelect = document.getElementById('companyCode');
        registerState.typeSelect = document.getElementById('typeCode');
        registerState.categorySelect = document.getElementById('categoryCode');
        registerState.companyCustomInput = document.getElementById('companyCodeCustom');
        registerState.typeCustomInput = document.getElementById('typeCodeCustom');
        registerState.categoryCustomInput = document.getElementById('categoryCodeCustom');

        if (registerState.companySelect) {
            registerState.companySelect.addEventListener('change', handleCompanyChange);
        }
        if (registerState.typeSelect) {
            registerState.typeSelect.addEventListener('change', handleTypeChange);
        }
    }

    function resetRegisterForm() {
        const { companySelect, typeSelect, categorySelect, companyCustomInput, typeCustomInput, categoryCustomInput } = registerState;
        if (!companySelect) {
            return;
        }

        useSelectInputs();
        companySelect.value = '';
        if (typeSelect) {
            typeSelect.value = '';
        }
        if (categorySelect) {
            categorySelect.value = '';
        }
        if (companyCustomInput) {
            companyCustomInput.value = '';
        }
        if (typeCustomInput) {
            typeCustomInput.value = '';
        }
        if (categoryCustomInput) {
            categoryCustomInput.value = '';
        }
    }

    function useSelectInputs() {
        const { companySelect, typeSelect, categorySelect, companyCustomInput, typeCustomInput, categoryCustomInput } = registerState;
        if (!companySelect || !typeSelect || !categorySelect) {
            return;
        }

        companySelect.name = 'companyCode';
        companySelect.required = true;

        if (companyCustomInput) {
            companyCustomInput.style.display = 'none';
            companyCustomInput.disabled = true;
            companyCustomInput.required = false;
            companyCustomInput.name = '';
        }

        typeSelect.disabled = true;
        typeSelect.name = 'typeCode';
        typeSelect.required = true;

        if (typeCustomInput) {
            typeCustomInput.style.display = 'none';
            typeCustomInput.disabled = true;
            typeCustomInput.required = false;
            typeCustomInput.name = '';
        }

        categorySelect.disabled = true;
        categorySelect.name = 'categoryCode';
        categorySelect.required = true;

        if (categoryCustomInput) {
            categoryCustomInput.style.display = 'none';
            categoryCustomInput.disabled = true;
            categoryCustomInput.required = false;
            categoryCustomInput.name = '';
        }

        resetTypeSelect();
        resetCategorySelect();
    }

    function useCustomInputs() {
        const { companySelect, typeSelect, categorySelect, companyCustomInput, typeCustomInput, categoryCustomInput } = registerState;
        if (!companySelect || !typeSelect || !categorySelect) {
            return;
        }

        companySelect.removeAttribute('name');
        companySelect.required = false;

        if (companyCustomInput) {
            companyCustomInput.style.display = '';
            companyCustomInput.disabled = false;
            companyCustomInput.required = true;
            companyCustomInput.name = 'companyCode';
            companyCustomInput.focus();
        }

        typeSelect.removeAttribute('name');
        typeSelect.required = false;
        typeSelect.disabled = true;

        if (typeCustomInput) {
            typeCustomInput.style.display = '';
            typeCustomInput.disabled = false;
            typeCustomInput.required = true;
            typeCustomInput.name = 'typeCode';
        }

        categorySelect.removeAttribute('name');
        categorySelect.required = false;
        categorySelect.disabled = true;

        if (categoryCustomInput) {
            categoryCustomInput.style.display = '';
            categoryCustomInput.disabled = false;
            categoryCustomInput.required = true;
            categoryCustomInput.name = 'categoryCode';
        }

        resetTypeSelect();
        resetCategorySelect();
    }

    function resetTypeSelect() {
        const { typeSelect } = registerState;
        if (!typeSelect) {
            return;
        }
        typeSelect.innerHTML = '<option value="">선택하시오</option>';
        typeSelect.disabled = true;
    }

    function resetCategorySelect() {
        const { categorySelect } = registerState;
        if (!categorySelect) {
            return;
        }
        categorySelect.innerHTML = '<option value="">선택하시오</option>';
        categorySelect.disabled = true;
    }

    function populateTypes(companyCode) {
        const { typeSelect } = registerState;
        resetTypeSelect();
        resetCategorySelect();
        if (!typeSelect || !companyCode) {
            return;
        }
        const companyData = codeHierarchy[companyCode];
        if (!companyData || !Array.isArray(companyData.types)) {
            return;
        }
        companyData.types.forEach(type => {
            if (!type || !type.code) {
                return;
            }
            const option = document.createElement('option');
            option.value = type.code;
            option.textContent = type.name || type.code;
            typeSelect.appendChild(option);
        });
        if (typeSelect.options.length > 1) {
            typeSelect.disabled = false;
        }
    }

    function populateCategories(companyCode, typeCode) {
        const { categorySelect } = registerState;
        resetCategorySelect();
        if (!categorySelect || !companyCode || !typeCode) {
            return;
        }
        const companyData = codeHierarchy[companyCode];
        if (!companyData || !companyData.categories) {
            return;
        }
        const categories = companyData.categories[typeCode];
        if (!Array.isArray(categories)) {
            return;
        }
        categories.forEach(category => {
            if (!category || !category.code) {
                return;
            }
            const option = document.createElement('option');
            option.value = category.code;
            option.textContent = category.name || category.code;
            categorySelect.appendChild(option);
        });
        if (categorySelect.options.length > 1) {
            categorySelect.disabled = false;
        }
    }

    function handleCompanyChange() {
        const { companySelect, companyCustomInput, typeCustomInput, categoryCustomInput } = registerState;
        if (!companySelect) {
            return;
        }

        if (companySelect.value === '__custom__') {
            useCustomInputs();
            if (companyCustomInput) {
                companyCustomInput.value = '';
            }
            if (typeCustomInput) {
                typeCustomInput.value = '';
            }
            if (categoryCustomInput) {
                categoryCustomInput.value = '';
            }
        } else {
            useSelectInputs();
            if (companySelect.value) {
                populateTypes(companySelect.value);
            }
        }
    }

    function handleTypeChange() {
        const { typeSelect, companySelect } = registerState;
        if (!typeSelect || !companySelect || typeSelect.name !== 'typeCode') {
            return;
        }

        const selectedType = typeSelect.value;
        if (selectedType) {
            populateCategories(companySelect.value, selectedType);
        } else {
            resetCategorySelect();
        }
    }
  </script>
</body>
</html>
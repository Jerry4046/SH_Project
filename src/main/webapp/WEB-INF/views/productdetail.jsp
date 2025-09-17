<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <h2>등록</h2>
            <div class="btn-group mb-3">
                <button type="button" class="btn btn-outline-primary" id="productTabBtn">제품</button>
                <button type="button" class="btn btn-outline-primary active" id="codeTabBtn">제품코드</button>
            </div>

            <div id="codeForm">
                <form id="codeRegisterForm">
                    <div class="row g-3 mb-3 align-items-end">
                        <div class="col">
                            <label class="form-label">회사 선택</label>
                            <select id="codeCompanySelect" class="form-select"></select>
                            <input id="codeCompanyName" class="form-control d-none" placeholder="회사 이름을 직접 입력하세요">
                        </div>
                        <div class="col-auto d-flex align-items-end gap-2">
                            <input id="codeCompanyNameInput" class="form-control" style="display:none;" placeholder="회사 이름을 입력하세요">
                        </div>
                        <div class="col">
                            <label class="form-label">회사 코드</label>
                            <input id="codeCompany" class="form-control" disabled>
                        </div>
                        <div class="col-auto d-flex align-items-end">
                            <button type="button" class="btn btn-secondary" id="companyPartialBtn">부분등록</button>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label class="form-label">타입 이름</label>
                            <input list="typeNameOptions" id="codeTypeName" class="form-control" disabled>
                            <datalist id="typeNameOptions"></datalist>
                        </div>
                        <div class="col">
                            <label class="form-label">타입 코드</label>
                            <input id="codeType" class="form-control" disabled>
                        </div>
                        <div class="col-auto d-flex align-items-end">
                            <button type="button" class="btn btn-secondary" id="typePartialBtn" disabled>부분등록</button>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label class="form-label">카테고리 이름</label>
                            <input list="categoryNameOptions" id="codeCategoryName" class="form-control" disabled>
                            <datalist id="categoryNameOptions"></datalist>
                        </div>
                        <div class="col">
                            <label class="form-label">카테고리 코드</label>
                            <input id="codeCategory" class="form-control" disabled>
                        </div>
                        <div class="col-auto d-flex align-items-end">
                            <button type="button" class="btn btn-secondary" id="categoryPartialBtn" disabled>부분등록</button>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end mb-3">
                        <button type="button" class="btn btn-primary btn-sm" id="fullRegisterBtn">전체등록</button>
                    </div>
                </form>
            </div>

            <div id="productForm" style="display:none;">
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
                    <button type="submit" class="btn btn-primary me-2">등록</button>
                    <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary">취소</a>
                </form>
            </div>
        </c:when>
        <c:otherwise>
                        <h2>제품 상세 정보</h2>
                        <button type="button" class="btn btn-warning mb-2" onclick="toggleDetailEdit()">수정</button>
                        <form action="${pageContext.request.contextPath}/product/update" method="post" id="detailForm">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle text-center">
                                <thead class="table-light">
                                <tr>
                                    <th class="edit-col" style="display:none;"></th>
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
                                    <th>단가</th>
                                    <th>생성일자</th>
                                    <th>업데이트 일자</th>
                                </tr>
                                    <td><input type="number" name="looseQty" value="${empty product.stock.looseQty ? 0 : product.stock.looseQty}" class="form-control form-control-sm" disabled></td>
                                    <td><input type="number" name="totalQty" value="${empty product.stock.totalQty ? 0 : product.stock.totalQty}" class="form-control form-control-sm" disabled></td>
                                    <td><input type="number" name="minStockQuantity" value="${product.minStockQuantity}" class="form-control form-control-sm" disabled></td>
                                    <td>
                                        <select name="active" class="form-select form-select-sm" disabled>
                                            <option value="true" ${product.active ? 'selected' : ''}>사용</option>
                                            <option value="false" ${!product.active ? 'selected' : ''}>미사용</option>
                                        </select>
                                    </td>
                                    <td><input type="number" step="0.01" name="price" value="${product.getPrice()}" class="form-control form-control-sm" disabled></td>
                            <td>${product.formattedCreatedAt}</td>
                            <td>${product.formattedUpdatedAt}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <input type="hidden" name="originalCode" value="${product.productCode}">
                <input type="text" name="reason" class="form-control mt-2 save-btn" placeholder="사유" style="display:none" required>
                <button type="submit" class="btn btn-success mt-2 save-btn" style="display:none">저장</button>
                </form>
            </c:otherwise>
        </c:choose>
</div>

<script>
    const ctx = '${pageContext.request.contextPath}';

    // ----- 제품 코드 등록 폼 -----
    const codeTabBtn = document.getElementById('codeTabBtn');
    const productTabBtn = document.getElementById('productTabBtn');
    const codeFormDiv = document.getElementById('codeForm');
    const productFormDiv = document.getElementById('productForm');

    codeTabBtn.addEventListener('click', () => {
        codeFormDiv.style.display = '';
        productFormDiv.style.display = 'none';
        codeTabBtn.classList.add('active');
        productTabBtn.classList.remove('active');
    });

    productTabBtn.addEventListener('click', () => {
        codeFormDiv.style.display = 'none';
        productFormDiv.style.display = '';
        productTabBtn.classList.add('active');
        codeTabBtn.classList.remove('active');
    });

        const codeCompanySelect = document.getElementById('codeCompanySelect');
        const codeCompanyName = document.getElementById('codeCompanyName');
        const codeCompany = document.getElementById('codeCompany');
        const codeTypeName = document.getElementById('codeTypeName');
        const codeType = document.getElementById('codeType');
        const codeCategoryName = document.getElementById('codeCategoryName');
        const codeCategory = document.getElementById('codeCategory');
        const typeNameOptions = document.getElementById('typeNameOptions');
        const categoryNameOptions = document.getElementById('categoryNameOptions');
        const companyInputToggle = document.getElementById('companyInputToggle');
        const companyPartialBtn = document.getElementById('companyPartialBtn');
        const typePartialBtn = document.getElementById('typePartialBtn');
        const categoryPartialBtn = document.getElementById('categoryPartialBtn');

        companyPartialBtn.disabled = true;

        let customCompanyMode = false;
        let currentCompanyCode = '';

        function showSelectCompanyField() {
            codeCompanySelect.classList.remove('d-none');
            codeCompanyName.classList.add('d-none');
            companyInputToggle.textContent = '직접입력';
        }

        function showCustomCompanyField() {
            codeCompanySelect.classList.add('d-none');
            codeCompanyName.classList.remove('d-none');
            companyInputToggle.textContent = '목록선택';
        }

        function resetTypeFields() {
            codeTypeName.value = '';
            codeType.value = '';
            codeTypeName.disabled = true;
            codeType.disabled = true;
            typePartialBtn.disabled = true;
            typeNameOptions.innerHTML = '';
        }

        function resetCategoryFields() {
            codeCategoryName.value = '';
            codeCategory.value = '';
            codeCategoryName.disabled = true;
            codeCategory.disabled = true;
            categoryPartialBtn.disabled = true;
            categoryNameOptions.innerHTML = '';
        }

        function syncCompanyPartialButton() {
            if (customCompanyMode) {
                const hasName = codeCompanyName.value.trim();
                const hasCode = codeCompany.value.trim();
                companyPartialBtn.disabled = !(hasName && hasCode);
            } else {
                companyPartialBtn.disabled = true;
            }
        }

        function updateTypeEnable() {
            const hasCompany = customCompanyMode
                ? Boolean(codeCompanyName.value.trim() && codeCompany.value.trim())
                : Boolean(currentCompanyCode);
            codeTypeName.disabled = !hasCompany;
            typePartialBtn.disabled = !hasCompany;
            if (!hasCompany) {
                codeType.value = '';
                codeType.disabled = true;
                codeCategoryName.value = '';
                codeCategoryName.disabled = true;
                codeCategory.value = '';
                codeCategory.disabled = true;
                typeNameOptions.innerHTML = '';
                categoryPartialBtn.disabled = true;
                categoryNameOptions.innerHTML = '';
            }
            syncCompanyPartialButton();
        }

        function switchToExistingCompany(name, code) {
            const changed = customCompanyMode || currentCompanyCode !== code;
            currentCompanyCode = code;
            customCompanyMode = false;
            showSelectCompanyField();
            const placeholder = codeCompanySelect.querySelector('option[value=""]');
            if (placeholder) {
                placeholder.selected = false;
            }
            codeCompanySelect.value = code;
            codeCompanyName.value = name;
            codeCompany.value = code;
            codeCompany.disabled = true;
            if (changed) {
                resetTypeFields();
                resetCategoryFields();
            }
            updateTypeEnable();
            return changed;
        }

        function switchToCustomCompany(name) {
            const enteringCustom = !customCompanyMode;
            if (enteringCustom || currentCompanyCode) {
                resetTypeFields();
                resetCategoryFields();
                codeCompany.value = '';
            }
            currentCompanyCode = '';
            customCompanyMode = true;
            showCustomCompanyField();
            codeCompanySelect.value = '';
            codeCompanyName.value = name;
            codeCompany.disabled = false;
            updateTypeEnable();
            if (!name) {
                codeCompanyName.focus();
            }
        }

        function clearCompanySelection() {
            if (customCompanyMode || currentCompanyCode) {
                resetTypeFields();
                resetCategoryFields();
            }
            currentCompanyCode = '';
            customCompanyMode = false;
            showSelectCompanyField();
            const placeholder = codeCompanySelect.querySelector('option[value=""]');
            if (placeholder) {
                placeholder.selected = true;
            }
            codeCompanySelect.value = '';
            codeCompanyName.value = '';
            codeCompany.value = '';
            codeCompany.disabled = true;
            updateTypeEnable();
        }

        function getSelectedCompanyName() {
            if (customCompanyMode) {
                return codeCompanyName.value.trim();
            }
            const selectedOption = codeCompanySelect.options[codeCompanySelect.selectedIndex];
            if (!selectedOption || selectedOption.disabled) {
                return '';
            }
            return selectedOption.textContent.trim();
        }

        function loadCompanies({ selectedCode } = {}) {
            return fetch(`${ctx}/api/product-codes/companies`)
                .then(r => {
                    if (!r.ok) {
                        throw new Error('failed to fetch companies');
                    }
                    return r.json();
                })
                .then(data => {
                    codeCompanySelect.innerHTML = '';
                    const placeholder = document.createElement('option');
                    placeholder.value = '';
                    placeholder.textContent = '회사 선택';
                    placeholder.disabled = true;
                    codeCompanySelect.appendChild(placeholder);

                    data.forEach(c => {
                        const opt = document.createElement('option');
                        opt.value = c.companyCode;
                        opt.textContent = c.companyName;
                        codeCompanySelect.appendChild(opt);
                    });

                    const targetCode = selectedCode || currentCompanyCode;
                    if (targetCode) {
                        const match = data.find(c => c.companyCode === targetCode);
                        if (match) {
                            switchToExistingCompany(match.companyName, match.companyCode);
                        } else if (!customCompanyMode) {
                            clearCompanySelection();
                        }
                    } else {
                        placeholder.selected = true;
                    }
                    updateTypeEnable();
                })
                .catch(err => {
                    alert('회사 목록을 불러오지 못했습니다. 관리자에 문의하시오');
                    throw err;
                });
        }

        function loadTypes(company) {
            return fetch(`${ctx}/api/product-codes/types?companyCode=${company}`)
                .then(r => {
                    if (!r.ok) {
                        throw new Error('failed to fetch types');
                    }
                    return r.json();
                })
                .then(data => {
                    typeNameOptions.innerHTML = '';
                    data.forEach(t => {
                        if (t.typeCode !== '0000') {
                            const opt = document.createElement('option');
                            opt.value = t.description;
                            opt.dataset.code = t.typeCode;
                            typeNameOptions.appendChild(opt);
                        }
                    });
                })
                .catch(err => {
                    alert('관리자에 문의하시오');
                    throw err;
                });
        }

        function loadCategories(company, type) {
            return fetch(`${ctx}/api/product-codes/categories?companyCode=${company}&typeCode=${type}`)
                .then(r => {
                    if (!r.ok) {
                        throw new Error('failed to fetch categories');
                    }
                    return r.json();
                })
                .then(data => {
                    categoryNameOptions.innerHTML = '';
                    data.forEach(cat => {
                        const opt = document.createElement('option');
                        opt.value = cat.description;
                        opt.dataset.code = cat.categoryCode;
                        categoryNameOptions.appendChild(opt);
                    });
                })
                .catch(err => {
                    alert('관리자에 문의하시오');
                    throw err;
                });
        }

        clearCompanySelection();
        loadCompanies();

        codeCompanySelect.addEventListener('change', () => {
            const selectedCode = codeCompanySelect.value;
            if (!selectedCode) {
                clearCompanySelection();
                return;
            }
            const selectedOption = codeCompanySelect.options[codeCompanySelect.selectedIndex];
            switchToExistingCompany(selectedOption ? selectedOption.textContent : '', selectedCode);
            loadTypes(selectedCode);
        });

        companyInputToggle.addEventListener('click', () => {
            if (customCompanyMode) {
                clearCompanySelection();
            } else {
                switchToCustomCompany('');
            }
        });

        codeCompanyName.addEventListener('input', () => {
            if (customCompanyMode) {
                updateTypeEnable();
                syncCompanyPartialButton();
            }
        });

        codeCompany.addEventListener('input', () => {
            if (customCompanyMode) {
                updateTypeEnable();
            }
        });

        codeTypeName.addEventListener('input', () => {
            const option = Array.from(typeNameOptions.options).find(o => o.value === codeTypeName.value);
            if (option) {
                codeType.value = option.dataset.code;
                codeType.disabled = true;
                codeCategoryName.disabled = false;
                categoryPartialBtn.disabled = false;
                loadCategories(codeCompany.value, codeType.value);
            } else {
                codeType.value = '';
                codeType.disabled = false;
                resetCategoryFields();
            }
        });

        codeType.addEventListener('input', () => {
            const hasType = codeCompany.value && codeTypeName.value.trim() && codeType.value.trim();
            codeCategoryName.disabled = !hasType;
            categoryPartialBtn.disabled = !hasType;
            if (!hasType) {
                resetCategoryFields();
            }
        });

        codeCategoryName.addEventListener('input', () => {
            const option = Array.from(categoryNameOptions.options).find(o => o.value === codeCategoryName.value);
            if (option) {
                codeCategory.value = option.dataset.code;
                codeCategory.disabled = true;
            } else {
                codeCategory.value = '';
                codeCategory.disabled = false;
            }
        });

        async function postProductCode(params) {
            const response = await fetch(`${ctx}/api/product-codes`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams(params)
            });
            if (!response.ok) {
                throw new Error('failed to create product code');
            }
            return response.json();
        }

        companyPartialBtn.addEventListener('click', async () => {
            if (!customCompanyMode) {
                alert('새 회사 이름을 입력한 뒤에만 등록할 수 있습니다.');
                return;
            }
            const name = codeCompanyName.value.trim();
            const code = codeCompany.value.trim();
            if (!name || !code) {
                alert('회사 이름과 코드를 입력하세요');
                return;
            }
            try {
                await postProductCode({ companyCode: code, typeCode: '0000', categoryCode: '0000', description: name });
                alert('등록되었습니다.');
                await loadCompanies({ selectedCode: code });
            } catch (e) {
                console.error(e);
                alert('관리자에 문의하시오');
            }
        });

        typePartialBtn.addEventListener('click', async () => {
            const company = codeCompany.value.trim();
            const name = codeTypeName.value.trim();
            const type = codeType.value.trim();
            if (!company || !name || !type) {
                alert('회사와 타입 이름, 코드를 입력하세요');
                return;
            }
            try {
                await postProductCode({ companyCode: company, typeCode: type, categoryCode: '0000', description: name });
                alert('등록되었습니다.');
                await loadTypes(company);
                const option = Array.from(typeNameOptions.options).find(o => o.dataset.code === type);
                if (option) {
                    codeTypeName.value = option.value;
                    codeType.value = option.dataset.code;
                    codeType.disabled = true;
                    codeCategoryName.disabled = false;
                    categoryPartialBtn.disabled = false;
                }
            } catch (e) {
                console.error(e);
                alert('관리자에 문의하시오');
            }
        });

        categoryPartialBtn.addEventListener('click', async () => {
            const company = codeCompany.value.trim();
            const type = codeType.value.trim();
            const name = codeCategoryName.value.trim();
            const category = codeCategory.value.trim();
            if (!company || !type || !name || !category) {
                alert('회사, 타입, 카테고리 이름과 코드를 입력하세요');
                return;
            }
            try {
                await postProductCode({ companyCode: company, typeCode: type, categoryCode: category, description: name });
                alert('등록되었습니다.');
                await loadCategories(company, type);
                const option = Array.from(categoryNameOptions.options).find(o => o.dataset.code === category);
                if (option) {
                    codeCategoryName.value = option.value;
                    codeCategory.value = option.dataset.code;
                    codeCategory.disabled = true;
                }
            } catch (e) {
                console.error(e);
                alert('관리자에 문의하시오');
            }
        });

        document.getElementById('fullRegisterBtn').addEventListener('click', async () => {
            const company = codeCompany.value.trim();
            const type = codeType.value.trim();
            const category = codeCategory.value.trim();
            const typeName = codeTypeName.value.trim();
            const categoryName = codeCategoryName.value.trim();
            const companyName = getSelectedCompanyName();
            const wasCustomCompany = customCompanyMode;

            if (!company || !type || !category || !typeName || !categoryName || (wasCustomCompany && !companyName)) {
                alert('회사, 타입, 카테고리 이름과 코드를 모두 입력하세요');
                return;
            }

            try {
                if (wasCustomCompany) {
                    await postProductCode({ companyCode: company, typeCode: '0000', categoryCode: '0000', description: companyName });
                }

                await postProductCode({ companyCode: company, typeCode: type, categoryCode: '0000', description: typeName });

                await postProductCode({ companyCode: company, typeCode: type, categoryCode: category, description: categoryName });

                if (wasCustomCompany) {
                    await loadCompanies({ selectedCode: company });
                }

                await loadTypes(company);
                const typeOption = Array.from(typeNameOptions.options).find(o => o.dataset.code === type);
                if (typeOption) {
                    codeTypeName.value = typeOption.value;
                    codeType.value = typeOption.dataset.code;
                    codeType.disabled = true;
                    codeCategoryName.disabled = false;
                    categoryPartialBtn.disabled = false;
                }

                await loadCategories(company, type);
                const categoryOption = Array.from(categoryNameOptions.options).find(o => o.dataset.code === category);
                if (categoryOption) {
                    codeCategoryName.value = categoryOption.value;
                    codeCategory.value = categoryOption.dataset.code;
                    codeCategory.disabled = true;
                    categoryPartialBtn.disabled = false;
                }

                codeCompany.value = company;
                codeCompany.disabled = true;
                updateTypeEnable();

                alert('제품코드가 등록되었습니다.');

                document.getElementById('companyCode').value = codeCompany.value;
                document.getElementById('companyCode').dispatchEvent(new Event('change'));
                setTimeout(() => {
                    document.getElementById('typeCode').value = codeType.value;
                    document.getElementById('typeCode').dispatchEvent(new Event('change'));
                    setTimeout(() => {
                        document.getElementById('categoryCode').value = codeCategory.value;
                    }, 100);
                }, 100);
                productTabBtn.click();
            } catch (e) {
                console.error(e);
                alert('관리자에 문의하시오');
            }
    });

    // ----- 제품 등록 폼 -----
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
            return;
        }

        typeSelect.disabled = false;

        if (!typeSelect.value) {
            categorySelect.value = '';
            categorySelect.disabled = true;
        } else {
            categorySelect.disabled = false;
        }
    }

    if (companySelect) {
        companySelect.addEventListener('change', updateTypeCategory);
    }

    if (typeSelect) {
        typeSelect.addEventListener('change', updateTypeCategory);
    }
    updateTypeCategory();

    // ----- 상세 정보 수정 -----
    let detailEditMode = false;
    function toggleDetailEdit() {
        detailEditMode = !detailEditMode;
        document.querySelectorAll('.edit-col').forEach(c => c.style.display = detailEditMode ? '' : 'none');
        const checkbox = document.querySelector('#detailForm .edit-col input[type="checkbox"]');
        if (checkbox) {
            checkbox.checked = false;
            toggleDetailRow(checkbox);
        }
    }

    function toggleDetailRow(cb) {
        const row = cb.closest('tr');
        const spans = row.querySelectorAll('.value');
        const edits = row.querySelectorAll('.edit-field');
        spans.forEach(s => s.style.display = cb.checked ? 'none' : '');
        edits.forEach(e => {
            e.style.display = cb.checked ? '' : 'none';
            e.disabled = !cb.checked;
        });
        document.querySelectorAll('#detailForm .save-btn').forEach(b => b.style.display = cb.checked ? '' : 'none');
    }
</script>

</body>
</html>
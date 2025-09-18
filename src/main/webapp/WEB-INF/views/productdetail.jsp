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
            <form action="${pageContext.request.contextPath}/product/register" method="post" class="mt-3">
<h2>등록</h2>
            <div class="btn-group mb-3">
                <button type="button" class="btn btn-outline-primary" id="productTabBtn">제품</button>
                <button type="button" class="btn btn-outline-primary active" id="codeTabBtn">제품코드</button>
            </div>

            <div id="codeForm">
                <form id="codeRegisterForm">
                    <div class="row mb-3">
                        <div class="col">
                            <label class="form-label">회사 이름</label>
                            <select id="codeCompanyName" class="form-select" data-selected-company="${param.companyCode}">
                                <option value="">선택하시오</option>
                                <option value="__custom__">직접입력</option>
                                <c:forEach var="company" items="${companies}">
                                    <option value="${company.companyCode}">${company.companyName}</option>
                                </c:forEach>
                            </select>
                            <input id="codeCompanyNameInput" class="form-control mt-2" style="display:none;" placeholder="회사 이름을 입력하세요">
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
                            <select id="codeTypeName" class="form-select" disabled data-selected-type="${param.typeCode}">
                                <option value="">선택하시오</option>
                                <option value="__custom__">직접입력</option>
                            </select>
                            <input id="codeTypeNameInput" class="form-control mt-2" style="display:none;" placeholder="타입 이름을 입력하세요" disabled>
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
                            <select id="codeCategoryName" class="form-select" disabled data-selected-category="${param.categoryCode}">
                                <option value="">선택하시오</option>
                                <option value="__custom__">직접입력</option>
                            </select>
                            <input id="codeCategoryNameInput" class="form-control mt-2" style="display:none;" placeholder="카테고리 이름을 입력하세요" disabled>
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
                        <select name="companyCode" id="companyCode" class="form-select" required data-selected-company="${param.companyCode}">
                            <option value="">선택하세요</option>
                            <c:forEach var="company" items="${companies}">
                                <option value="${company.companyCode}">${company.companyName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">유형</label>
                        <select name="typeCode" id="typeCode" class="form-select" disabled data-selected-type="${param.typeCode}">
                            <option value="">선택하세요</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">카테고리</label>
                        <select name="categoryCode" id="categoryCode" class="form-select" disabled data-selected-category="${param.categoryCode}">
                            <option value="">선택하세요</option>
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
            <c:if test="${not empty codeHierarchyJson}">
                <script type="application/json" id="codeHierarchyData"><c:out value="${codeHierarchyJson}" escapeXml="false" /></script>
            </c:if>
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
(function () {
  const ctx = '${pageContext.request.contextPath}';
  const codeTabBtn = document.getElementById('codeTabBtn');
  const productTabBtn = document.getElementById('productTabBtn');
  const codeForm = document.getElementById('codeForm');
  const productForm = document.getElementById('productForm');

  if (codeTabBtn && productTabBtn && codeForm && productForm) {
    codeTabBtn.addEventListener('click', () => {
      codeForm.style.display = '';
      productForm.style.display = 'none';
      codeTabBtn.classList.add('active');
      productTabBtn.classList.remove('active');
    });

    productTabBtn.addEventListener('click', () => {
      codeForm.style.display = 'none';
      productForm.style.display = '';
      productTabBtn.classList.add('active');
      codeTabBtn.classList.remove('active');
    });
  }

  const hierarchyElement = document.getElementById('codeHierarchyData');
  let hierarchy = {};
  if (hierarchyElement) {
    try {
      const raw = (hierarchyElement.textContent || hierarchyElement.innerText || '').trim();
      if (raw) {
        hierarchy = JSON.parse(raw);
      }
    } catch (error) {
      console.error('코드 계층 데이터를 불러오지 못했습니다.', error);
      hierarchy = {};
    }
  }

  const companySelect = document.getElementById('codeCompanyName');
  const companyInput = document.getElementById('codeCompanyNameInput');
  const companyCodeInput = document.getElementById('codeCompany');
  const typeSelect = document.getElementById('codeTypeName');
  const typeInput = document.getElementById('codeTypeNameInput');
  const typeCodeInput = document.getElementById('codeType');
  const categorySelect = document.getElementById('codeCategoryName');
  const categoryInput = document.getElementById('codeCategoryNameInput');
  const categoryCodeInput = document.getElementById('codeCategory');
  const companyPartialBtn = document.getElementById('companyPartialBtn');
  const typePartialBtn = document.getElementById('typePartialBtn');
  const categoryPartialBtn = document.getElementById('categoryPartialBtn');
  const fullRegisterBtn = document.getElementById('fullRegisterBtn');
  const productCompanySelect = document.getElementById('companyCode');
  const productTypeSelect = document.getElementById('typeCode');
  const productCategorySelect = document.getElementById('categoryCode');
  const initialCompanyCode = '<c:out value="${param.companyCode}" />'.trim();

  hideInlineInput(companyInput);

  if (initialCompanyCode && companySelect) {
    companySelect.dataset.selectedCompany = initialCompanyCode;
  }

  if (!companySelect || !companyCodeInput) {
    return;
  }

  const companyMap = new Map();

  function normalize(value, fallback) {
    if (typeof value === 'string') {
      const trimmed = value.trim();
      if (trimmed) {
        return trimmed;
      }
    }
    return fallback;
  }

  function getEntry(code) {
    if (!code) {
      return null;
    }
    if (!hierarchy[code]) {
      hierarchy[code] = { name: code, types: [], categories: {} };
    } else {
      const entry = hierarchy[code];
      if (!Array.isArray(entry.types)) {
        entry.types = [];
      }
      if (!entry.categories || typeof entry.categories !== 'object') {
        entry.categories = {};
      }
    }
    return hierarchy[code];
  }

  function ensureCompany(code, name) {
    if (!code) {
      return;
    }
    const entry = getEntry(code);
    const displayName = normalize(name, normalize(entry && entry.name, code));
    if (entry) {
      entry.name = displayName;
    }
    companyMap.set(code, { code, name: displayName });
  }

  function ensureType(companyCode, typeCode, name) {
    if (!companyCode || !typeCode) {
      return;
    }
    const entry = getEntry(companyCode);
    if (!entry) {
      return;
    }
    const displayName = normalize(name, typeCode);
    if (!entry.types.some((t) => t.code === typeCode)) {
      entry.types.push({ code: typeCode, name: displayName });
    } else {
      entry.types = entry.types.map((t) => (t.code === typeCode ? { code: typeCode, name: displayName } : t));
    }
  }

  function ensureCategory(companyCode, typeCode, categoryCode, name) {
    if (!companyCode || !typeCode || !categoryCode) {
      return;
    }
    const entry = getEntry(companyCode);
    if (!entry) {
      return;
    }
    const displayName = normalize(name, categoryCode);
    if (!entry.categories[typeCode]) {
      entry.categories[typeCode] = [];
    }
    const list = entry.categories[typeCode];
    if (!list.some((c) => c.code === categoryCode)) {
      list.push({ code: categoryCode, name: displayName });
    } else {
      entry.categories[typeCode] = list.map((c) => (c.code === categoryCode ? { code: categoryCode, name: displayName } : c));
    }
  }

  Object.entries(hierarchy || {}).forEach(([companyCode, entry]) => {
    if (!entry) {
      return;
    }
    ensureCompany(companyCode, entry.name);
    if (Array.isArray(entry.types)) {
      entry.types.forEach((type) => {
        if (type && type.code) {
          ensureType(companyCode, type.code, type.name);
        }
      });
    }
    if (entry.categories && typeof entry.categories === 'object') {
      Object.entries(entry.categories).forEach(([typeCode, categories]) => {
        if (Array.isArray(categories)) {
          categories.forEach((category) => {
            if (category && category.code) {
              ensureCategory(companyCode, typeCode, category.code, category.name);
            }
          });
        }
      });
    }
  });

  if (companySelect) {
    Array.from(companySelect.options).forEach((option) => {
      if (option.value && option.value !== '__custom__') {
        ensureCompany(option.value, option.textContent);
      }
    });
  }
  if (productCompanySelect) {
    Array.from(productCompanySelect.options).forEach((option) => {
      if (option.value) {
        ensureCompany(option.value, option.textContent);
      }
    });
  }

  function getTypeList(companyCode) {
    const entry = hierarchy[companyCode];
    if (!entry || !Array.isArray(entry.types)) {
      return [];
    }
    return entry.types.map((item) => ({
      code: item.code,
      name: normalize(item.name, item.code),
    }));
  }

  function getCategoryList(companyCode, typeCode) {
    const entry = hierarchy[companyCode];
    if (!entry || !entry.categories || !entry.categories[typeCode]) {
      return [];
    }
    return entry.categories[typeCode].map((item) => ({
      code: item.code,
      name: normalize(item.name, item.code),
    }));
  }

  function setDisabled(element, disabled) {
    if (!element) {
      return;
    }
    element.disabled = !!disabled;
    if (disabled) {
      element.setAttribute('disabled', 'disabled');
    } else {
      element.removeAttribute('disabled');
    }
  }

  function showInlineInput(element) {
    if (!element) {
      return;
    }
    element.classList.remove('d-none');
    element.style.display = '';
  }

  function hideInlineInput(element) {
    if (!element) {
      return;
    }
    element.classList.add('d-none');
    element.style.display = 'none';
  }

  function isManual(select, input) {
    return !!(select && input && select.classList.contains('d-none') && !input.classList.contains('d-none'));
  }

  function resetTypeSection() {
    if (!typeSelect) {
      return;
    }
    typeSelect.innerHTML = '';
    typeSelect.appendChild(new Option('선택하시오', ''));
    typeSelect.appendChild(new Option('직접입력', '__custom__'));
    typeSelect.value = '';
    typeSelect.dataset.selectedType = '';
    setDisabled(typeSelect, true);
    if (typeInput) {
      typeInput.value = '';
      hideInlineInput(typeInput);
      setDisabled(typeInput, true);
    }
    if (typeCodeInput) {
      typeCodeInput.value = '';
      setDisabled(typeCodeInput, true);
    }
    resetCategorySection();
  }

  function resetCategorySection() {
    if (!categorySelect) {
      return;
    }
    categorySelect.innerHTML = '';
    categorySelect.appendChild(new Option('선택하시오', ''));
    categorySelect.appendChild(new Option('직접입력', '__custom__'));
    categorySelect.value = '';
    categorySelect.dataset.selectedCategory = '';
    setDisabled(categorySelect, true);
    if (categoryInput) {
      categoryInput.value = '';
      hideInlineInput(categoryInput);
      setDisabled(categoryInput, true);
    }
    if (categoryCodeInput) {
      categoryCodeInput.value = '';
      setDisabled(categoryCodeInput, true);
    }
  }

  function populateCompanyOptions(selectedCode) {
    if (!companySelect) {
      return;
    }
    const currentSelected = typeof selectedCode === 'string' ? selectedCode : companySelect.value;
    companySelect.innerHTML = '';
    companySelect.appendChild(new Option('선택하시오', ''));
    companySelect.appendChild(new Option('직접입력', '__custom__'));
    Array.from(companyMap.values())
      .sort((a, b) => a.name.localeCompare(b.name))
      .forEach((item) => {
        const option = new Option(item.name, item.code);
        companySelect.appendChild(option);
      });
    if (currentSelected && (currentSelected === '__custom__' || companyMap.has(currentSelected))) {
      companySelect.value = currentSelected;
    } else if (companySelect.dataset.selectedCompany && companyMap.has(companySelect.dataset.selectedCompany)) {
      companySelect.value = companySelect.dataset.selectedCompany;
    } else {
      companySelect.value = '';
    }
    companySelect.dataset.selectedCompany = '';
  }

  function populateTypeOptions(companyCode, selectedType) {
    if (!typeSelect) {
      return;
    }
    const desired = typeof selectedType === 'string' ? selectedType : typeSelect.value;
    typeSelect.innerHTML = '';
    typeSelect.appendChild(new Option('선택하시오', ''));
    typeSelect.appendChild(new Option('직접입력', '__custom__'));
    const list = getTypeList(companyCode);
    list.forEach((item) => {
      const option = new Option(item.name, item.code);
      option.dataset.name = item.name;
      typeSelect.appendChild(option);
    });
    if (desired && (desired === '__custom__' || list.some((item) => item.code === desired))) {
      typeSelect.value = desired;
    } else {
      typeSelect.value = '';
    }
    typeSelect.dataset.selectedType = '';
  }

  function populateCategoryOptions(companyCode, typeCode, selectedCategory) {
    if (!categorySelect) {
      return;
    }
    const desired = typeof selectedCategory === 'string' ? selectedCategory : categorySelect.value;
    categorySelect.innerHTML = '';
    categorySelect.appendChild(new Option('선택하시오', ''));
    categorySelect.appendChild(new Option('직접입력', '__custom__'));
    const list = getCategoryList(companyCode, typeCode);
    list.forEach((item) => {
      const option = new Option(item.name, item.code);
      option.dataset.name = item.name;
      categorySelect.appendChild(option);
    });
    if (desired && (desired === '__custom__' || list.some((item) => item.code === desired))) {
      categorySelect.value = desired;
    } else {
      categorySelect.value = '';
    }
    categorySelect.dataset.selectedCategory = '';
  }

  function getTypeName() {
    if (!typeSelect) {
      return '';
    }
    if (isManual(typeSelect, typeInput)) {
      return typeInput ? typeInput.value.trim() : '';
    }
    const option = typeSelect.options[typeSelect.selectedIndex];
    return option ? option.textContent.trim() : '';
  }

  function getCategoryName() {
    if (!categorySelect) {
      return '';
    }
    if (isManual(categorySelect, categoryInput)) {
      return categoryInput ? categoryInput.value.trim() : '';
    }
    const option = categorySelect.options[categorySelect.selectedIndex];
    return option ? option.textContent.trim() : '';
  }

  function updateButtons() {
    const hasCompanyCode = !!(companyCodeInput && companyCodeInput.value.trim());
    const typeManual = isManual(typeSelect, typeInput);
    const categoryManual = isManual(categorySelect, categoryInput);

    if (companyPartialBtn) {
      const canRegisterCompany = companySelect && companyInput && companySelect.value === '__custom__'
        && companyInput.value.trim() && companyCodeInput && companyCodeInput.value.trim();
      companyPartialBtn.disabled = !canRegisterCompany;
    }
    if (typePartialBtn) {
      const canRegisterType = hasCompanyCode && typeManual
        && typeInput && typeInput.value.trim()
        && typeCodeInput && typeCodeInput.value.trim();
      typePartialBtn.disabled = !canRegisterType;
    }
    if (categoryPartialBtn) {
      const hasTypeCode = !!(typeCodeInput && typeCodeInput.value.trim());
      const canRegisterCategory = hasCompanyCode && hasTypeCode && categoryManual
        && categoryInput && categoryInput.value.trim()
        && categoryCodeInput && categoryCodeInput.value.trim();
      categoryPartialBtn.disabled = !canRegisterCategory;
    }
    if (fullRegisterBtn) {
      const hasType = !!(typeCodeInput && typeCodeInput.value.trim());
      const hasCategory = !!(categoryCodeInput && categoryCodeInput.value.trim());
      const categoryName = getCategoryName();
      fullRegisterBtn.disabled = !(hasCompanyCode && hasType && hasCategory && categoryName);
    }
  }

  function handleCompanyChange() {
    if (!companySelect) {
      return;
    }
    const value = companySelect.value;
    if (value === '__custom__') {
      companySelect.classList.add('d-none');
      showInlineInput(companyInput);
      setDisabled(companyInput, false);
      if (companyInput) {
        companyInput.focus();
      }
      if (companyCodeInput) {
        companyCodeInput.value = '';
        setDisabled(companyCodeInput, false);
      }
      resetTypeSection();
    } else if (value) {
      hideInlineInput(companyInput);
      if (companyInput) {
        companyInput.value = '';
        setDisabled(companyInput, true);
      }
      companySelect.classList.remove('d-none');
      if (companyCodeInput) {
        companyCodeInput.value = value;
        setDisabled(companyCodeInput, true);
      }
      populateTypeOptions(value, typeSelect ? typeSelect.dataset.selectedType : '');
      setDisabled(typeSelect, false);
      handleTypeChange();
    } else {
      hideInlineInput(companyInput);
      if (companyInput) {
        companyInput.value = '';
        setDisabled(companyInput, true);
      }
      companySelect.classList.remove('d-none');
      if (companyCodeInput) {
        companyCodeInput.value = '';
        setDisabled(companyCodeInput, true);
      }
      resetTypeSection();
    }
    updateButtons();
    syncProductCompanies();
  }

  function handleTypeChange() {
    if (!typeSelect) {
      return;
    }
    const value = typeSelect.value;
    if (value === '__custom__') {
      typeSelect.classList.add('d-none');
      showInlineInput(typeInput);
      setDisabled(typeInput, false);
      if (typeInput && !typeInput.value) {
        typeInput.focus();
      }
      if (typeCodeInput) {
        if (!typeCodeInput.value) {
          typeCodeInput.value = '';
        }
        setDisabled(typeCodeInput, false);
      }
      resetCategorySection();
    } else if (value) {
      typeSelect.classList.remove('d-none');
      hideInlineInput(typeInput);
      if (typeInput) {
        typeInput.value = '';
        setDisabled(typeInput, true);
      }
      if (typeCodeInput) {
        typeCodeInput.value = value;
        setDisabled(typeCodeInput, true);
      }
      const companyCode = companyCodeInput ? companyCodeInput.value.trim() : '';
      populateCategoryOptions(companyCode, value, categorySelect ? categorySelect.dataset.selectedCategory : '');
      setDisabled(categorySelect, false);
      handleCategoryChange();
    } else {
      typeSelect.classList.remove('d-none');
      hideInlineInput(typeInput);
      if (typeInput) {
        typeInput.value = '';
        setDisabled(typeInput, true);
      }
      if (typeCodeInput) {
        typeCodeInput.value = '';
        setDisabled(typeCodeInput, true);
      }
      resetCategorySection();
    }
    updateButtons();
    updateProductTypeOptions();
  }

  function handleCategoryChange() {
    if (!categorySelect) {
      return;
    }
    const value = categorySelect.value;
    if (value === '__custom__') {
      categorySelect.classList.add('d-none');
      showInlineInput(categoryInput);
      setDisabled(categoryInput, false);
      if (categoryInput && !categoryInput.value) {
        categoryInput.focus();
      }
      if (categoryCodeInput) {
        if (!categoryCodeInput.value) {
          categoryCodeInput.value = '';
        }
        setDisabled(categoryCodeInput, false);
      }
    } else if (value) {
      categorySelect.classList.remove('d-none');
      hideInlineInput(categoryInput);
      if (categoryInput) {
        categoryInput.value = '';
        setDisabled(categoryInput, true);
      }
      if (categoryCodeInput) {
        categoryCodeInput.value = value;
        setDisabled(categoryCodeInput, true);
      }
    } else {
      categorySelect.classList.remove('d-none');
      hideInlineInput(categoryInput);
      if (categoryInput) {
        categoryInput.value = '';
        setDisabled(categoryInput, true);
      }
      if (categoryCodeInput) {
        categoryCodeInput.value = '';
        setDisabled(categoryCodeInput, true);
      }
    }
    updateButtons();
    updateProductCategoryOptions();
  }

  function syncProductCompanies(selectedCode) {
    if (!productCompanySelect) {
      return;
    }
    const current = typeof selectedCode === 'string' ? selectedCode : (productCompanySelect.value || productCompanySelect.dataset.selectedCompany);
    const placeholder = productCompanySelect.dataset.placeholder || '선택하세요';
    productCompanySelect.innerHTML = '';
    productCompanySelect.appendChild(new Option(placeholder, ''));
    Array.from(companyMap.values())
      .sort((a, b) => a.name.localeCompare(b.name))
      .forEach((item) => {
        const option = new Option(item.name, item.code);
        productCompanySelect.appendChild(option);
      });
    if (current && companyMap.has(current)) {
      productCompanySelect.value = current;
    } else {
      productCompanySelect.value = '';
    }
    updateProductTypeOptions();
  }

  function updateProductTypeOptions() {
    if (!productTypeSelect) {
      return;
    }
    const companyCode = productCompanySelect ? productCompanySelect.value : '';
    const placeholder = productTypeSelect.dataset.placeholder || '선택하세요';
    productTypeSelect.innerHTML = '';
    productTypeSelect.appendChild(new Option(placeholder, ''));
    if (!companyCode) {
      setDisabled(productTypeSelect, true);
      updateProductCategoryOptions();
      return;
    }
    const list = getTypeList(companyCode);
    list.forEach((item) => {
      const option = new Option(item.name, item.code);
      productTypeSelect.appendChild(option);
    });
    const desired = productTypeSelect.dataset.selectedType;
    if (desired && list.some((item) => item.code === desired)) {
      productTypeSelect.value = desired;
    } else if (!list.some((item) => item.code === productTypeSelect.value)) {
      productTypeSelect.value = '';
    }
    productTypeSelect.dataset.selectedType = '';
    setDisabled(productTypeSelect, list.length === 0);
    updateProductCategoryOptions();
  }

  function updateProductCategoryOptions() {
    if (!productCategorySelect) {
      return;
    }
    const companyCode = productCompanySelect ? productCompanySelect.value : '';
    const typeCode = productTypeSelect ? productTypeSelect.value : '';
    const placeholder = productCategorySelect.dataset.placeholder || '선택하세요';
    productCategorySelect.innerHTML = '';
    productCategorySelect.appendChild(new Option(placeholder, ''));
    if (!companyCode || !typeCode) {
      setDisabled(productCategorySelect, true);
      return;
    }
    const list = getCategoryList(companyCode, typeCode);
    list.forEach((item) => {
      const option = new Option(item.name, item.code);
      productCategorySelect.appendChild(option);
    });
    const desired = productCategorySelect.dataset.selectedCategory;
    if (desired && list.some((item) => item.code === desired)) {
      productCategorySelect.value = desired;
    } else if (!list.some((item) => item.code === productCategorySelect.value)) {
      productCategorySelect.value = '';
    }
    productCategorySelect.dataset.selectedCategory = '';
    setDisabled(productCategorySelect, list.length === 0);
  }

  function registerCompany() {
    if (!companyPartialBtn) {
      return;
    }
    companyPartialBtn.addEventListener('click', () => {
      if (!companyInput || !companyCodeInput) {
        return;
      }
      const name = companyInput.value.trim();
      const code = companyCodeInput.value.trim();
      if (!name || !code) {
        alert('회사 이름과 코드를 입력하세요.');
        return;
      }
      fetch(`${ctx}/api/product-codes`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
          companyCode: code,
          typeCode: '0000',
          categoryCode: '0000',
          description: name,
        }),
      })
        .then(() => {
          alert('등록되었습니다.');
          ensureCompany(code, name);
          populateCompanyOptions(code);
          handleCompanyChange();
        })
        .catch(() => alert('관리자에 문의하시오'));
    });
  }

  function registerType() {
    if (!typePartialBtn) {
      return;
    }
    typePartialBtn.addEventListener('click', () => {
      const companyCode = companyCodeInput ? companyCodeInput.value.trim() : '';
      const typeCode = typeCodeInput ? typeCodeInput.value.trim() : '';
      const typeName = getTypeName();
      if (!companyCode || !typeCode || !typeName || !typeInput) {
        alert('회사, 타입 이름과 코드를 입력하세요.');
        return;
      }
      fetch(`${ctx}/api/product-codes`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
          companyCode,
          typeCode,
          categoryCode: '0000',
          description: typeName,
        }),
      })
        .then(() => {
          alert('등록되었습니다.');
          ensureType(companyCode, typeCode, typeName);
          populateTypeOptions(companyCode, typeCode);
          typeSelect.classList.remove('d-none');
          hideInlineInput(typeInput);
          if (typeInput) {
            typeInput.value = '';
            setDisabled(typeInput, true);
          }
          if (typeCodeInput) {
            typeCodeInput.value = typeCode;
            setDisabled(typeCodeInput, true);
          }
          handleTypeChange();
        })
        .catch(() => alert('관리자에 문의하시오'));
    });
  }

  function registerCategory() {
    if (!categoryPartialBtn) {
      return;
    }
    categoryPartialBtn.addEventListener('click', () => {
      const companyCode = companyCodeInput ? companyCodeInput.value.trim() : '';
      const typeCode = typeCodeInput ? typeCodeInput.value.trim() : '';
      const categoryCode = categoryCodeInput ? categoryCodeInput.value.trim() : '';
      const categoryName = getCategoryName();
      if (!companyCode || !typeCode || !categoryCode || !categoryName) {
        alert('회사, 타입, 카테고리 이름과 코드를 입력하세요.');
        return;
      }
      fetch(`${ctx}/api/product-codes`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
          companyCode,
          typeCode,
          categoryCode,
          description: categoryName,
        }),
      })
        .then(() => {
          alert('등록되었습니다.');
          ensureCategory(companyCode, typeCode, categoryCode, categoryName);
          populateCategoryOptions(companyCode, typeCode, categoryCode);
          categorySelect.classList.remove('d-none');
          hideInlineInput(categoryInput);
          if (categoryInput) {
            categoryInput.value = '';
            setDisabled(categoryInput, true);
          }
          if (categoryCodeInput) {
            categoryCodeInput.value = categoryCode;
            setDisabled(categoryCodeInput, true);
          }
          handleCategoryChange();
        })
        .catch(() => alert('관리자에 문의하시오'));
    });
  }

  function registerFullCode() {
    if (!fullRegisterBtn) {
      return;
    }
    fullRegisterBtn.addEventListener('click', () => {
      const companyCode = companyCodeInput ? companyCodeInput.value.trim() : '';
      const typeCode = typeCodeInput ? typeCodeInput.value.trim() : '';
      const categoryCode = categoryCodeInput ? categoryCodeInput.value.trim() : '';
      const categoryName = getCategoryName();
      if (!companyCode || !typeCode || !categoryCode || !categoryName) {
        alert('모든 코드를 입력하세요.');
        return;
      }
      fetch(`${ctx}/api/product-codes`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
          companyCode,
          typeCode,
          categoryCode,
          description: categoryName,
        }),
      })
        .then(() => {
          alert('제품코드가 등록되었습니다.');
          const typeName = getTypeName();
          ensureCompany(companyCode, companyMap.get(companyCode)?.name || companyCode);
          ensureType(companyCode, typeCode, typeName);
          ensureCategory(companyCode, typeCode, categoryCode, categoryName);
          populateTypeOptions(companyCode, typeCode);
          populateCategoryOptions(companyCode, typeCode, categoryCode);
          handleCategoryChange();
          syncProductCompanies(companyCode);
          if (productTabBtn) {
            productTabBtn.click();
          }
        })
        .catch(() => alert('관리자에 문의하시오'));
    });
  }

  if (companySelect) {
    populateCompanyOptions(companySelect.dataset.selectedCompany || '');
    companySelect.addEventListener('change', handleCompanyChange);
  }
  if (companyInput) {
    companyInput.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') {
        companySelect.classList.remove('d-none');
        hideInlineInput(companyInput);
        if (companyInput) {
          companyInput.value = '';
          setDisabled(companyInput, true);
        }
        if (companyCodeInput) {
          companyCodeInput.value = '';
          setDisabled(companyCodeInput, true);
        }
        companySelect.value = '';
        handleCompanyChange();
      }
    });
    companyInput.addEventListener('input', updateButtons);
  }
  if (companyCodeInput) {
    companyCodeInput.addEventListener('input', updateButtons);
  }
  if (typeSelect) {
    typeSelect.addEventListener('change', handleTypeChange);
  }
  if (typeInput) {
    typeInput.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') {
        typeSelect.classList.remove('d-none');
        typeSelect.value = '';
        hideInlineInput(typeInput);
        typeInput.value = '';
        setDisabled(typeInput, true);
        if (typeCodeInput) {
          typeCodeInput.value = '';
          setDisabled(typeCodeInput, true);
        }
        handleTypeChange();
      }
    });
    typeInput.addEventListener('input', updateButtons);
  }
  if (typeCodeInput) {
    typeCodeInput.addEventListener('input', () => {
      updateButtons();
      updateProductTypeOptions();
    });
  }
  if (categorySelect) {
    categorySelect.addEventListener('change', handleCategoryChange);
  }
  if (categoryInput) {
    categoryInput.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') {
        categorySelect.classList.remove('d-none');
        categorySelect.value = '';
        hideInlineInput(categoryInput);
        categoryInput.value = '';
        setDisabled(categoryInput, true);
        if (categoryCodeInput) {
          categoryCodeInput.value = '';
          setDisabled(categoryCodeInput, true);
        }
        handleCategoryChange();
      }
    });
    categoryInput.addEventListener('input', updateButtons);
  }
  if (categoryCodeInput) {
    categoryCodeInput.addEventListener('input', () => {
      updateButtons();
      updateProductCategoryOptions();
    });
  }

  if (productCompanySelect) {
    productCompanySelect.dataset.placeholder = productCompanySelect.querySelector('option[value=""]')?.textContent || '선택하세요';
    productCompanySelect.addEventListener('change', () => {
      updateProductTypeOptions();
    });
  }
  if (productTypeSelect) {
    productTypeSelect.dataset.placeholder = productTypeSelect.querySelector('option[value=""]')?.textContent || '선택하세요';
    productTypeSelect.addEventListener('change', updateProductCategoryOptions);
  }
  if (productCategorySelect) {
    productCategorySelect.dataset.placeholder = productCategorySelect.querySelector('option[value=""]')?.textContent || '선택하세요';
  }

  registerCompany();
  registerType();
  registerCategory();
  registerFullCode();

  handleCompanyChange();
  updateButtons();
  syncProductCompanies(productCompanySelect ? productCompanySelect.dataset.selectedCompany : '');
})();
(function () {
  let detailEditMode = false;

  function toggleDetailRowInternal(cb) {
    if (!cb) {
      return;
    }
    const row = cb.closest('tr');
    if (!row) {
      return;
    }
    row.querySelectorAll('.value').forEach((span) => {
      span.style.display = cb.checked ? 'none' : '';
    });
    row.querySelectorAll('.edit-field').forEach((field) => {
      field.style.display = cb.checked ? '' : 'none';
      field.disabled = !cb.checked;
    });
    document.querySelectorAll('#detailForm .save-btn').forEach((button) => {
      button.style.display = cb.checked ? '' : 'none';
    });
  }

  window.toggleDetailEdit = function () {
    detailEditMode = !detailEditMode;
    document.querySelectorAll('.edit-col').forEach((col) => {
      col.style.display = detailEditMode ? '' : 'none';
    });
    const checkbox = document.querySelector('#detailForm .edit-col input[type="checkbox"]');
    if (checkbox) {
      checkbox.checked = false;
      toggleDetailRowInternal(checkbox);
    }
  };

  window.toggleDetailRow = function (checkbox) {
    toggleDetailRowInternal(checkbox);
  };
})();
</script>

</body>
</html>
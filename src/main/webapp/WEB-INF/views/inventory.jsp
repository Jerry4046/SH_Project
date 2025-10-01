<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>제품 목록</title>
    <link rel="stylesheet" href="<c:url value='/css/bootstrap.min.css'/>">
    <style>
        th.sortable {
            user-select: none;
        }

        .sort-button {
            border: none;
            background: none;
            padding: 0;
            font-weight: 600;
            color: inherit;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            cursor: pointer;
        }

        .sort-button:hover {
            color: #0d6efd;
        }

        .sort-button:focus-visible {
            outline: 2px solid #0d6efd;
            outline-offset: 2px;
        }

        .sort-indicator {
            font-size: 0.8rem;
            min-width: 1rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: currentColor;
        }

        .stock-cell.stock-warning {
            background-color: #fff3cd;
            color: #856404;
            font-weight: 600;
        }

        .stock-cell.stock-danger {
            background-color: #f8d7da;
            color: #842029;
            font-weight: 600;
        }

        .detail-cell {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .detail-view {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .detail-form {
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .detail-save-controls {
            width: 100%;
            max-width: 240px;
            display: none;
        }

        .detail-save-controls .form-control {
            min-width: 0;
        }

        .auto-hide-alert {
            opacity: 1;
            transition: opacity 0.3s ease;
        }

        .auto-hide-alert.fade-out {
            opacity: 0;
        }

        #paginationControls ul.pagination {
            gap: 0.25rem;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container py-5">

    <c:if test="${not empty error}">
        <div class="alert alert-danger auto-hide-alert">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-success auto-hide-alert">${message}</div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">제품 목록</h2>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/product/register" class="btn btn-outline-primary">등록</a>
            <a href="${pageContext.request.contextPath}/product/details" class="btn btn-outline-info">상세</a>
            <button type="button" class="btn btn-outline-warning" onclick="toggleEditMode()">수정</button>
            <a href="${pageContext.request.contextPath}/product/delete" class="btn btn-outline-danger"
               onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        </div>
    </div>

    <div class="row g-2 mb-4">
        <div class="col-md-4">
            <input type="text" class="form-control" placeholder="상품명을 검색하세요" id="searchInput">
        </div>
        <div class="col-md-4">
            <select id="usageFilter" class="form-select">
                <option value="all">사용 여부 (전체)</option>
                <option value="사용">사용</option>
                <option value="미사용">미사용</option>
            </select>
        </div>
        <div class="col-md-4">
            <select id="stockFilter" class="form-select">
                <option value="all">재고 상태 (전체)</option>
                <option value="warning">주의 (주황)</option>
                <option value="danger">위험 (빨강)</option>
                <option value="normal">정상</option>
            </select>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th class="edit-col" style="display:none;"></th>
                <th class="sortable">
                    <button type="button" class="sort-button" data-column-index="1" data-type="text"
                            data-default-sort="true">
                        <span class="sort-label">상품명</span>
                        <span class="sort-indicator" aria-hidden="true"></span>
                    </button>
                </th>
                <th class="sortable">
                    <button type="button" class="sort-button" data-column-index="2" data-type="number">
                        <span class="sort-label">입수량</span>
                        <span class="sort-indicator" aria-hidden="true"></span>
                    </button>
                </th>
                <th class="sortable">
                    <button type="button" class="sort-button" data-column-index="3" data-type="number">
                        <span class="sort-label">BOX</span>
                        <span class="sort-indicator" aria-hidden="true"></span>
                    </button>
                </th>
                <th class="sortable">
                    <button type="button" class="sort-button" data-column-index="4" data-type="number">
                        <span class="sort-label">낱개</span>
                        <span class="sort-indicator" aria-hidden="true"></span>
                    </button>
                </th>
                <th class="sortable">
                    <button type="button" class="sort-button" data-column-index="5" data-type="number">
                        <span class="sort-label">총재고</span>
                        <span class="sort-indicator" aria-hidden="true"></span>
                    </button>
                </th>
                <th class="sortable">
                    <button type="button" class="sort-button" data-column-index="7" data-type="number">
                        <span class="sort-label">단가</span>
                        <span class="sort-indicator" aria-hidden="true"></span>
                    </button>
                </th>
                <th class="sortable">
                    <button type="button" class="sort-button" data-column-index="8" data-type="number">
                        <span class="sort-label">최소재고</span>
                        <span class="sort-indicator" aria-hidden="true"></span>
                    </button>
                </th>
                <th>사용여부</th>
                <th>상세</th>
            </tr>
            </thead>
            <tbody id="productTable">
            <c:forEach var="product" items="${productList}" varStatus="status">
                <c:set var="piecesPerBox" value="${product.piecesPerBox == null || product.piecesPerBox == 0 ? 1 : product.piecesPerBox}" />
                <c:set var="looseQty" value="${piecesPerBox > 0 ? totalQty mod piecesPerBox : totalQty}" />
                <c:set var="boxCount" value="${piecesPerBox > 0 ? (totalQty - looseQty) / piecesPerBox : 0}" />
                <c:set var="totalQty" value="${empty product.stock.totalQty ? 0 : product.stock.totalQty}" />
                <c:set var="minQty" value="${empty product.minStockQuantity ? 0 : product.minStockQuantity}" />
                <c:set var="priceValue" value="${product.getPrice()}" />
                <c:set var="stockState" value="normal" />
                <c:set var="stockClass" value="" />
                <c:if test="${minQty > 0}">
                    <c:choose>
                        <c:when test="${totalQty <= minQty}">
                            <c:set var="stockState" value="danger" />
                            <c:set var="stockClass" value="stock-danger" />
                        </c:when>
                        <c:when test="${totalQty <= minQty * 1.2}">
                            <c:set var="stockState" value="warning" />
                            <c:set var="stockClass" value="stock-warning" />
                        </c:when>
                    </c:choose>
                </c:if>
                <c:set var="formId" value="product-form-${status.index}" />
                <tr class="${product.active ? '' : 'text-muted'}" data-row-index="${status.index}"
                    data-usage="${product.active ? '사용' : '미사용'}" data-stock-state="${stockState}"
                    data-min-zero="${minQty == 0}">
                    <td class="edit-col" style="display:none;">
                        <input type="checkbox" class="row-check" onchange="toggleRow(this)">
                    </td>
                    <td data-column="pdName" data-sort-value="${fn:escapeXml(fn:toLowerCase(product.pdName))}">
                        <span class="value">${product.pdName}</span>
                        <input type="text" name="pdName" value="${product.pdName}"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <td data-column="piecesPerBox" data-sort-value="${piecesPerBox}">
                        <span class="value">${piecesPerBox} ea</span>
                        <input type="number" name="piecesPerBox" value="${piecesPerBox}" min="1"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <td data-column="boxCount" data-sort-value="${boxCount}">
                        <span class="value"><fmt:formatNumber value="${boxCount}" pattern="#,##0" /></span>
                    </td>
                    <td data-column="looseCount" data-sort-value="${looseQty}">
                        <span class="value"><fmt:formatNumber value="${looseQty}" pattern="#,##0" /></span>
                    </td>
                    <td data-column="totalQty" data-sort-value="${totalQty}" class="stock-cell ${stockClass}">
                        <span class="value"><fmt:formatNumber value="${totalQty}" pattern="#,##0" /> ea</span>
                        <input type="number" name="totalQty" value="${totalQty}"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <td data-column="price" data-sort-value="${priceValue}">
                        <span class="value"><fmt:formatNumber value="${priceValue}" pattern="#,##0" /></span>
                        <input type="number" step="0.1" name="price" value="${priceValue}"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <td data-column="minQty" data-sort-value="${minQty}">
                        <span class="value"><fmt:formatNumber value="${minQty}" pattern="#,##0" /> ea</span>
                        <input type="number" name="minStockQuantity" value="${product.minStockQuantity}"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <td data-column="usage" data-sort-value="${product.active ? '사용' : '미사용'}">
                        <span class="value">${product.active ? '사용' : '미사용'}</span>
                        <select name="active" class="form-select form-select-sm edit-field" style="display:none" disabled
                                form="${formId}">
                            <option value="true" ${product.active ? 'selected' : ''}>사용</option>
                            <option value="false" ${!product.active ? 'selected' : ''}>미사용</option>
                        </select>
                    </td>
                    <td data-column="detail" data-sort-value="${fn:escapeXml(product.productCode)}" class="detail-cell">
                        <div class="detail-view">
                            <a href="${pageContext.request.contextPath}/product/detail/${product.productCode}?itemCode=${product.itemCode}"
                               class="btn btn-sm btn-outline-primary">상세</a>
                        </div>
                        <form id="${formId}" action="${pageContext.request.contextPath}/product/update" method="post"
                              class="detail-form">
                            <input type="hidden" name="originalCode" value="${product.productCode}">
                            <input type="hidden" name="originalItemCode" value="${product.itemCode}">
                            <div class="input-group input-group-sm detail-save-controls" style="display:none;">
                                <input type="text" name="reason" class="form-control reason-input" placeholder="사유" required
                                       disabled>
                                <button type="submit" class="btn btn-success save-button" disabled>저장</button>
                            </div>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <nav id="paginationControls" class="mt-4 d-none" aria-label="제품 목록 페이지"></nav>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const autoHideAlerts = document.querySelectorAll('.auto-hide-alert');
        autoHideAlerts.forEach(alert => {
            alert.addEventListener('transitionend', () => alert.remove(), { once: true });
            setTimeout(() => alert.classList.add('fade-out'), 1000);
        });

        const ROWS_PER_PAGE = 20;
        const searchInput = document.getElementById('searchInput');
        const usageFilter = document.getElementById('usageFilter');
        const stockFilter = document.getElementById('stockFilter');
        const tableBody = document.getElementById('productTable');
        const paginationContainer = document.getElementById('paginationControls');
        const sortButtons = Array.from(document.querySelectorAll('th .sort-button'));

        if (!tableBody) {
            return;
        }

        const rows = Array.from(tableBody.querySelectorAll('tr[data-row-index]'));
        const rowDataList = rows.map((tr, index) => ({
            tr,
            originalIndex: index
        }));

        const state = {
            currentPage: 1,
            sort: null
        };

        function getCellSortValue(tr, columnIndex, type) {
            const cell = tr.children[columnIndex];
            if (!cell) {
                return type === 'number' ? 0 : '';
            }
            const value = cell.dataset.sortValue || '';
            if (type === 'number') {
                const parsed = Number(value);
                return Number.isNaN(parsed) ? 0 : parsed;
            }
            return value.toString().toLowerCase();
        }

        function updateAriaLabel(button, sortState) {
            const label = button.querySelector('.sort-label');
            const baseLabel = label ? label.textContent.trim() : '';
            let stateLabel = '정렬 안 함';
            if (sortState === 'asc') {
                stateLabel = '오름차순';
            } else if (sortState === 'desc') {
                stateLabel = '내림차순';
            }
            button.setAttribute('aria-label', baseLabel ? `${baseLabel} 정렬, ${stateLabel}` : stateLabel);
        }

        function refreshSortIndicators(activeButton, activeState) {
            sortButtons.forEach(button => {
                const stateValue = button === activeButton ? activeState : 'default';
                button.dataset.sortState = stateValue;
                const indicator = button.querySelector('.sort-indicator');
                if (indicator) {
                    const symbol = stateValue === 'asc' ? '▲' : stateValue === 'desc' ? '▼' : '↕';
                    indicator.textContent = symbol;
                }
                button.classList.toggle('text-primary', stateValue === 'asc' || stateValue === 'desc');
                updateAriaLabel(button, stateValue);
            });
        }

        function compareRows(a, b) {
            if (!state.sort) {
                return a.originalIndex - b.originalIndex;
            }
            const { columnIndex, type, direction } = state.sort;
            const valueA = getCellSortValue(a.tr, columnIndex, type);
            const valueB = getCellSortValue(b.tr, columnIndex, type);

            let result;
            if (type === 'number') {
                result = valueA - valueB;
            } else {
                result = valueA.localeCompare(valueB, 'ko');
            }

            if (result === 0) {
                return a.originalIndex - b.originalIndex;
            }
            return direction === 'asc' ? result : -result;
        }

        function passesFilters(tr) {
            const searchTerm = (searchInput?.value || '').trim().toLowerCase();
            const usageValue = usageFilter ? usageFilter.value : 'all';
            const stockValue = stockFilter ? stockFilter.value : 'all';

            if (searchTerm) {
                const nameCell = tr.querySelector('td[data-column="pdName"]');
                const nameValue = nameCell ? (nameCell.dataset.sortValue || '').toLowerCase() : '';
                if (!nameValue.includes(searchTerm)) {
                    return false;
                }
            }

            const rowUsage = tr.dataset.usage || '';
            if (usageValue !== 'all' && rowUsage !== usageValue) {
                return false;
            }

            const rowStockState = tr.dataset.stockState || 'normal';
            const isMinZero = tr.dataset.minZero === 'true';

            if (stockValue !== 'all') {
                if (stockValue === 'warning' || stockValue === 'danger') {
                    if (isMinZero || rowStockState !== stockValue) {
                        return false;
                    }
                } else if (stockValue === 'normal') {
                    if (!isMinZero && rowStockState !== 'normal') {
                        return false;
                    }
                }
            }

            return true;
        }

        function renderPagination(totalPages, visibleCount) {
            if (!paginationContainer) {
                return;
            }

            if (visibleCount <= ROWS_PER_PAGE) {
                paginationContainer.innerHTML = '';
                paginationContainer.classList.add('d-none');
                return;
            }

            paginationContainer.classList.remove('d-none');
            paginationContainer.innerHTML = '';

            const paginationList = document.createElement('ul');
            paginationList.className = 'pagination justify-content-center flex-wrap';

            const addPageButton = (label, page, options = {}) => {
                const { disabled = false, active = false, ariaLabel } = options;
                const li = document.createElement('li');
                li.className = 'page-item';
                if (disabled) li.classList.add('disabled');
                if (active) li.classList.add('active');

                const button = document.createElement('button');
                button.type = 'button';
                button.className = 'page-link';
                button.textContent = label;
                if (ariaLabel) {
                    button.setAttribute('aria-label', ariaLabel);
                }

                if (disabled || active) {
                    button.disabled = true;
                } else {
                    button.addEventListener('click', () => {
                        state.currentPage = page;
                        applyAndRender();
                    });
                }

                li.appendChild(button);
                paginationList.appendChild(li);
            };

            if (totalPages > 10) {
                addPageButton('<<', 1, { disabled: state.currentPage === 1, ariaLabel: '첫 페이지' });
                addPageButton('<', state.currentPage - 1, { disabled: state.currentPage === 1, ariaLabel: '이전 페이지' });

                const segmentIndex = Math.floor((state.currentPage - 1) / 10);
                const startPage = segmentIndex * 10 + 1;
                const endPage = Math.min(startPage + 9, totalPages);

                for (let page = startPage; page <= endPage; page++) {
                    addPageButton(String(page), page, { active: page === state.currentPage });
                }

                addPageButton('>', state.currentPage + 1, {
                    disabled: state.currentPage === totalPages,
                    ariaLabel: '다음 페이지'
                });
                addPageButton('>>', totalPages, {
                    disabled: state.currentPage === totalPages,
                    ariaLabel: '마지막 페이지'
                });
            } else {
                for (let page = 1; page <= totalPages; page++) {
                    addPageButton(String(page), page, { active: page === state.currentPage });
                }
            }

            paginationContainer.appendChild(paginationList);
        }

        function applyAndRender(options = {}) {
            const { resetPage = false } = options;
            if (resetPage) {
                state.currentPage = 1;
            }

            const orderedRows = rowDataList.slice().sort(compareRows);
            orderedRows.forEach(item => tableBody.appendChild(item.tr));

            const filteredRows = orderedRows.filter(item => passesFilters(item.tr));
            const totalPages = Math.max(1, Math.ceil(filteredRows.length / ROWS_PER_PAGE));

            if (state.currentPage > totalPages) {
                state.currentPage = totalPages;
            }

            rowDataList.forEach(item => {
                item.tr.style.display = 'none';
            });

            const startIndex = (state.currentPage - 1) * ROWS_PER_PAGE;
            const endIndex = startIndex + ROWS_PER_PAGE;

            filteredRows.forEach((item, index) => {
                if (index >= startIndex && index < endIndex) {
                    item.tr.style.display = '';
                }
            });

            renderPagination(totalPages, filteredRows.length);
        }

        function applySort(button, forcedState) {
            if (!button) {
                return;
            }
            const columnIndex = parseInt(button.dataset.columnIndex, 10);
            const type = button.dataset.type || 'text';
            const currentState = button.dataset.sortState || 'default';
            const nextState = forcedState || (currentState === 'asc' ? 'desc' : currentState === 'desc' ? 'default' : 'asc');

            if (nextState === 'default') {
                state.sort = null;
            } else {
                state.sort = {
                    columnIndex,
                    type,
                    direction: nextState,
                    button
                };
            }

            refreshSortIndicators(button, nextState);
            applyAndRender({ resetPage: true });
        }

        sortButtons.forEach(button => {
            button.dataset.sortState = 'default';
            const indicator = button.querySelector('.sort-indicator');
            if (indicator) {
                indicator.textContent = '↕';
            }
            updateAriaLabel(button, 'default');
            button.addEventListener('click', () => applySort(button));
        });

        const defaultSortButton = sortButtons.find(button => button.dataset.defaultSort === 'true');
        if (defaultSortButton) {
            applySort(defaultSortButton, 'asc');
        } else {
            applyAndRender({ resetPage: true });
        }

        if (searchInput) {
            searchInput.addEventListener('input', () => {
                applyAndRender({ resetPage: true });
            });
        }
        if (usageFilter) {
            usageFilter.addEventListener('change', () => {
                applyAndRender({ resetPage: true });
            });
        }
        if (stockFilter) {
            stockFilter.addEventListener('change', () => {
                applyAndRender({ resetPage: true });
            });
        }
    });

    let editMode = false;
    function toggleEditMode() {
        editMode = !editMode;
        document.querySelectorAll('.edit-col').forEach(col => {
            col.style.display = editMode ? '' : 'none';
        });
        document.querySelectorAll('.row-check').forEach(checkbox => {
            checkbox.checked = false;
            toggleRow(checkbox);
        });
    }

    function toggleRow(checkbox) {
        const row = checkbox.closest('tr');
        if (!row) {
            return;
        }
        const spans = row.querySelectorAll('.value');
        const edits = row.querySelectorAll('.edit-field');
        const detailView = row.querySelector('.detail-view');
        const saveGroups = row.querySelectorAll('.detail-save-controls');

        const showEdit = checkbox.checked;
        spans.forEach(span => {
            span.style.display = showEdit ? 'none' : '';
        });
        edits.forEach(field => {
            field.style.display = showEdit ? '' : 'none';
            field.disabled = !showEdit;
            if (!showEdit && field.classList.contains('reason-input')) {
                field.value = '';
            }
        });
        if (detailView) {
            detailView.style.display = showEdit ? 'none' : '';
        }
        saveGroups.forEach(group => {
            group.style.display = showEdit ? '' : 'none';
            group.querySelectorAll('input, select, textarea, button').forEach(element => {
                element.disabled = !showEdit;
                if (!showEdit && element.tagName === 'INPUT') {
                    element.value = '';
                }
            });
        });
    }

    window.toggleEditMode = toggleEditMode;
    window.toggleRow = toggleRow;
</script>

</body>
</html>

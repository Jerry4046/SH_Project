<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>제품 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        th.sortable {
            cursor: pointer;
            user-select: none;
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

        .auto-hide-alert {
            opacity: 1;
            transition: opacity 0.3s ease;
        }

        .auto-hide-alert.fade-out {
            opacity: 0;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" /> <!-- ✅ 헤더 포함 -->

<div class="container mt-5">

    <c:if test="${not empty error}">
        <div class="alert alert-danger auto-hide-alert">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-success auto-hide-alert">${message}</div>
    </c:if>

    <!-- 제목 + 버튼 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>제품 목록</h2>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/product/register" class="btn btn-outline-primary">등록</a>
            <a href="${pageContext.request.contextPath}/product/details" class="btn btn-outline-info">상세</a>
            <button type="button" class="btn btn-outline-warning" onclick="toggleEditMode()">수정</button>
            <a href="/product/delete" class="btn btn-outline-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        </div>
    </div>

    <!-- 검색 및 필터 -->
    <div class="row g-2 mb-3">
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

    <!-- 테이블 -->
    <div class="table-responsive">
       <table class="table table-hover align-middle text-center">
            <thead class="table-light">
              <tr>
                  <th class="edit-col" style="display:none;"></th>
                  <th class="sortable" data-column-index="1" data-type="text">상품명</th>
                  <th class="sortable" data-column-index="2" data-type="number">입수량</th>
                  <th class="sortable" data-column-index="3" data-type="number">BOX</th>
                  <th class="sortable" data-column-index="4" data-type="number">낱개</th>
                  <th class="sortable" data-column-index="5" data-type="number">총재고</th>
                  <th class="sortable" data-column-index="6" data-type="number">단가</th>
                  <th class="sortable" data-column-index="7" data-type="number">최소재고</th>
                  <th class="sortable" data-column-index="8" data-type="text">사용여부</th>
                  <th class="sortable" data-column-index="9" data-type="text">상세</th>
              </tr>
              </thead>
              <tbody id="productTable">
              <c:forEach var="product" items="${productList}" varStatus="status">
                  <c:set var="piecesPerBox" value="${empty product.stock.piecesPerBox ? 0 : product.stock.piecesPerBox}" />
                  <c:set var="boxQty" value="${empty product.stock.boxQty ? 0 : product.stock.boxQty}" />
                  <c:set var="looseQty" value="${empty product.stock.looseQty ? 0 : product.stock.looseQty}" />
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
                  <form action="${pageContext.request.contextPath}/product/update" method="post" data-row-index="${status.index}" data-usage="${product.active ? '사용' : '미사용'}" data-stock-state="${stockState}" data-min-zero="${minQty == 0}">
                  <tr class="${product.active ? '' : 'text-muted'}" data-row-index="${status.index}" data-usage="${product.active ? '사용' : '미사용'}" data-stock-state="${stockState}" data-min-zero="${minQty == 0}">
                      <td class="edit-col" style="display:none;">
                          <input type="checkbox" class="row-check" onchange="toggleRow(this)">
                      </td>
                      <td data-column="pdName" data-sort-value="${fn:escapeXml(fn:toLowerCase(product.pdName))}">
                          <span class="value">${product.pdName}</span>
                          <input type="text" name="pdName" value="${product.pdName}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td data-column="piecesPerBox" data-sort-value="${piecesPerBox}">
                          <span class="value">${piecesPerBox} ea</span>
                          <input type="number" name="piecesPerBox" value="${piecesPerBox}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td data-column="boxQty" data-sort-value="${boxQty}">
                          <span class="value">${boxQty} BOX</span>
                          <input type="number" name="boxQty" value="${boxQty}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td data-column="looseQty" data-sort-value="${looseQty}">
                          <span class="value">${looseQty} ea</span>
                          <input type="number" name="looseQty" value="${looseQty}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td data-column="totalQty" data-sort-value="${totalQty}" class="stock-cell ${stockClass}">
                          <span class="value"><fmt:formatNumber value="${totalQty}" pattern="#,##0" /> ea</span>
                          <input type="number" name="totalQty" value="${totalQty}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td data-column="price" data-sort-value="${priceValue}">
                          <span class="value"><fmt:formatNumber value="${priceValue}" pattern="#,##0" /></span>
                          <input type="number" step="0.1" name="price" value="${priceValue}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td data-column="minQty" data-sort-value="${minQty}">
                          <span class="value"><fmt:formatNumber value="${minQty}" pattern="#,##0" /> ea</span>
                          <input type="number" name="minStockQuantity" value="${product.minStockQuantity}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td data-column="usage" data-sort-value="${product.active ? '사용' : '미사용'}">
                          <span class="value">${product.active ? '사용' : '미사용'}</span>
                          <select name="active" class="form-select form-select-sm edit-field" style="display:none" disabled>
                              <option value="true" ${product.active ? 'selected' : ''}>사용</option>
                              <option value="false" ${!product.active ? 'selected' : ''}>미사용</option>
                          </select>
                      </td>
                      <td data-column="detail" data-sort-value="${fn:escapeXml(product.productCode)}">
                          <a href="${pageContext.request.contextPath}/product/detail/${product.productCode}?itemCode=${product.itemCode}" class="btn btn-sm btn-outline-primary">상세</a>
                          <input type="hidden" name="originalCode" value="${product.productCode}">
                          <input type="hidden" name="originalItemCode" value="${product.itemCode}">
                          <input type="text" name="reason" class="form-control form-control-sm mt-1 save-btn" placeholder="사유" style="display:none" required>
                          <button type="submit" class="btn btn-sm btn-success mt-1 save-btn" style="display:none">저장</button>
                      </td>
                  </tr>
                  </form>
                </c:forEach>
                </tbody>
          </table>
      </div>
  </div>

<!-- ✅ 검색 / 정렬 스크립트 -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
            const autoHideAlerts = document.querySelectorAll('.auto-hide-alert');

            if (autoHideAlerts.length > 0) {
                autoHideAlerts.forEach((alert) => {
                    alert.addEventListener('transitionend', () => {
                        alert.remove();
                    }, { once: true });
                });

                setTimeout(() => {
                    autoHideAlerts.forEach((alert) => {
                        alert.classList.add('fade-out');
                    });
                }, 1000);
            }

        const searchInput = document.getElementById('searchInput');
        const usageFilter = document.getElementById('usageFilter');
        const stockFilter = document.getElementById('stockFilter');
        const tableBody = document.getElementById('productTable');
        const dataRows = Array.from(tableBody.querySelectorAll('tr[data-row-index]'));
        const rowInfos = dataRows.map(tr => ({
            tr,
            container: tr.closest('form') || tr
        }));
        const defaultOrder = rowInfos.map(info => info.container);

        function applyFilters() {
            const searchTerm = (searchInput.value || '').toLowerCase();
            const usageValue = usageFilter.value;
            const stockValue = stockFilter.value;

            rowInfos.forEach(info => {
                const { tr, container } = info;
                let visible = true;

                const nameCell = tr.querySelector('td[data-column="pdName"]');
                const nameValue = nameCell ? (nameCell.dataset.sortValue || '').toLowerCase() : '';
                if (searchTerm && !nameValue.includes(searchTerm)) {
                    visible = false;
                }

                const rowUsage = tr.dataset.usage || '';
                if (visible && usageValue !== 'all' && rowUsage !== usageValue) {
                    visible = false;
                }

                const stockState = tr.dataset.stockState || 'normal';
                const isMinZero = tr.dataset.minZero === 'true';
                if (visible && stockValue !== 'all') {
                    if (stockValue === 'warning' || stockValue === 'danger') {
                        if (isMinZero || stockState !== stockValue) {
                            visible = false;
                        }
                    } else if (stockValue === 'normal') {
                        if (!isMinZero && stockState !== 'normal') {
                            visible = false;
                        }
                    }
                }

                tr.style.display = visible ? '' : 'none';
                if (container !== tr) {
                    container.style.display = visible ? '' : 'none';
                }
            });
        }

        function getCellSortValue(tr, columnIndex, type) {
            const cell = tr.children[columnIndex];
            if (!cell) return '';
            const value = cell.dataset.sortValue || '';
            if (type === 'number') {
                return Number(value);
            }
            return value.toString().toLowerCase();
        }

        function resetSort() {
            defaultOrder.forEach(container => tableBody.appendChild(container));
            document.querySelectorAll('th.sortable').forEach(header => header.dataset.state = 'default');
        }

        document.querySelectorAll('th.sortable').forEach(header => {
            header.dataset.state = 'default';
            header.addEventListener('click', () => {
                const columnIndex = parseInt(header.dataset.columnIndex, 10);
                const type = header.dataset.type;
                const currentState = header.dataset.state;
                const nextState = currentState === 'default' ? 'desc' : currentState === 'desc' ? 'asc' : 'default';

                document.querySelectorAll('th.sortable').forEach(h => {
                    if (h !== header) {
                        h.dataset.state = 'default';
                    }
                });
                header.dataset.state = nextState;

                if (nextState === 'default') {
                    resetSort();
                    return;
                }

                const sortedInfos = rowInfos.slice().sort((a, b) => {
                    const valueA = getCellSortValue(a.tr, columnIndex, type);
                    const valueB = getCellSortValue(b.tr, columnIndex, type);
                    if (valueA < valueB) return nextState === 'asc' ? -1 : 1;
                    if (valueA > valueB) return nextState === 'asc' ? 1 : -1;
                    return Number(a.tr.dataset.rowIndex) - Number(b.tr.dataset.rowIndex);
                });

                sortedInfos.forEach(info => {
                    tableBody.appendChild(info.container);
                });
            });
        });

        searchInput.addEventListener('input', applyFilters);
        usageFilter.addEventListener('change', applyFilters);
        stockFilter.addEventListener('change', applyFilters);
        applyFilters();
    });

    let editMode = false;
    function toggleEditMode() {
        editMode = !editMode;
        document.querySelectorAll('.edit-col').forEach(c => c.style.display = editMode ? '' : 'none');
        document.querySelectorAll('.row-check').forEach(cb => {
            cb.checked = false;
            toggleRow(cb);
        });
    }

    function toggleRow(checkbox) {
        const row = checkbox.closest('tr');
        const spans = row.querySelectorAll('.value');
        const edits = row.querySelectorAll('.edit-field');
        const saveBtns = row.querySelectorAll('.save-btn');
        spans.forEach(s => s.style.display = checkbox.checked ? 'none' : '');
        edits.forEach(e => {
            e.style.display = checkbox.checked ? '' : 'none';
            e.disabled = !checkbox.checked;
        });
        saveBtns.forEach(b => b.style.display = checkbox.checked ? '' : 'none');
    }

    window.toggleEditMode = toggleEditMode;
    window.toggleRow = toggleRow;
  </script>


</body>
</html>
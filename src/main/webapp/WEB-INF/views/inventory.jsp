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
            text-align: center;
            vertical-align: middle;
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

        .product-name[data-image-url] {
            cursor: pointer;
            position: relative;
        }


        .variant-row {
            background-color: #f8f9fa;
        }

        .variant-row td {
            font-size: 0.9em;
            padding-top: 0.25rem !important;
            padding-bottom: 0.25rem !important;
        }

        .variant-toggle {
            cursor: pointer;
            color: #0d6efd;
        }

        .variant-toggle:hover {
            text-decoration: underline;
        }

        .variant-badge {
            font-size: 0.75em;
            padding: 0.2em 0.5em;
            margin-left: 0.25rem;
        }

        .variant-sum-mismatch {
            color: #dc3545;
            font-weight: bold;
        }

        .variant-sum-match {
            color: #198754;
        }

        .product-name {
            display: inline-block;
            max-width: 180px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            vertical-align: middle;
        }
        .text-end {
            text-align: right !important;
        }

        th.text-end .sort-button {
            justify-content: flex-end;
            width: 100%;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid py-5" style="max-width: 1540px;">

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
            <input type="text" class="form-control" placeholder="제품명을 검색하세요" id="searchInput">
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
                        <span class="sort-label">제품명</span>
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
                <c:set var="totalQty" value="${empty product.stock.totalQty ? 0 : product.stock.totalQty}" />
                <c:set var="piecesPerBox" value="${product.piecesPerBox == null || product.piecesPerBox == 0 ? 1 : product.piecesPerBox}" />
                <c:set var="boxCount" value="${piecesPerBox gt 0 ? totalQty / piecesPerBox : 0}" />
                <c:set var="looseQty" value="${piecesPerBox gt 0 ? totalQty % piecesPerBox : totalQty}" />
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
                <c:set var="imageUrl" value="${productImageUrls[product.productId]}" />
                <c:set var="formId" value="product-form-${status.index}" />
                <tr class="${product.active ? '' : 'text-muted'}" data-row-index="${status.index}"
                    data-usage="${product.active ? '사용' : '미사용'}" data-stock-state="${stockState}"
                    data-min-zero="${minQty == 0}">
                    <td class="edit-col" style="display:none;">
                        <input type="checkbox" class="row-check" onchange="toggleRow(this)">
                    </td>
                    <td data-column="pdName" data-sort-value="${fn:escapeXml(fn:toLowerCase(product.pdName))}">
                        <span class="value product-name"
                              <c:if test="${not empty imageUrl}">
                                  data-image-url="${pageContext.request.contextPath}${imageUrl}"
                                  data-product-name="${fn:escapeXml(product.pdName)}"
                                  role="button"
                                  aria-haspopup="dialog"
                              </c:if>>
                            ${product.pdName}
                        </span>
                        <input type="text" name="pdName" value="${product.pdName}"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <c:set var="variants" value="${productVariantsMap[product.productId]}" />
                    <td class="text-end" data-column="piecesPerBox" data-sort-value="${piecesPerBox}">
                        <c:choose>
                            <c:when test="${not empty variants and fn:length(variants) > 0}">
                                <span class="value variant-toggle" data-product-id="${product.productId}"
                                      title="입수량별 변형 ${fn:length(variants)}개">
                                    <c:forEach var="v" items="${variants}" varStatus="vs">
                                        ${v.piecesPerBox}<c:if test="${!vs.last}">/</c:if>
                                    </c:forEach>
                                    <span class="badge bg-info variant-badge">${fn:length(variants)}</span>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="value variant-toggle" data-product-id="${product.productId}" 
                                      title="클릭하여 입수량 관리">${piecesPerBox} ea</span>
                            </c:otherwise>
                        </c:choose>
                        <input type="number" name="piecesPerBox" value="${piecesPerBox}" min="1"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <td class="text-end" data-column="boxCount" data-sort-value="${boxCount}">
                        <span class="value"><fmt:formatNumber value="${boxCount}" pattern="#,##0" /></span>
                    </td>
                    <td class="text-end" data-column="looseCount" data-sort-value="${looseQty}">
                        <span class="value"><fmt:formatNumber value="${looseQty}" pattern="#,##0" /></span>
                    </td>
                    <td class="text-end" data-column="totalQty" data-sort-value="${totalQty}" class="stock-cell ${stockClass}">
                        <span class="value"><fmt:formatNumber value="${totalQty}" pattern="#,##0" /> ea</span>
                        <input type="number" name="totalQty" value="${totalQty}"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <td class="text-end" data-column="price" data-sort-value="${priceValue}">
                        <span class="value"><fmt:formatNumber value="${priceValue}" pattern="#,##0" /></span>
                        <input type="number" step="0.1" name="price" value="${priceValue}"
                               class="form-control form-control-sm edit-field" style="display:none" disabled
                               form="${formId}">
                    </td>
                    <td class="text-end" data-column="minQty" data-sort-value="${minQty}">
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

   
    <div class="modal fade" id="variantModal" tabindex="-1" aria-hidden="true"
         aria-labelledby="variantModalTitle">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="variantModalTitle">입수량별 재고 관리</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="variantProductId" value="">
                    <input type="hidden" id="variantTotalQty" value="">
                    <table class="table table-sm table-bordered mb-3">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width:100px;">입수량</th>
                                <th class="text-center" style="width:100px;">BOX</th>
                                <th class="text-center" style="width:100px;">낱개</th>
                                <th class="text-center" style="width:100px;">소계</th>
                                <th class="text-center" style="width:50px;"></th>
                            </tr>
                        </thead>
                        <tbody id="variantModalBody"></tbody>
                        <tfoot class="table-secondary">
                            <tr>
                                <th colspan="3" class="text-end">변형 합계</th>
                                <th class="text-center" id="variantModalSum">0</th>
                                <th></th>
                            </tr>
                        </tfoot>
                    </table>
                    
                    <div class="card mb-3">
                        <div class="card-header py-2">
                            <strong>새 입수량 추가</strong>
                        </div>
                        <div class="card-body py-2">
                            <div class="row g-2 align-items-end">
                                <div class="col-3">
                                    <label class="form-label small mb-1">입수량</label>
                                    <input type="number" id="newPiecesPerBox" class="form-control form-control-sm" min="1" placeholder="예: 500">
                                </div>
                                <div class="col-3">
                                    <label class="form-label small mb-1">BOX</label>
                                    <input type="number" id="newBoxQty" class="form-control form-control-sm" min="0" value="0">
                                </div>
                                <div class="col-3">
                                    <label class="form-label small mb-1">낱개</label>
                                    <input type="number" id="newLooseQty" class="form-control form-control-sm" min="0" value="0">
                                </div>
                                <div class="col-3">
                                    <button type="button" id="addVariantBtn" class="btn btn-outline-primary btn-sm w-100">
                                        <span>+ 추가</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div id="variantValidation" class="alert mb-0 py-2" style="display:none;"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="saveVariantsBtn" class="btn btn-primary">저장</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>
<div class="modal fade" id="productImageModal" tabindex="-1" aria-hidden="true"
         aria-labelledby="productImageModalTitle">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productImageModalTitle"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                </div>
                <div class="modal-body text-center">
                    <img src="" alt="" id="productImageModalImg" class="img-fluid">
                </div>
            </div>
        </div>
    </div>

    <nav id="paginationControls" class="mt-4 d-none" aria-label="제품 목록 페이지"></nav>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

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
        const hasBootstrapModal = typeof bootstrap !== 'undefined' && typeof bootstrap.Modal === 'function';
        const productImageModalElement = document.getElementById('productImageModal');
        const productImageModalImage = document.getElementById('productImageModalImg');
        const productImageModalTitle = document.getElementById('productImageModalTitle');
        const productImageModalInstance = hasBootstrapModal && productImageModalElement
            ? new bootstrap.Modal(productImageModalElement)
            : null;

        if (productImageModalInstance && productImageModalElement) {
            productImageModalElement.addEventListener('hidden.bs.modal', () => {
                if (productImageModalImage) {
                    productImageModalImage.src = '';
                    productImageModalImage.alt = '';
                }
                if (productImageModalTitle) {
                    productImageModalTitle.textContent = '';
                }
            });
        }

        const productNameCells = document.querySelectorAll('.product-name[data-image-url]');
        productNameCells.forEach(cell => {
            cell.addEventListener('click', event => {
                if (!productImageModalInstance) {
                    return;
                }
                const url = cell.dataset.imageUrl;
                if (!url) {
                    return;
                }
                event.preventDefault();
                const productName = cell.dataset.productName || cell.textContent.trim();
                if (productImageModalTitle) {
                    productImageModalTitle.textContent = productName || '제품 이미지';
                }
                if (productImageModalImage) {
                    productImageModalImage.src = url;
                    productImageModalImage.alt = productName ? `${productName} 이미지` : '제품 이미지';
                }
                productImageModalInstance.show();
            });
            cell.addEventListener('keydown', event => {
                if (!productImageModalInstance) {
                    return;
                }
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    cell.click();
                }
            });
            cell.setAttribute('tabindex', '0');
        });

        // 변형 모달 관련
        const variantModalElement = document.getElementById('variantModal');
        const variantModalBody = document.getElementById('variantModalBody');
        const variantModalSum = document.getElementById('variantModalSum');
        const variantValidation = document.getElementById('variantValidation');
        const variantProductId = document.getElementById('variantProductId');
        const variantTotalQty = document.getElementById('variantTotalQty');
        const addVariantBtn = document.getElementById('addVariantBtn');
        const saveVariantsBtn = document.getElementById('saveVariantsBtn');
        const variantModalInstance = hasBootstrapModal && variantModalElement
            ? new bootstrap.Modal(variantModalElement)
            : null;
        const contextPath = '${pageContext.request.contextPath}';

        let currentVariants = [];
        let deletedVariantIds = [];

        function calculateSubTotal(piecesPerBox, boxQty, looseQty) {
            return (parseInt(piecesPerBox) || 0) * (parseInt(boxQty) || 0) + (parseInt(looseQty) || 0);
        }

        function renderVariantRows() {
            let html = '';
            let sum = 0;
            currentVariants.forEach((v, index) => {
                const subTotal = calculateSubTotal(v.piecesPerBox, v.boxQty, v.looseQty);
                sum += subTotal;
                html += '<tr data-index="' + index + '">' +
                    '<td class="text-center">' + v.piecesPerBox + ' ea</td>' +
                    '<td><input type="number" class="form-control form-control-sm text-end variant-box" value="' + (v.boxQty || 0) + '" min="0" data-index="' + index + '"></td>' +
                    '<td><input type="number" class="form-control form-control-sm text-end variant-loose" value="' + (v.looseQty || 0) + '" min="0" data-index="' + index + '"></td>' +
                    '<td class="text-end variant-subtotal">' + subTotal.toLocaleString() + '</td>' +
                    '<td class="text-center"><button type="button" class="btn btn-outline-danger btn-sm delete-variant" data-index="' + index + '" title="삭제">🗑</button></td>' +
                '</tr>';
            });
            variantModalBody.innerHTML = html || '<tr><td colspan="5" class="text-muted text-center">변형이 없습니다. 아래에서 추가하세요.</td></tr>';
            variantModalSum.textContent = sum.toLocaleString();
            updateValidation(sum);
        }

        function updateValidation(sum) {
            const totalQty = parseInt(variantTotalQty.value) || 0;
            if (currentVariants.length === 0) {
                variantValidation.style.display = 'none';
            } else if (sum === totalQty) {
                variantValidation.className = 'alert alert-success mb-0 py-2';
                variantValidation.innerHTML = '✓ 변형 합계(' + sum.toLocaleString() + ')와 총재고(' + totalQty.toLocaleString() + ') 일치';
                variantValidation.style.display = 'block';
            } else {
                variantValidation.className = 'alert alert-danger mb-0 py-2';
                variantValidation.innerHTML = '✗ 변형 합계(' + sum.toLocaleString() + ')와 총재고(' + totalQty.toLocaleString() + ') 불일치 (차이: ' + (sum - totalQty).toLocaleString() + ')';
                variantValidation.style.display = 'block';
            }
        }

        function recalculateSum() {
            let sum = 0;
            currentVariants.forEach((v, index) => {
                const subTotal = calculateSubTotal(v.piecesPerBox, v.boxQty, v.looseQty);
                sum += subTotal;
                const row = variantModalBody.querySelector('tr[data-index="' + index + '"]');
                if (row) {
                    row.querySelector('.variant-subtotal').textContent = subTotal.toLocaleString();
                }
            });
            variantModalSum.textContent = sum.toLocaleString();
            updateValidation(sum);
        }

        variantModalBody.addEventListener('input', function(e) {
            if (e.target.classList.contains('variant-box') || e.target.classList.contains('variant-loose')) {
                const index = parseInt(e.target.dataset.index);
                if (e.target.classList.contains('variant-box')) {
                    currentVariants[index].boxQty = parseInt(e.target.value) || 0;
                } else {
                    currentVariants[index].looseQty = parseInt(e.target.value) || 0;
                }
                recalculateSum();
            }
        });

        variantModalBody.addEventListener('click', function(e) {
            if (e.target.classList.contains('delete-variant')) {
                const index = parseInt(e.target.dataset.index);
                if (confirm('이 입수량(' + currentVariants[index].piecesPerBox + ' ea)을 삭제하시겠습니까?')) {
                    const deleted = currentVariants.splice(index, 1)[0];
                    if (deleted.variantId) {
                        deletedVariantIds.push(deleted.variantId);
                    }
                    renderVariantRows();
                }
            }
        });

        addVariantBtn.addEventListener('click', function() {
            const piecesPerBox = parseInt(document.getElementById('newPiecesPerBox').value);
            const boxQty = parseInt(document.getElementById('newBoxQty').value) || 0;
            const looseQty = parseInt(document.getElementById('newLooseQty').value) || 0;

            if (!piecesPerBox || piecesPerBox <= 0) {
                alert('입수량을 입력하세요.');
                return;
            }

            if (currentVariants.some(v => v.piecesPerBox === piecesPerBox)) {
                alert('이미 존재하는 입수량입니다.');
                return;
            }

            currentVariants.push({
                variantId: null,
                piecesPerBox: piecesPerBox,
                boxQty: boxQty,
                looseQty: looseQty
            });

            document.getElementById('newPiecesPerBox').value = '';
            document.getElementById('newBoxQty').value = '0';
            document.getElementById('newLooseQty').value = '0';

            renderVariantRows();
        });

        saveVariantsBtn.addEventListener('click', async function() {
            const productId = variantProductId.value;
            if (!productId) return;

            let sum = 0;
            currentVariants.forEach(v => {
                sum += calculateSubTotal(v.piecesPerBox, v.boxQty, v.looseQty);
            });

            const totalQty = parseInt(variantTotalQty.value) || 0;
            if (currentVariants.length > 0 && sum !== totalQty) {
                alert('변형 합계(' + sum.toLocaleString() + ')와 총재고(' + totalQty.toLocaleString() + ')가 일치하지 않습니다.\n저장하려면 합계를 맞춰주세요.');
                return;
            }

            try {
                saveVariantsBtn.disabled = true;
                saveVariantsBtn.textContent = '저장 중...';

                // 삭제된 변형 처리
                for (const variantId of deletedVariantIds) {
                    await fetch(contextPath + '/api/products/' + productId + '/variants/' + variantId, {
                        method: 'DELETE'
                    });
                }

                for (const v of currentVariants) {
                    const payload = {
                        piecesPerBox: v.piecesPerBox,
                        boxQty: v.boxQty,
                        looseQty: v.looseQty
                    };

                    if (v.variantId) {
                        await fetch(contextPath + '/api/products/' + productId + '/variants/' + v.variantId, {
                            method: 'PUT',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(payload)
                        });
                    } else {
                        await fetch(contextPath + '/api/products/' + productId + '/variants', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(payload)
                        });
                    }
                }

                alert('저장되었습니다.');
                variantModalInstance.hide();
                location.reload();
            } catch (error) {
                console.error('저장 실패:', error);
                alert('저장 중 오류가 발생했습니다.');
            } finally {
                saveVariantsBtn.disabled = false;
                saveVariantsBtn.textContent = '저장';
            }
        });

        const variantToggles = document.querySelectorAll('.variant-toggle');
        console.log('variant-toggle 요소 수:', variantToggles.length);
        console.log('variantModalInstance:', variantModalInstance);
        variantToggles.forEach(toggle => {
            toggle.addEventListener('click', async event => {
                event.preventDefault();
                const productId = toggle.dataset.productId;
                const totalQtyCell = toggle.closest('tr').querySelector('td[data-column="totalQty"]');
                const totalQtyValue = totalQtyCell ? parseInt(totalQtyCell.dataset.sortValue) || 0 : 0;

                if (!productId || !variantModalInstance) return;

                variantProductId.value = productId;
                deletedVariantIds = [];
                variantTotalQty.value = totalQtyValue;

                try {
                    const response = await fetch(contextPath + '/api/products/' + productId + '/variants');
                    currentVariants = await response.json();
                    currentVariants = currentVariants.map(v => ({
                        variantId: v.variantId,
                        piecesPerBox: v.piecesPerBox,
                        boxQty: v.boxQty || 0,
                        looseQty: v.looseQty || 0
                    }));

                    renderVariantRows();
                    variantModalInstance.show();
                } catch (error) {
                    console.error('변형 조회 실패:', error);
                }
            });
        });


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

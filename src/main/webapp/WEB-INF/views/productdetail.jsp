<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
    <style>
        .combo-field {
            position: relative;
        }

        .combo-field select.form-select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: none;
        }

        .combo-field .combo-toggle {
            z-index: 3;
        }

        .combo-field .manual-input-wrapper {
            position: absolute;
            top: 0;
            left: 0;
            right: 3rem;
            bottom: 0;
            display: flex;
            align-items: stretch;
            z-index: 2;
        }

        .combo-field .manual-input-wrapper.d-none {
            display: none !important;
        }

        .combo-field .manual-input-wrapper .form-control {
            width: 100%;
            height: 100%;
            padding-right: 1rem;
        }

        .image-preview-container {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .image-preview-container img {
            max-width: 180px;
            max-height: 180px;
        }
    </style>
<head>
    <meta charset="UTF-8">
    <title>제품 상세</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container mt-5">
    <c:choose>
        <c:when test="${empty product}">
            <h2 class="mb-4">등록</h2>
            <div class="btn-group mb-3">
                <button type="button" class="btn btn-outline-primary active" id="productTabBtn">제품</button>
                <button type="button" class="btn btn-outline-primary" id="codeTabBtn">제품코드</button>
            </div>

    <div id="codeForm" style="display:none;">
                <form id="codeRegisterForm" autocomplete="off" onsubmit="return false;">
                    <div class="row g-3 align-items-end mb-3">
                        <div class="col-md">
                            <label class="form-label" for="codeCompanyName">회사 이름</label>
                            <div class="combo-field">
                                <select id="codeCompanyName" class="form-select pe-5" data-placeholder="선택하세요"
                                        data-selected-code="${param.companyCode}">
                                    <option value="">선택하세요</option>
                                    <option value="__manual__">직접입력</option>
                                    <c:forEach var="company" items="${companies}">
                                        <option value="${company.companyCode}">${company.companyName}</option>
                                    </c:forEach>
                                </select>
                                <button type="button"
                                        class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 d-none"
                                        aria-label="목록 열기">
                                    <span aria-hidden="true">▾</span>
                                    <span class="visually-hidden">목록 열기</span>
                                </button>
                                <div class="manual-input-wrapper d-none" id="codeCompanyManualWrapper">
                                    <input type="text" id="codeCompanyNameInput" class="manual-input form-control"
                                           placeholder="회사 이름을 입력하세요" autocomplete="off" disabled>
                                </div>
                            </div>
                        </div>
                        <div class="col-md">
                            <label class="form-label" for="codeCompany">회사 코드</label>
                            <input type="text" id="codeCompany" class="form-control" placeholder="회사 코드를 입력하세요" disabled>
                        </div>
                        <div class="col-auto">
                            <button type="button" class="btn btn-secondary" id="companyPartialBtn" disabled>부분등록</button>
                        </div>
                    </div>

                    <div class="row g-3 align-items-end mb-3">
                        <div class="col-md">
                            <label class="form-label" for="codeTypeName">타입 이름</label>
                            <div class="combo-field">
                                <select id="codeTypeName" class="form-select pe-5" data-placeholder="선택하세요"
                                        data-selected-code="${param.typeCode}" disabled>
                                    <option value="">선택하세요</option>
                                    <option value="__manual__">직접입력</option>
                                </select>
                                <button type="button"
                                        class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 d-none"
                                        aria-label="목록 열기">
                                    <span aria-hidden="true">▾</span>
                                    <span class="visually-hidden">목록 열기</span>
                                </button>
                                <div class="manual-input-wrapper d-none" id="codeTypeManualWrapper">
                                    <input type="text" id="codeTypeNameInput" class="manual-input form-control"
                                           placeholder="타입 이름을 입력하세요" autocomplete="off" disabled>
                                </div>
                            </div>
                        </div>
                        <div class="col-md">
                            <label class="form-label" for="codeType">타입 코드</label>
                            <input type="text" id="codeType" class="form-control" placeholder="타입 코드를 입력하세요" disabled>
                        </div>
                        <div class="col-auto">
                            <button type="button" class="btn btn-secondary" id="typePartialBtn" disabled>부분등록</button>
                        </div>
                    </div>

                    <div class="row g-3 align-items-end mb-3">
                        <div class="col-md">
                            <label class="form-label" for="codeCategoryName">카테고리 이름</label>
                            <div class="combo-field">
                                <select id="codeCategoryName" class="form-select pe-5" data-placeholder="선택하세요"
                                        data-selected-code="${param.categoryCode}" disabled>
                                    <option value="">선택하세요</option>
                                    <option value="__manual__">직접입력</option>
                                </select>
                                <button type="button"
                                        class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 d-none"
                                        aria-label="목록 열기">
                                    <span aria-hidden="true">▾</span>
                                    <span class="visually-hidden">목록 열기</span>
                                </button>
                                <div class="manual-input-wrapper d-none" id="codeCategoryManualWrapper">
                                    <input type="text" id="codeCategoryNameInput" class="manual-input form-control"
                                           placeholder="카테고리 이름을 입력하세요" autocomplete="off" disabled>
                                </div>
                            </div>
                        </div>
                        <div class="col-md">
                            <label class="form-label" for="codeCategory">카테고리 코드</label>
                            <input type="text" id="codeCategory" class="form-control" placeholder="카테고리 코드를 입력하세요" disabled>
                        </div>
                        <div class="col-auto">
                            <button type="button" class="btn btn-secondary" id="categoryPartialBtn" disabled>부분등록</button>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="button" class="btn btn-primary" id="fullRegisterBtn" disabled>전체등록</button>
                    </div>
                </form>
            </div>

            <div id="productForm">
                <form action="${pageContext.request.contextPath}/product/register" method="post" class="mt-3" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label" for="productCompanyCode">회사</label>
                        <select name="companyCode" id="productCompanyCode" class="form-select" required
                                data-selected-company="${param.companyCode}" data-placeholder="선택하세요">
                            <option value="">선택하세요</option>
                            <c:forEach var="company" items="${companies}">
                                <option value="${company.companyCode}">${company.companyName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="productTypeCode">유형</label>
                        <select name="typeCode" id="productTypeCode" class="form-select" disabled required
                                data-selected-type="${param.typeCode}" data-placeholder="선택하세요">
                            <option value="">선택하세요</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="productCategoryCode">카테고리</label>
                        <select name="categoryCode" id="productCategoryCode" class="form-select" disabled required
                                data-selected-category="${param.categoryCode}" data-placeholder="선택하세요">
                            <option value="">선택하세요</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="itemCode">아이템 코드</label>
                        <input type="text" name="itemCode" id="itemCode" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="spec">규격</label>
                        <input type="text" name="spec" id="spec" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="pdName">상품명</label>
                        <input type="text" name="pdName" id="pdName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="imageFile">제품 이미지</label>
                        <input type="file" name="imageFile" id="imageFile" class="form-control" accept="image/*">
                        <div class="image-preview-container mt-2">
                            <img src="" alt="선택한 이미지 미리보기" id="imagePreview" class="img-thumbnail d-none">
                            <div>
                                <div id="imagePreviewPlaceholder" class="text-muted small">선택된 이미지가 없습니다.</div>
                                <div id="imageFileName" class="small"></div>
                            </div>
                        </div>
                        <div class="form-text">이미지를 선택하면 WebP 형식으로 변환되어 상품명 폴더에 저장됩니다.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="piecesPerBox">박스당 수량</label>
                        <input type="number" name="piecesPerBox" id="piecesPerBox" class="form-control" min="1" value="1" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="registerShQty">SH 창고 재고</label>
                        <input type="number" name="shQty" id="registerShQty" class="form-control" min="0" value="0" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="registerHpQty">HP 창고 재고</label>
                        <input type="number" name="hpQty" id="registerHpQty" class="form-control" min="0" value="0" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="registerTotalQty">총재고</label>
                        <input type="number" id="registerTotalQty" class="form-control" min="0" value="0" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="price">단가</label>
                        <input type="number" name="price" id="price" class="form-control" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="minStockQuantity">최소재고</label>
                        <input type="number" name="minStockQuantity" id="minStockQuantity" class="form-control" min="0" value="0" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">사용여부</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="active" id="productActiveTrue" value="true" checked>
                            <label class="form-check-label" for="productActiveTrue">사용</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="active" id="productActiveFalse" value="false">
                            <label class="form-check-label" for="productActiveFalse">미사용</label>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary me-2">등록</button>
                    <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary">취소</a>
                </form>
            </div>

            <c:if test="${not empty codeHierarchyJson}">
                <script type="application/json" id="codeHierarchyData"><c:out value='${codeHierarchyJson}' escapeXml="false" /></script>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="mb-0">제품 상세 정보</h2>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/product/register" class="btn btn-outline-primary">등록</a>
                    <button type="button" class="btn btn-outline-warning" onclick="toggleDetailEdit()">수정</button>
                    <button type="button" class="btn btn-outline-danger" onclick="showPendingAlert('삭제');">삭제</button>
                </div>
            </div>
            <c:set var="piecesPerBoxSafe" value="${product.piecesPerBox != null and product.piecesPerBox > 0 ? product.piecesPerBox : 1}" />
            <c:set var="warehouseStock" value="${product.stock}" />
            <c:set var="shQty" value="${empty warehouseStock ? 0 : warehouseStock.shQty}" />
            <c:set var="hpQty" value="${empty warehouseStock ? 0 : warehouseStock.hpQty}" />
            <c:set var="totalQty" value="${empty warehouseStock ? 0 : warehouseStock.totalQty}" />
            <c:set var="shRemainder" value="${shQty mod piecesPerBoxSafe}" />
            <c:set var="hpRemainder" value="${hpQty mod piecesPerBoxSafe}" />
            <c:set var="totalRemainder" value="${totalQty mod piecesPerBoxSafe}" />
            <c:set var="shBoxCount" value="${(shQty - shRemainder) / piecesPerBoxSafe}" />
            <c:set var="hpBoxCount" value="${(hpQty - hpRemainder) / piecesPerBoxSafe}" />
            <c:set var="totalBoxCount" value="${(totalQty - totalRemainder) / piecesPerBoxSafe}" />

            <fmt:formatNumber value="${piecesPerBoxSafe}" type="number" maxFractionDigits="0" var="piecesPerBoxDisplay" />
            <fmt:formatNumber value="${shQty}" type="number" maxFractionDigits="0" var="shQtyDisplay" />
            <fmt:formatNumber value="${hpQty}" type="number" maxFractionDigits="0" var="hpQtyDisplay" />
            <fmt:formatNumber value="${totalQty}" type="number" maxFractionDigits="0" var="totalQtyDisplay" />
            <fmt:formatNumber value="${shBoxCount}" type="number" maxFractionDigits="0" var="shBoxDisplay" />
            <fmt:formatNumber value="${hpBoxCount}" type="number" maxFractionDigits="0" var="hpBoxDisplay" />
            <fmt:formatNumber value="${totalBoxCount}" type="number" maxFractionDigits="0" var="totalBoxDisplay" />
            <fmt:formatNumber value="${shRemainder}" type="number" maxFractionDigits="0" var="shRemainderDisplay" />
            <fmt:formatNumber value="${hpRemainder}" type="number" maxFractionDigits="0" var="hpRemainderDisplay" />
            <fmt:formatNumber value="${totalRemainder}" type="number" maxFractionDigits="0" var="totalRemainderDisplay" />

            <form action="${pageContext.request.contextPath}/product/update" method="post" id="detailForm" data-pieces-per-box="${piecesPerBoxSafe}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle text-center">
                        <thead class="table-light">
                        <tr>
                            <th class="edit-col" style="display:none; width: 60px;">수정</th>
                            <th>등록자</th>
                            <th>상품코드</th>
                            <th>제품코드</th>
                            <th>규격</th>
                            <th>제품이름</th>
                            <th>박스당 수량</th>
                            <th>BOX</th>
                            <th>낱개</th>
                            <th>SH 창고</th>
                            <th>HP 창고</th>
                            <th>총재고</th>
                            <th>최소재고</th>
                            <th>사용상태</th>
                            <th>단가</th>
                            <th>생성일자</th>
                            <th>업데이트 일자</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="edit-col" style="display:none;">
                                <div class="form-check">
                                    <input class="form-check-input edit-toggle" type="checkbox" onchange="toggleDetailRow(this)">
                                </div>
                            </td>
                            <td>
                                <span class="value">
                                    <c:choose>
                                        <c:when test="${not empty product.user}"><c:out value="${product.user.name}" /></c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td><span class="value"><c:out value="${product.fullProductCode}" /></span></td>
                            <td><span class="value"><c:out value="${product.itemCode}" /></span></td>
                            <td>
                                <span class="value"><c:out value="${product.spec}" /></span>
                                <input type="text" name="spec" value="<c:out value='${product.spec}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value"><c:out value="${product.pdName}" /></span>
                                <input type="text" name="pdName" value="<c:out value='${product.pdName}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value">${piecesPerBoxDisplay}</span>
                                <input type="number" name="piecesPerBox" min="1" value="<c:out value='${product.piecesPerBox}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value" data-total-box-display="true">${totalBoxDisplay}</span>
                            </td>
                            <td>
                                <span class="value" data-total-piece-display="true">${totalRemainderDisplay}</span>
                            </td>
                            <td>
                                <span class="value warehouse-tooltip" data-warehouse-display="sh" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-html="true"
                                      title="박스: ${shBoxDisplay} 박스&lt;br&gt;낱개: ${shRemainderDisplay} 개">${shQtyDisplay}</span>
                                <input type="number" name="shQty" min="0" value="<c:out value='${empty product.stock ? 0 : product.stock.shQty}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value warehouse-tooltip" data-warehouse-display="hp" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-html="true"
                                      title="박스: ${hpBoxDisplay} 박스&lt;br&gt;낱개: ${hpRemainderDisplay} 개">${hpQtyDisplay}</span>
                                <input type="number" name="hpQty" min="0" value="<c:out value='${empty product.stock ? 0 : product.stock.hpQty}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value" data-total-display="true">${totalQtyDisplay}</span>
                                <input type="number" name="totalQty" min="0" value="<c:out value='${empty product.stock ? 0 : product.stock.totalQty}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled readonly>
                            </td>
                            <td>
                                <span class="value"><c:out value="${product.minStockQuantity}" /></span>
                                <input type="number" name="minStockQuantity" min="0" value="<c:out value='${product.minStockQuantity}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value">
                                    <c:choose>
                                        <c:when test="${product.active}">사용</c:when>
                                        <c:otherwise>미사용</c:otherwise>
                                    </c:choose>
                                </span>
                                <select name="active" class="form-select form-select-sm edit-field" style="display:none;" disabled>
                                    <option value="true" <c:if test="${product.active}">selected</c:if>>사용</option>
                                    <option value="false" <c:if test="${not product.active}">selected</c:if>>미사용</option>
                                </select>
                            </td>
                            <td>
                                <span class="value">
                                    <fmt:formatNumber value="${product.price}" type="number" minFractionDigits="0" maxFractionDigits="2" />
                                </span>
                                <input type="number" name="price" step="0.01" min="0" value="<c:out value='${product.price}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td><span class="value"><c:out value="${product.formattedCreatedAt}" /></span></td>
                            <td><span class="value"><c:out value="${product.formattedUpdatedAt}" /></span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <input type="hidden" name="originalCode" value="${product.productCode}">
                <input type="hidden" name="originalItemCode" value="${product.itemCode}">
                <input type="text" name="reason" id="detailReason" class="form-control mt-3 save-control" placeholder="수정 사유를 입력하세요" style="display:none;" disabled required>
                <button type="submit" class="btn btn-success mt-2 save-control" style="display:none;" disabled>저장</button>
            </form>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const CONTEXT_PATH = '<c:out value="${pageContext.request.contextPath}" />';

    document.addEventListener('DOMContentLoaded', () => {
        const appState = {
            contextPath: CONTEXT_PATH,
            codeHierarchy: parseCodeHierarchy()
        };

        setupTabToggle();
        setupComboToggles();

        appState.codeFormState = setupCodeForm(appState.codeHierarchy);
        appState.productFormState = setupProductForm(appState.codeHierarchy);

        setupPartialRegistration(appState);
        setupImageUploadPreview();
        setupWarehouseTotalPreview();
        setupDetailWarehouseEditor();
        setupWarehouseTooltips();
    });

    function parseCodeHierarchy() {
        const element = document.getElementById('codeHierarchyData');
        if (!element) {
            return {};
        }

        try {
            const text = element.textContent ? element.textContent.trim() : '';
            return text ? JSON.parse(text) : {};
        } catch (error) {
            console.error('코드 계층 정보를 파싱하지 못했습니다.', error);
            return {};
        }
    }

    function setupTabToggle() {
        const productTabBtn = document.getElementById('productTabBtn');
        const codeTabBtn = document.getElementById('codeTabBtn');
        const productForm = document.getElementById('productForm');
        const codeForm = document.getElementById('codeForm');

        if (!productTabBtn || !codeTabBtn || !productForm || !codeForm) {
            return;
        }

        const activateTab = (tab) => {
            if (tab === 'product') {
                productTabBtn.classList.add('active');
                codeTabBtn.classList.remove('active');
                productForm.style.display = '';
                codeForm.style.display = 'none';
            } else {
                productTabBtn.classList.remove('active');
                codeTabBtn.classList.add('active');
                productForm.style.display = 'none';
                codeForm.style.display = '';
            }
        };

        productTabBtn.addEventListener('click', () => activateTab('product'));
        codeTabBtn.addEventListener('click', () => activateTab('code'));
    }

    function setupComboToggles() {
        const comboFields = document.querySelectorAll('.combo-field');
        comboFields.forEach((field) => {
            const select = field.querySelector('select');
            const toggleButton = field.querySelector('.combo-toggle');

            if (!select || !toggleButton) {
                return;
            }

            toggleButton.classList.remove('d-none');

            const syncDisabledState = () => {
                toggleButton.disabled = select.disabled;
            };

            syncDisabledState();

            if (typeof MutationObserver === 'function') {
                const observer = new MutationObserver(syncDisabledState);
                observer.observe(select, { attributes: true, attributeFilter: ['disabled'] });
            }

            toggleButton.addEventListener('click', () => {
                if (select.disabled) {
                    return;
                }

                if (typeof select.showPicker === 'function') {
                    select.showPicker();
                    return;
                }

                select.focus();
                ['mousedown', 'mouseup', 'click'].forEach((eventType) => {
                    const event = new MouseEvent(eventType, { bubbles: true });
                    select.dispatchEvent(event);
                });
            });
        });
    }

    function setupImageUploadPreview() {
        const fileInput = document.getElementById('imageFile');
        const previewImage = document.getElementById('imagePreview');
        const placeholder = document.getElementById('imagePreviewPlaceholder');
        const fileNameLabel = document.getElementById('imageFileName');

        if (!fileInput || !previewImage || !placeholder) {
            return;
        }

        const resetPreview = (message = '선택된 이미지가 없습니다.') => {
            previewImage.src = '';
            previewImage.classList.add('d-none');
            placeholder.textContent = message;
            if (fileNameLabel) {
                fileNameLabel.textContent = '';
            }
            fileInput.setCustomValidity('');
        };

        const showPreview = (file) => {
            if (!file || !file.type || !file.type.startsWith('image/')) {
                resetPreview(file ? '이미지 파일만 선택할 수 있습니다.' : undefined);
                if (file) {
                    fileInput.setCustomValidity('이미지 파일만 업로드 가능합니다.');
                }
                return;
            }

            fileInput.setCustomValidity('');
            const reader = new FileReader();
            reader.onload = (event) => {
                previewImage.src = event.target?.result || '';
                previewImage.classList.toggle('d-none', !event.target?.result);
                placeholder.textContent = '선택한 이미지 미리보기';
                if (fileNameLabel) {
                    fileNameLabel.textContent = file.name;
                }
            };
            reader.readAsDataURL(file);
        };

        fileInput.addEventListener('change', (event) => {
            const [file] = event.target.files || [];
            if (!file) {
                resetPreview();
                return;
            }
            showPreview(file);
        });

        resetPreview();
    }

    function setupCodeForm(codeHierarchy) {
        const state = {
            companySelect: document.getElementById('codeCompanyName'),
            companyManualWrapper: document.getElementById('codeCompanyManualWrapper'),
            companyManualInput: document.getElementById('codeCompanyNameInput'),
            companyCodeInput: document.getElementById('codeCompany'),
            companyPartialBtn: document.getElementById('companyPartialBtn'),
            typeSelect: document.getElementById('codeTypeName'),
            typeManualWrapper: document.getElementById('codeTypeManualWrapper'),
            typeManualInput: document.getElementById('codeTypeNameInput'),
            typeCodeInput: document.getElementById('codeType'),
            typePartialBtn: document.getElementById('typePartialBtn'),
            categorySelect: document.getElementById('codeCategoryName'),
            categoryManualWrapper: document.getElementById('codeCategoryManualWrapper'),
            categoryManualInput: document.getElementById('codeCategoryNameInput'),
            categoryCodeInput: document.getElementById('codeCategory'),
            categoryPartialBtn: document.getElementById('categoryPartialBtn'),
            fullRegisterBtn: document.getElementById('fullRegisterBtn')
        };

        if (!state.companySelect) {
            return null;
        }

        if (state.companyManualInput) {
            state.companyManualInput.addEventListener('input', () => {
                updateCompanyPartialState(state);
                updateFullRegisterState(state);
            });
        }

        if (state.companyCodeInput) {
            state.companyCodeInput.addEventListener('input', () => {
                updateCompanyPartialState(state);
                updateFullRegisterState(state);
            });
        }

        state.companySelect.addEventListener('change', () => handleCompanyChange(state, codeHierarchy));
        if (state.typeSelect) {
            state.typeSelect.addEventListener('change', () => handleTypeChange(state, codeHierarchy));
        }
        if (state.categorySelect) {
            state.categorySelect.addEventListener('change', () => handleCategoryChange(state));
        }

        if (state.typeManualInput) {
            state.typeManualInput.addEventListener('input', () => {
                updateTypePartialState(state);
                updateFullRegisterState(state);
            });
        }

        if (state.typeCodeInput) {
            state.typeCodeInput.addEventListener('input', () => {
                updateTypePartialState(state);
                updateFullRegisterState(state);
            });
        }

        if (state.categoryManualInput) {
            state.categoryManualInput.addEventListener('input', () => {
                updateCategoryPartialState(state);
                updateFullRegisterState(state);
            });
        }

        if (state.categoryCodeInput) {
            state.categoryCodeInput.addEventListener('input', () => {
                updateCategoryPartialState(state);
                updateFullRegisterState(state);
            });
        }

        const companySelected = state.companySelect.dataset.selectedCode;
        if (companySelected) {
            state.companySelect.value = companySelected;
        }
        handleCompanyChange(state, codeHierarchy);

        if (state.typeSelect) {
            const typeSelected = state.typeSelect.dataset.selectedCode;
            if (typeSelected) {
                state.typeSelect.value = typeSelected;
            }
            handleTypeChange(state, codeHierarchy, { useDataset: true });
        }

        if (state.categorySelect) {
            const categorySelected = state.categorySelect.dataset.selectedCode;
            if (categorySelected) {
                state.categorySelect.value = categorySelected;
            }
            handleCategoryChange(state, { useDataset: true });
        }

        updateCompanyPartialState(state);
        updateTypePartialState(state);
        updateCategoryPartialState(state);
        updateFullRegisterState(state);

        return state;
    }

    function handleCompanyChange(state, codeHierarchy) {
        const { companySelect, companyManualWrapper, companyCodeInput, companyPartialBtn, typeSelect } = state;
        if (!companySelect) {
            return;
        }

        const value = companySelect.value;
        const isManual = value === '__manual__';

        toggleManualInput(companyManualWrapper, isManual);

        if (!value) {
            setCodeInputState(companyCodeInput, { value: '', disabled: true });
            setButtonDisabled(companyPartialBtn, true);
            resetTypeControls(state);
            resetCategoryControls(state);
            updateCompanyPartialState(state);
            updateTypePartialState(state);
            updateCategoryPartialState(state);
            updateFullRegisterState(state);
            return;
        }

        if (isManual) {
            setCodeInputState(companyCodeInput, { value: '', disabled: false });
            setButtonDisabled(companyPartialBtn, false);
            resetTypeControls(state);
            if (typeSelect) {
                typeSelect.disabled = false;
            }
            resetCategoryControls(state);
            if (state.categorySelect) {
                state.categorySelect.disabled = false;
            }
            updateCompanyPartialState(state);
            updateTypePartialState(state);
            updateCategoryPartialState(state);
            updateFullRegisterState(state);
            return;
        }

        setCodeInputState(companyCodeInput, { value, disabled: true });
        setButtonDisabled(companyPartialBtn, true);

        resetTypeControls(state);
        populateTypeOptions(state, codeHierarchy, value);
        if (typeSelect) {
            typeSelect.disabled = false;
        }

        resetCategoryControls(state);

        updateCompanyPartialState(state);
        updateTypePartialState(state);
        updateCategoryPartialState(state);
        updateFullRegisterState(state);
    }

    function handleTypeChange(state, codeHierarchy, options = {}) {
        const { typeSelect, typeManualWrapper, typeCodeInput, typePartialBtn } = state;
        if (!typeSelect) {
            return;
        }

        const value = typeSelect.value;
        const isManual = value === '__manual__';

        toggleManualInput(typeManualWrapper, isManual);

        if (!value) {
            setCodeInputState(typeCodeInput, { value: '', disabled: true });
            setButtonDisabled(typePartialBtn, true);
            resetCategoryControls(state);
            updateTypePartialState(state);
            updateCategoryPartialState(state);
            updateFullRegisterState(state);
            return;
        }

        if (isManual) {
            setCodeInputState(typeCodeInput, { value: '', disabled: false });
            setButtonDisabled(typePartialBtn, false);
            resetCategoryControls(state);
            if (state.categorySelect) {
                state.categorySelect.disabled = false;
            }
            updateTypePartialState(state);
            updateCategoryPartialState(state);
            updateFullRegisterState(state);
            return;
        }

        setCodeInputState(typeCodeInput, { value, disabled: true });
        setButtonDisabled(typePartialBtn, true);

        resetCategoryControls(state);
        populateCategoryOptions(state, codeHierarchy, value);
        if (state.categorySelect) {
            state.categorySelect.disabled = false;
        }

        if (options.useDataset) {
            const selected = state.categorySelect && state.categorySelect.dataset.selectedCode;
            if (selected) {
                state.categorySelect.value = selected;
            }
        }

        handleCategoryChange(state, options);

        updateTypePartialState(state);
        updateFullRegisterState(state);
    }

    function handleCategoryChange(state, options = {}) {
        const { categorySelect, categoryManualWrapper, categoryCodeInput, categoryPartialBtn } = state;
        if (!categorySelect) {
            return;
        }

        let value = categorySelect.value;
        if (!value && options.useDataset) {
            const selected = categorySelect.dataset.selectedCode;
            if (selected) {
                categorySelect.value = selected;
                value = selected;
            }
        }

        const isManual = value === '__manual__';
        toggleManualInput(categoryManualWrapper, isManual);

        if (!value) {
            setCodeInputState(categoryCodeInput, { value: '', disabled: true });
            setButtonDisabled(categoryPartialBtn, true);
            updateCategoryPartialState(state);
            updateFullRegisterState(state);
            return;
        }

        if (isManual) {
            setCodeInputState(categoryCodeInput, { value: '', disabled: false });
            setButtonDisabled(categoryPartialBtn, false);
            updateCategoryPartialState(state);
            updateFullRegisterState(state);
            return;
        }

        setCodeInputState(categoryCodeInput, { value, disabled: true });
        setButtonDisabled(categoryPartialBtn, true);

        updateCategoryPartialState(state);
        updateFullRegisterState(state);
    }

    function setupProductForm(codeHierarchy) {
        const state = {
            companySelect: document.getElementById('productCompanyCode'),
            typeSelect: document.getElementById('productTypeCode'),
            categorySelect: document.getElementById('productCategoryCode')
        };

        if (!state.companySelect || !state.typeSelect || !state.categorySelect) {
            return null;
        }

        state.companySelect.addEventListener('change', () => handleProductCompanyChange(state, codeHierarchy));
        state.typeSelect.addEventListener('change', () => handleProductTypeChange(state, codeHierarchy));

        const selectedCompany = state.companySelect.dataset.selectedCompany;
        if (selectedCompany) {
            state.companySelect.value = selectedCompany;
        }
        handleProductCompanyChange(state, codeHierarchy, { useDataset: true });

        return state;
    }

    function handleProductCompanyChange(state, codeHierarchy, options = {}) {
        const { companySelect } = state;
        if (!companySelect) {
            return;
        }

        const companyCode = companySelect.value;
        resetProductTypeSelect(state);
        resetProductCategorySelect(state);

        if (!companyCode) {
            return;
        }

        const companyData = codeHierarchy[companyCode];
        if (companyData && Array.isArray(companyData.types)) {
            companyData.types.forEach((type) => {
                if (!type || !type.code) {
                    return;
                }
                const option = document.createElement('option');
                option.value = type.code;
                option.textContent = type.name || type.code;
                state.typeSelect.appendChild(option);
            });
        }

        state.typeSelect.disabled = state.typeSelect.options.length <= 1;

        if (options.useDataset) {
            const selectedType = state.typeSelect.dataset.selectedType || state.typeSelect.dataset.selectedCode;
            if (selectedType) {
                state.typeSelect.value = selectedType;
            }
        }

        handleProductTypeChange(state, codeHierarchy, options);
    }

    function handleProductTypeChange(state, codeHierarchy, options = {}) {
        const { companySelect, typeSelect } = state;
        if (!companySelect || !typeSelect) {
            return;
        }

        const companyCode = companySelect.value;
        const typeCode = typeSelect.value;

        resetProductCategorySelect(state);

        if (!companyCode || !typeCode) {
            return;
        }

        const companyData = codeHierarchy[companyCode];
        const categories = companyData && companyData.categories ? companyData.categories[typeCode] : null;
        if (Array.isArray(categories)) {
            categories.forEach((category) => {
                if (!category || !category.code) {
                    return;
                }
                const option = document.createElement('option');
                option.value = category.code;
                option.textContent = category.name || category.code;
                state.categorySelect.appendChild(option);
            });
        }

        state.categorySelect.disabled = state.categorySelect.options.length <= 1;

        if (options.useDataset) {
            const selectedCategory = state.categorySelect.dataset.selectedCategory || state.categorySelect.dataset.selectedCode;
            if (selectedCategory) {
                state.categorySelect.value = selectedCategory;
            }
        }
    }

    function resetTypeControls(state) {
        if (!state.typeSelect) {
            return;
        }
        resetSelectWithManual(state.typeSelect);
        toggleManualInput(state.typeManualWrapper, false);
        setCodeInputState(state.typeCodeInput, { value: '', disabled: true });
        setButtonDisabled(state.typePartialBtn, true);
    }

    function resetCategoryControls(state) {
        if (!state.categorySelect) {
            return;
        }
        resetSelectWithManual(state.categorySelect);
        toggleManualInput(state.categoryManualWrapper, false);
        setCodeInputState(state.categoryCodeInput, { value: '', disabled: true });
        setButtonDisabled(state.categoryPartialBtn, true);
    }

    function populateTypeOptions(state, codeHierarchy, companyCode) {
        const { typeSelect } = state;
        if (!typeSelect) {
            return;
        }

        const companyData = codeHierarchy[companyCode];
        if (!companyData || !Array.isArray(companyData.types)) {
            return;
        }

        companyData.types.forEach((type) => {
            if (!type || !type.code) {
                return;
            }
            const option = document.createElement('option');
            option.value = type.code;
            option.textContent = type.name || type.code;
            typeSelect.appendChild(option);
        });
    }

    function populateCategoryOptions(state, codeHierarchy, typeCode) {
        const { companySelect, categorySelect } = state;
        if (!companySelect || !categorySelect) {
            return;
        }

        const companyCode = companySelect.value;
        if (!companyCode) {
            return;
        }

        const companyData = codeHierarchy[companyCode];
        const categories = companyData && companyData.categories ? companyData.categories[typeCode] : null;
        if (!Array.isArray(categories)) {
            return;
        }

        categories.forEach((category) => {
            if (!category || !category.code) {
                return;
            }
            const option = document.createElement('option');
            option.value = category.code;
            option.textContent = category.name || category.code;
            categorySelect.appendChild(option);
        });
    }

    function resetSelectWithManual(select) {
        if (!select) {
            return;
        }
        const placeholder = select.dataset.placeholder || '선택하세요';
        const manualLabel = select.dataset.manualLabel || '직접입력';
        select.innerHTML = '';
        select.appendChild(new Option(placeholder, ''));
        select.appendChild(new Option(manualLabel, '__manual__'));
        select.disabled = true;
    }

    function resetProductTypeSelect(state) {
        const { typeSelect } = state;
        if (!typeSelect) {
            return;
        }
        const placeholder = typeSelect.dataset.placeholder || '선택하세요';
        typeSelect.innerHTML = '';
        typeSelect.appendChild(new Option(placeholder, ''));
        typeSelect.disabled = true;
    }

    function resetProductCategorySelect(state) {
        const { categorySelect } = state;
        if (!categorySelect) {
            return;
        }
        const placeholder = categorySelect.dataset.placeholder || '선택하세요';
        categorySelect.innerHTML = '';
        categorySelect.appendChild(new Option(placeholder, ''));
        categorySelect.disabled = true;
    }

    function updateCompanyPartialState(state) {
        if (!state || !state.companyPartialBtn) {
            return;
        }

        if (!isManualSelection(state.companySelect)) {
            setButtonDisabled(state.companyPartialBtn, true);
            return;
        }

        const hasName = !!getTrimmedValue(state.companyManualInput);
        const hasCode = !!getTrimmedValue(state.companyCodeInput);
        setButtonDisabled(state.companyPartialBtn, !(hasName && hasCode));
    }

    function updateTypePartialState(state) {
        if (!state || !state.typePartialBtn) {
            return;
        }

        const companyValue = state.companySelect ? state.companySelect.value : '';
        const companyReady = !!companyValue && companyValue !== '__manual__';
        const isManual = isManualSelection(state.typeSelect);

        if (!companyReady || !isManual) {
            setButtonDisabled(state.typePartialBtn, true);
            return;
        }

        const hasName = !!getTrimmedValue(state.typeManualInput);
        const hasCode = !!getTrimmedValue(state.typeCodeInput);
        setButtonDisabled(state.typePartialBtn, !(hasName && hasCode));
    }

    function updateCategoryPartialState(state) {
        if (!state || !state.categoryPartialBtn) {
            return;
        }

        const companyValue = state.companySelect ? state.companySelect.value : '';
        const typeValue = state.typeSelect ? state.typeSelect.value : '';
        const companyReady = !!companyValue && companyValue !== '__manual__';
        const typeReady = !!typeValue && typeValue !== '__manual__';
        const isManual = isManualSelection(state.categorySelect);

        if (!companyReady || !typeReady || !isManual) {
            setButtonDisabled(state.categoryPartialBtn, true);
            return;
        }

        const hasName = !!getTrimmedValue(state.categoryManualInput);
        const hasCode = !!getTrimmedValue(state.categoryCodeInput);
        setButtonDisabled(state.categoryPartialBtn, !(hasName && hasCode));
    }

    function updateFullRegisterState(state) {
        if (!state || !state.fullRegisterBtn) {
            return;
        }

        const companyReady = isSelectionReady(state.companySelect, state.companyManualInput, state.companyCodeInput);
        const typeReady = companyReady && isSelectionReady(state.typeSelect, state.typeManualInput, state.typeCodeInput);
        const categoryReady = companyReady && typeReady && isSelectionReady(state.categorySelect, state.categoryManualInput, state.categoryCodeInput);

        setButtonDisabled(state.fullRegisterBtn, !(companyReady && typeReady && categoryReady));
    }

    function isSelectionReady(select, manualInput, codeInput) {
        if (!select || select.disabled) {
            return false;
        }
        const value = select.value;
        if (!value) {
            return false;
        }
        if (value === '__manual__') {
            return !!getTrimmedValue(manualInput) && !!getTrimmedValue(codeInput);
        }
        return true;
    }

    function isManualSelection(select) {
        return !!(select && !select.disabled && select.value === '__manual__');
    }

    function getTrimmedValue(input) {
        if (!input) {
            return '';
        }
        return (input.value || '').trim();
    }

    function ensureOption(select, value, label, options = {}) {
        if (!select) {
            return null;
        }
        const stringValue = value != null ? String(value) : '';
        let option = Array.from(select.options).find((opt) => opt.value === stringValue);
        if (option) {
            if (typeof label === 'string') {
                option.textContent = label;
            }
            return option;
        }

        option = new Option(label != null ? label : stringValue, stringValue);

        if (Number.isInteger(options.insertAt)) {
            const index = options.insertAt;
            if (index >= 0 && index < select.options.length) {
                select.add(option, index);
                return option;
            }
        }

        select.add(option);
        return option;
    }

    function setupPartialRegistration(appState) {
        if (!appState || !appState.codeFormState) {
            return;
        }

        const state = appState.codeFormState;

        if (state.companyPartialBtn) {
            state.companyPartialBtn.addEventListener('click', () => submitPartialRegistration('company', appState));
        }
        if (state.typePartialBtn) {
            state.typePartialBtn.addEventListener('click', () => submitPartialRegistration('type', appState));
        }
        if (state.categoryPartialBtn) {
            state.categoryPartialBtn.addEventListener('click', () => submitPartialRegistration('category', appState));
        }
    }

    async function submitPartialRegistration(level, appState) {
        if (!appState || !appState.codeFormState) {
            return;
        }

        const state = appState.codeFormState;
        const buttonMap = {
            company: state.companyPartialBtn,
            type: state.typePartialBtn,
            category: state.categoryPartialBtn
        };
        const button = buttonMap[level];
        if (!button || button.disabled) {
            return;
        }

        const request = collectPartialInputs(level, state);
        if (!request) {
            return;
        }

        const originalLabel = button.textContent;
        button.textContent = '등록중...';
        button.disabled = true;

        const url = buildProductCodeApiUrl(appState.contextPath);

        try {
            const responseData = await postForm(url, request.params);
            applyPartialRegistrationResult(level, request, responseData, appState);

            const messages = {
                company: '회사 코드가 등록되었습니다.',
                type: '타입 코드가 등록되었습니다.',
                category: '카테고리 코드가 등록되었습니다.'
            };
            if (messages[level]) {
                alert(messages[level]);
            }
        } catch (error) {
            console.error('부분등록 처리 중 오류', error);
            const message = error && error.message ? error.message : '알 수 없는 오류가 발생했습니다.';
            alert(`부분등록에 실패했습니다.\n${message}`);
        } finally {
            button.textContent = originalLabel;
            button.disabled = false;

            if (level === 'company') {
                updateCompanyPartialState(state);
                updateTypePartialState(state);
                updateCategoryPartialState(state);
            } else if (level === 'type') {
                updateTypePartialState(state);
                updateCategoryPartialState(state);
            } else {
                updateCategoryPartialState(state);
            }
            updateFullRegisterState(state);
        }
    }

    function collectPartialInputs(level, state) {
        if (!state) {
            return null;
        }

        if (level === 'company') {
            if (!isManualSelection(state.companySelect)) {
                alert('회사 이름에서 직접입력을 선택한 뒤 부분등록을 진행하세요.');
                return null;
            }
            const name = getTrimmedValue(state.companyManualInput);
            const code = getTrimmedValue(state.companyCodeInput);
            if (!name || !code) {
                alert('회사 이름과 코드를 모두 입력하세요.');
                return null;
            }
            const params = new URLSearchParams();
            params.set('companyCode', code);
            params.set('typeCode', '0000');
            params.set('categoryCode', '0000');
            params.set('description', name);
            return {
                params,
                companyCode: code,
                typeCode: '0000',
                categoryCode: '0000',
                displayName: name
            };
        }

        if (level === 'type') {
            const companyCode = state.companySelect ? state.companySelect.value : '';
            if (!companyCode || companyCode === '__manual__') {
                alert('부분등록을 위해서는 먼저 회사 코드를 선택하거나 등록해야 합니다.');
                return null;
            }
            if (!isManualSelection(state.typeSelect)) {
                alert('타입 이름에서 직접입력을 선택한 뒤 부분등록을 진행하세요.');
                return null;
            }
            const name = getTrimmedValue(state.typeManualInput);
            const code = getTrimmedValue(state.typeCodeInput);
            if (!name || !code) {
                alert('타입 이름과 코드를 모두 입력하세요.');
                return null;
            }
            const params = new URLSearchParams();
            params.set('companyCode', companyCode);
            params.set('typeCode', code);
            params.set('categoryCode', '0000');
            params.set('description', name);
            return {
                params,
                companyCode,
                typeCode: code,
                categoryCode: '0000',
                displayName: name
            };
        }

        if (level === 'category') {
            const companyCode = state.companySelect ? state.companySelect.value : '';
            const typeCode = state.typeSelect ? state.typeSelect.value : '';
            if (!companyCode || companyCode === '__manual__') {
                alert('부분등록을 위해서는 먼저 회사 코드를 선택하거나 등록해야 합니다.');
                return null;
            }
            if (!typeCode || typeCode === '__manual__') {
                alert('부분등록을 위해서는 먼저 타입 코드를 선택하거나 등록해야 합니다.');
                return null;
            }
            if (!isManualSelection(state.categorySelect)) {
                alert('카테고리 이름에서 직접입력을 선택한 뒤 부분등록을 진행하세요.');
                return null;
            }
            const name = getTrimmedValue(state.categoryManualInput);
            const code = getTrimmedValue(state.categoryCodeInput);
            if (!name || !code) {
                alert('카테고리 이름과 코드를 모두 입력하세요.');
                return null;
            }
            const params = new URLSearchParams();
            params.set('companyCode', companyCode);
            params.set('typeCode', typeCode);
            params.set('categoryCode', code);
            params.set('description', name);
            return {
                params,
                companyCode,
                typeCode,
                categoryCode: code,
                displayName: name
            };
        }

        return null;
    }

    function buildProductCodeApiUrl(contextPath) {
        const base = (contextPath || '').replace(/\/$/, '');
        return `${base}/api/product-codes`;
    }

    async function postForm(url, params) {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
            },
            body: params.toString()
        });

        const text = await response.text();
        const data = parseJsonSafely(text);

        if (!response.ok) {
            const message = extractErrorMessage(data, text);
            throw new Error(message || '서버 오류가 발생했습니다.');
        }

        return data;
    }

    function parseJsonSafely(text) {
        if (!text) {
            return null;
        }
        try {
            return JSON.parse(text);
        } catch (error) {
            console.warn('응답 JSON 파싱 실패', error, text);
            return null;
        }
    }

    function extractErrorMessage(data, fallbackText) {
        if (data) {
            if (typeof data === 'string') {
                return data;
            }
            if (data.message) {
                return data.message;
            }
            if (data.error) {
                return data.error;
            }
        }
        if (fallbackText) {
            return fallbackText;
        }
        return '';
    }

    function applyPartialRegistrationResult(level, request, responseData, appState) {
        const state = appState.codeFormState;
        const codeHierarchy = appState.codeHierarchy || {};
        const productState = appState.productFormState;

        if (level === 'company') {
            const companyCode = responseData && responseData.companyCode ? responseData.companyCode : request.companyCode;
            const displayName = request.displayName || (responseData && responseData.description) || companyCode;

            const hierarchyEntry = codeHierarchy[companyCode] || { name: displayName, types: [], categories: {} };
            hierarchyEntry.name = displayName;
            hierarchyEntry.types = hierarchyEntry.types || [];
            hierarchyEntry.categories = hierarchyEntry.categories || {};
            codeHierarchy[companyCode] = hierarchyEntry;

            ensureOption(state.companySelect, companyCode, displayName);
            state.companySelect.value = companyCode;
            handleCompanyChange(state, codeHierarchy);

            if (productState && productState.companySelect) {
                ensureOption(productState.companySelect, companyCode, displayName);
            }
            return;
        }

        if (level === 'type') {
            const companyCode = request.companyCode;
            const typeCode = responseData && responseData.typeCode ? responseData.typeCode : request.typeCode;
            const displayName = request.displayName || (responseData && responseData.description) || typeCode;

            const hierarchyEntry = codeHierarchy[companyCode] || { name: companyCode, types: [], categories: {} };
            hierarchyEntry.types = hierarchyEntry.types || [];
            hierarchyEntry.categories = hierarchyEntry.categories || {};
            if (!hierarchyEntry.types.some((item) => item.code === typeCode)) {
                hierarchyEntry.types.push({ code: typeCode, name: displayName });
            }
            hierarchyEntry.categories[typeCode] = hierarchyEntry.categories[typeCode] || [];
            codeHierarchy[companyCode] = hierarchyEntry;

            ensureOption(state.typeSelect, typeCode, displayName);
            state.typeSelect.disabled = false;
            state.typeSelect.value = typeCode;
            handleTypeChange(state, codeHierarchy);

            if (productState && productState.companySelect && productState.companySelect.value === companyCode) {
                ensureOption(productState.typeSelect, typeCode, displayName);
                productState.typeSelect.disabled = false;
            }
            return;
        }

        if (level === 'category') {
            const companyCode = request.companyCode;
            const typeCode = request.typeCode;
            const categoryCode = responseData && responseData.categoryCode ? responseData.categoryCode : request.categoryCode;
            const displayName = request.displayName || (responseData && responseData.description) || categoryCode;

            const hierarchyEntry = codeHierarchy[companyCode] || { name: companyCode, types: [], categories: {} };
            hierarchyEntry.types = hierarchyEntry.types || [];
            hierarchyEntry.categories = hierarchyEntry.categories || {};
            const categoryList = hierarchyEntry.categories[typeCode] || [];
            if (!categoryList.some((item) => item.code === categoryCode)) {
                categoryList.push({ code: categoryCode, name: displayName });
            }
            hierarchyEntry.categories[typeCode] = categoryList;
            codeHierarchy[companyCode] = hierarchyEntry;

            ensureOption(state.categorySelect, categoryCode, displayName);
            state.categorySelect.disabled = false;
            state.categorySelect.value = categoryCode;
            handleCategoryChange(state);

            if (productState && productState.companySelect && productState.companySelect.value === companyCode
                && productState.typeSelect && productState.typeSelect.value === typeCode) {
                ensureOption(productState.categorySelect, categoryCode, displayName);
                productState.categorySelect.disabled = false;
            }
        }
    }
    function setupWarehouseTotalPreview() {
        const shInput = document.getElementById('registerShQty');
        const hpInput = document.getElementById('registerHpQty');
        const totalInput = document.getElementById('registerTotalQty');

        if (!shInput || !hpInput || !totalInput) {
            return;
        }

        const recalculate = () => {
            const sh = Number.parseInt(shInput.value, 10) || 0;
            const hp = Number.parseInt(hpInput.value, 10) || 0;
            totalInput.value = Math.max(sh + hp, 0);
        };

        ['input', 'change'].forEach((eventName) => {
            shInput.addEventListener(eventName, recalculate);
            hpInput.addEventListener(eventName, recalculate);
        });

        recalculate();
    }

    function setupWarehouseTooltips() {
        if (typeof bootstrap === 'undefined' || !bootstrap.Tooltip) {
            return;
        }

        const triggers = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        triggers.forEach((trigger) => {
            if (typeof bootstrap.Tooltip.getOrCreateInstance === 'function') {
                bootstrap.Tooltip.getOrCreateInstance(trigger);
            } else {
                const existing = bootstrap.Tooltip.getInstance(trigger);
                if (existing) {
                    existing.dispose();
                }
                new bootstrap.Tooltip(trigger);
            }
        });
    }

    function setupDetailWarehouseEditor() {
        const form = document.getElementById('detailForm');
        if (!form) {
            return;
        }

        const shInput = form.querySelector('input[name="shQty"]');
        const hpInput = form.querySelector('input[name="hpQty"]');
        const totalInput = form.querySelector('input[name="totalQty"]');
        const totalDisplay = form.querySelector('[data-total-display="true"]');
        const totalBoxDisplay = form.querySelector('[data-total-box-display="true"]');
        const totalPieceDisplay = form.querySelector('[data-total-piece-display="true"]');
        const warehouseDisplays = Array.from(form.querySelectorAll('[data-warehouse-display]'))
            .reduce((accumulator, element) => {
                const key = element.dataset.warehouseDisplay;
                if (key) {
                    accumulator[key] = element;
                }
                return accumulator;
            }, {});
        const safePiecesPerBox = Math.max(Number.parseInt(form.dataset.piecesPerBox, 10) || 1, 1);

        if (!shInput || !hpInput || !totalInput) {
            return;
        }

        const numberFormatter = typeof Intl !== 'undefined'
            ? new Intl.NumberFormat('ko-KR')
            : null;

        const formatNumber = (value) => (numberFormatter ? numberFormatter.format(value) : String(value));

        const updateTooltipContent = (element, tooltipHtml) => {
            if (!element) {
                return;
            }

            element.setAttribute('title', tooltipHtml);
            element.setAttribute('data-bs-original-title', tooltipHtml);

            if (typeof bootstrap === 'undefined' || !bootstrap.Tooltip) {
                return;
            }

            if (typeof bootstrap.Tooltip.getOrCreateInstance === 'function') {
                const instance = bootstrap.Tooltip.getOrCreateInstance(element);
                if (instance && typeof instance.setContent === 'function') {
                    instance.setContent({ '.tooltip-inner': tooltipHtml });
                }
            } else {
                const existing = bootstrap.Tooltip.getInstance(element);
                if (existing) {
                    existing.dispose();
                }
                new bootstrap.Tooltip(element);
            }
        };

        const updateWarehouseDisplay = (element, quantity) => {
            if (!element) {
                return;
            }

            const safeQuantity = Math.max(Number.parseInt(quantity, 10) || 0, 0);
            const boxCount = Math.floor(safeQuantity / safePiecesPerBox);
            const remainder = Math.max(safeQuantity - (boxCount * safePiecesPerBox), 0);

            element.textContent = formatNumber(safeQuantity);
            const tooltipHtml = '박스: ' + formatNumber(boxCount) + ' 박스<br>낱개: ' + formatNumber(remainder) + ' 개';
            updateTooltipContent(element, tooltipHtml);
        };

        const updateTotalBreakdown = (total) => {
            const safeTotal = Math.max(total, 0);
            const totalBoxCount = Math.floor(safeTotal / safePiecesPerBox);
            const totalRemainder = Math.max(safeTotal - (totalBoxCount * safePiecesPerBox), 0);

            if (totalBoxDisplay) {
                totalBoxDisplay.textContent = formatNumber(totalBoxCount);
            }

            if (totalPieceDisplay) {
                totalPieceDisplay.textContent = formatNumber(totalRemainder);
            }
        };

        const recalculate = () => {
            const sh = Number.parseInt(shInput.value, 10) || 0;
            const hp = Number.parseInt(hpInput.value, 10) || 0;
            const total = Math.max(sh + hp, 0);
            totalInput.value = total;
            if (totalDisplay) {
                totalDisplay.textContent = formatNumber(total);
            }

            updateWarehouseDisplay(warehouseDisplays.sh, sh);
            updateWarehouseDisplay(warehouseDisplays.hp, hp);
            updateTotalBreakdown(total);
        };

        ['input', 'change'].forEach((eventName) => {
            shInput.addEventListener(eventName, recalculate);
            hpInput.addEventListener(eventName, recalculate);
        });

        recalculate();
    }

    function toggleManualInput(wrapper, shouldShow) {
        if (!wrapper) {
            return;
        }

        const input = wrapper.querySelector('input, textarea');

        if (shouldShow) {
            wrapper.classList.remove('d-none');
            if (input) {
                input.disabled = false;
                input.focus();
            }
        } else {
            wrapper.classList.add('d-none');
            if (input) {
                input.disabled = true;
                input.value = '';
            }
        }
    }

    function setCodeInputState(input, { value, disabled }) {
        if (!input) {
            return;
        }
        if (typeof value !== 'undefined') {
            input.value = value;
        }
        if (typeof disabled !== 'undefined') {
            input.disabled = disabled;
        }
    }

    function setButtonDisabled(button, disabled) {
        if (!button) {
            return;
        }
        button.disabled = !!disabled;
    }
</script>

</body>
</html>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>거래처 관리</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .page-title {
            font-weight: 700;
        }

        .card {
            border: none;+
            border-radius: 1rem;
        }

        .table thead th {
            font-size: 0.95rem;
            letter-spacing: -0.01em;
            text-align: center;
        }

        .table tbody td {
            vertical-align: middle;
            text-align: center;
        }

        .table tbody td .badge {
            font-weight: 500;
        }

        .table-fixed {
            table-layout: fixed;
            width: 100%;
        }

        .compact-cell {
            max-width: 110px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .address-cell {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .address-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 0;
            background: none;
            border: none;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: inherit;
            text-decoration: none;
            cursor: pointer;
        }

        .address-button:hover,
        .address-button:focus {
            color: #0d6efd;
        }

        .phone-badge {
            display: inline-block;
            max-width: 100%;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .table tbody tr[data-role="client-form-row"] select,
        .table tbody tr[data-role="client-form-row"] input {
            min-width: 120px;
        }

        .table tbody tr[data-role="client-form-row"] input.is-invalid,
        .table tbody tr[data-role="client-form-row"] select.is-invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 .25rem rgba(220, 53, 69, .25);
        }

        .empty-copy {
            padding: 3rem 1rem;
            color: #6c757d;
        }

        .search-wrapper {
            max-width: 520px;
        }

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

        #clientPagination .pagination {
            gap: 0.25rem;
        }

        #clientPagination .page-link {
            padding: 0.25rem 0.55rem;
            font-size: 0.85rem;
            min-width: 2rem;
        }
    </style>
</head>
<body>
<main class="container py-5">
    <div class="card shadow-sm">
        <div class="card-header bg-white py-4">
            <div class="d-flex flex-column gap-3">
                <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-lg-between gap-3">
                    <h1 class="page-title h3 mb-0">거래처 관리</h1>
                </div>
                <div class="d-flex flex-column flex-md-row align-items-md-center gap-2">
                    <div class="search-wrapper flex-grow-1 w-100">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0">검색</span>
                            <input type="search" class="form-control border-start-0" id="clientSearch"
                                   placeholder="검색어를 입력하세요">
                            <button class="btn btn-outline-secondary" type="button" id="clearClientSearch">지우기</button>
                        </div>
                    </div>
                    <div class="d-flex gap-2 justify-content-end flex-shrink-0 ms-auto">
                        <button type="button" class="btn btn-outline-primary" id="addClientRowBtn">등록</button>
                        <button type="button" class="btn btn-outline-warning" id="editClientBtn">수정</button>
                        <button type="button" class="btn btn-outline-danger" id="deleteClientBtn">삭제</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 table-fixed" id="clientTable">
                    <colgroup>
                        <col style="width: 11%">
                        <col style="width: 11%">
                        <col style="width: 11%">
                        <col style="width: 35%">
                        <col style="width: 11%">
                        <col style="width: 10%">
                        <col style="width: 11%">
                    </colgroup>
                    <thead class="table-light text-center">
                    <tr>
                        <th scope="col" class="text-nowrap sortable">
                            <button type="button" class="sort-button" data-sort-button="true" data-column-index="0"
                                    data-default-sort="true">
                                <span class="sort-label">회사 이름</span>
                                <span class="sort-indicator" aria-hidden="true"></span>
                            </button>
                        </th>
                        <th scope="col" class="text-nowrap sortable">
                            <button type="button" class="sort-button" data-sort-button="true" data-column-index="1">
                                <span class="sort-label">지점명</span>
                                <span class="sort-indicator" aria-hidden="true"></span>
                            </button>
                        </th>
                        <th scope="col" class="text-nowrap sortable">
                            <button type="button" class="sort-button" data-sort-button="true" data-column-index="2">
                                <span class="sort-label">대리점명</span>
                                <span class="sort-indicator" aria-hidden="true"></span>
                            </button>
                        </th>
                        <th scope="col" class="text-nowrap">주소</th>
                        <th scope="col" class="text-nowrap">성함</th>
                        <th scope="col" class="text-nowrap">사무실번호</th>
                        <th scope="col" class="text-nowrap">핸드폰번호</th>
                    </tr>
                    </thead>
                    <tbody id="clientTableBody">
                    <c:choose>
                        <c:when test="${not empty clients}">
                            <c:forEach var="client" items="${clients}">
                                <tr data-role="client-data-row"
                                    data-client-id="${client.clientId}"
                                    data-company-code="${client.companyCode}">
                                    <td class="fw-semibold compact-cell text-truncate"><c:out value="${client.companyName}"/></td>
                                    <td class="compact-cell text-truncate"><c:out value="${client.branchName}"/></td>
                                    <td class="compact-cell text-truncate"><c:out value="${client.agencyName}"/></td>
                                    <td class="address-cell">
                                        <button type="button"
                                                class="address-button"
                                                data-full-address="${fn:escapeXml(client.address == null ? '' : client.address)}"
                                                data-company-name="${fn:escapeXml(client.companyName == null ? '' : client.companyName)}"
                                                title="<c:out value='${client.address}'/>">
                                            <span class="text-truncate w-100 d-inline-block">
                                                <c:out value="${client.address}"/>
                                            </span>
                                        </button>
                                    </td>
                                    <td class="compact-cell text-truncate"><c:out value="${client.managerName}"/></td>
                                    <td class="compact-cell">
                                        <c:choose>
                                            <c:when test="${not empty client.regionalPhone}">
                                                <span class="badge bg-primary-subtle text-primary-emphasis phone-badge">
                                                    <c:out value="${client.regionalPhone}"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="compact-cell">
                                        <c:choose>
                                            <c:when test="${not empty client.managerPhone}">
                                                <span class="badge bg-primary-subtle text-primary-emphasis phone-badge">
                                                    <c:out value="${client.managerPhone}"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr data-role="empty-state">
                                <td colspan="7" class="text-center empty-copy">
                                    등록된 거래처가 없습니다. <span class="text-primary fw-semibold">등록</span> 버튼을 눌러 추가하세요.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
            <nav id="clientPagination" class="px-3 py-3 border-top" aria-label="거래처 목록 페이지"></nav>
        </div>
    </div>
</main>

<div class="modal fade" id="addressModal" tabindex="-1" aria-labelledby="addressModalTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addressModalTitle">주소 상세</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body" id="addressModalBody">주소 정보가 없습니다.</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<template id="clientFormRowTemplate">
    <tr class="table-primary" data-role="client-form-row">
        <td>
            <select class="form-select form-select-sm" name="companyCode" aria-label="회사 선택" required>
                <option value="">회사 선택</option>
                <c:forEach var="company" items="${companies}">
                    <option value="${company.companyCode}">${company.companyName}</option>
                </c:forEach>
            </select>
        </td>
        <td>
            <input type="text" class="form-control form-control-sm" name="branchName"
                   placeholder="지점명" aria-label="지점명" required>
        </td>
        <td>
            <input type="text" class="form-control form-control-sm" name="agencyName"
                   placeholder="대리점명" aria-label="대리점명">
        </td>
        <td>
            <input type="text" class="form-control form-control-sm" name="address"
                   placeholder="주소" aria-label="주소" required>
        </td>
        <td>
            <input type="text" class="form-control form-control-sm" name="managerName"
                   placeholder="담당자 성함" aria-label="담당자 성함" required>
        </td>
        <td>
            <div class="d-flex flex-column flex-xl-row align-items-stretch align-items-xl-center gap-2">
                <div class="d-flex flex-column flex-lg-row align-items-stretch align-items-lg-center gap-2 flex-grow-1">
                    <div class="flex-grow-1">
                        <input type="tel" class="form-control form-control-sm" name="regionalPhone"
                               placeholder="사무실번호" aria-label="사무실번호">
                    </div>
                    <div class="flex-grow-1">
                        <input type="tel" class="form-control form-control-sm" name="managerPhone"
                               placeholder="연락처" aria-label="연락처" required>
                    </div>
                </div>
                <div class="d-flex gap-2 justify-content-end">
                    <button type="button" class="btn btn-success btn-sm" data-action="save-form">저장</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-action="cancel-form">취소</button>
                </div>
            </div>
        </td>
    </tr>
</template>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const tableBody = document.getElementById('clientTableBody');
        const addRowButton = document.getElementById('addClientRowBtn');
        const formTemplate = document.getElementById('clientFormRowTemplate');
        const searchInput = document.getElementById('clientSearch');
        const clearButton = document.getElementById('clearClientSearch');
        const sortButtons = Array.from(document.querySelectorAll('[data-sort-button="true"]'));
        const paginationContainer = document.getElementById('clientPagination');
        const addressModalElement = document.getElementById('addressModal');
        const addressModalTitle = document.getElementById('addressModalTitle');
        const addressModalBody = document.getElementById('addressModalBody');
        const addressModalInstance = (typeof bootstrap !== 'undefined' && addressModalElement)
            ? new bootstrap.Modal(addressModalElement)
            : null;

        const API_ENDPOINT = '/api/clients';
        const DATA_ROW_SELECTOR = 'tr[data-role="client-data-row"]';
        const FORM_ROW_SELECTOR = 'tr[data-role="client-form-row"]';
        const EMPTY_STATE_SELECTOR = 'tr[data-role="empty-state"]';
        const DEFAULT_EMPTY_HTML = '<td colspan="7" class="text-center empty-copy">등록된 거래처가 없습니다. <span class="text-primary fw-semibold">등록</span> 버튼을 눌러 추가하세요.</td>';
        const SEARCH_EMPTY_HTML = '<td colspan="7" class="text-center empty-copy">검색 결과가 없습니다.</td>';

        const state = {
            sortColumnIndex: 0,
            sortDirection: 'asc',
            currentPage: 1,
            searchKeyword: ''
        };
        const ROWS_PER_PAGE = 20;

        const focusFirstField = (row) => {
            const focusable = row.querySelector('select, input');
            if (focusable) {
                focusable.focus();
            }
        };

        const getCellText = (row, index) => {
            if (!row || typeof index !== 'number') {
                return '';
            }
            const cell = row.cells[index];
            return cell ? cell.textContent.trim() : '';
        };

        const updateSortIndicators = () => {
            sortButtons.forEach((button) => {
                const indicator = button.querySelector('.sort-indicator');
                const columnIndex = Number(button.dataset.columnIndex);
                if (!indicator || Number.isNaN(columnIndex)) {
                    return;
                }

                if (state.sortColumnIndex === columnIndex) {
                    indicator.textContent = state.sortDirection === 'asc' ? '▲' : '▼';
                    button.classList.add('text-primary');
                } else {
                    indicator.textContent = '↕';
                    button.classList.remove('text-primary');
                }
            });
        };

        const sortRows = (rows) => {
            if (!rows || rows.length === 0) {
                return [];
            }
            const mapped = rows.map((row, index) => ({row, index}));
            mapped.sort((a, b) => {
                const textA = getCellText(a.row, state.sortColumnIndex).toLowerCase();
                const textB = getCellText(b.row, state.sortColumnIndex).toLowerCase();
                const comparison = textA.localeCompare(textB, 'ko');
                if (comparison === 0) {
                    return a.index - b.index;
                }
                return state.sortDirection === 'asc' ? comparison : -comparison;
            });
            return mapped.map((item) => item.row);
        };

        const matchesKeyword = (row) => {
            const keyword = (state.searchKeyword || '').trim().toLowerCase();
            if (!keyword) {
                return true;
            }
            const cells = Array.from(row.cells);
            return cells.some((cell) => {
                const text = cell ? cell.textContent.toLowerCase() : '';
                return text.includes(keyword);
            });
        };

        const updateEmptyState = (filteredCount, dataCount) => {
            let emptyRow = tableBody.querySelector(EMPTY_STATE_SELECTOR);
            const hasFormRow = Boolean(tableBody.querySelector(FORM_ROW_SELECTOR));
            const hasKeyword = (state.searchKeyword || '').trim().length > 0;

            const shouldShowEmptyRow = filteredCount === 0 && (!hasFormRow || hasKeyword);

            if (shouldShowEmptyRow) {
                if (!emptyRow) {
                    emptyRow = document.createElement('tr');
                    emptyRow.dataset.role = 'empty-state';
                    tableBody.appendChild(emptyRow);
                }
                emptyRow.innerHTML = hasKeyword ? SEARCH_EMPTY_HTML : DEFAULT_EMPTY_HTML;
                emptyRow.style.display = '';
            } else if (emptyRow) {
                if (dataCount === 0 && !hasFormRow && !hasKeyword) {
                    emptyRow.innerHTML = DEFAULT_EMPTY_HTML;
                    emptyRow.style.display = '';
                } else if (hasKeyword && dataCount === 0 && !hasFormRow) {
                    emptyRow.innerHTML = SEARCH_EMPTY_HTML;
                    emptyRow.style.display = '';
                } else {
                    emptyRow.remove();
                }
            }
        };

        const renderPagination = (totalPages) => {
            if (!paginationContainer) {
                return;
            }

            const normalizedTotal = Math.max(1, totalPages);
            paginationContainer.classList.remove('d-none');
            paginationContainer.innerHTML = '';

            const paginationList = document.createElement('ul');
            paginationList.className = 'pagination pagination-sm justify-content-center flex-wrap';

            const addPageButton = (label, page, options = {}) => {
                const {disabled = false, active = false, ariaLabel} = options;
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

            const segmentIndex = Math.floor((state.currentPage - 1) / 10);
            const startPage = segmentIndex * 10 + 1;
            const endPage = Math.min(startPage + 9, normalizedTotal);

            addPageButton('<<', 1, {
                disabled: state.currentPage === 1,
                ariaLabel: '첫 페이지'
            });

            addPageButton('<', Math.max(1, state.currentPage - 1), {
                disabled: state.currentPage === 1,
                ariaLabel: '이전 페이지'
            });

            for (let page = startPage; page <= endPage; page++) {
                addPageButton(String(page), page, {active: page === state.currentPage});
            }

            addPageButton('>', Math.min(normalizedTotal, state.currentPage + 1), {
                disabled: state.currentPage === normalizedTotal,
                ariaLabel: '다음 페이지'
            });

            addPageButton('>>', normalizedTotal, {
                disabled: state.currentPage === normalizedTotal,
                ariaLabel: '마지막 페이지'
            });

            paginationContainer.appendChild(paginationList);
        };

        const applyAndRender = ({resetPage = false} = {}) => {
            if (!tableBody) {
                return;
            }

            const dataRows = Array.from(tableBody.querySelectorAll(DATA_ROW_SELECTOR));
            const sortedRows = sortRows(dataRows);
            const formRow = tableBody.querySelector(FORM_ROW_SELECTOR);

            const fragment = document.createDocumentFragment();
            sortedRows.forEach((row) => fragment.appendChild(row));

            if (formRow) {
                if (formRow.nextSibling) {
                    tableBody.insertBefore(fragment, formRow.nextSibling);
                } else {
                    tableBody.appendChild(fragment);
                }
            } else {
                tableBody.appendChild(fragment);
            }

            const filteredRows = sortedRows.filter(matchesKeyword);
            const totalPages = Math.max(1, Math.ceil(filteredRows.length / ROWS_PER_PAGE));

            if (resetPage) {
                state.currentPage = 1;
            }
            if (state.currentPage > totalPages) {
                state.currentPage = totalPages;
            }
            if (state.currentPage < 1) {
                state.currentPage = 1;
            }

            sortedRows.forEach((row) => {
                row.style.display = 'none';
            });

            const startIndex = (state.currentPage - 1) * ROWS_PER_PAGE;
            const endIndex = startIndex + ROWS_PER_PAGE;
            filteredRows.forEach((row, index) => {
                if (index >= startIndex && index < endIndex) {
                    row.style.display = '';
                }
            });

            updateEmptyState(filteredRows.length, dataRows.length);
            renderPagination(totalPages);
        };

        const resetValidationState = (row) => {
            row.querySelectorAll('.is-invalid').forEach((element) => {
                element.classList.remove('is-invalid');
            });
        };

        const validateRow = (row) => {
            const requiredFields = Array.from(row.querySelectorAll('select[required], input[required]'));
            let isValid = true;
            requiredFields.forEach((field) => {
                const value = field.value.trim();
                if (!value) {
                    field.classList.add('is-invalid');
                    isValid = false;
                }
            });
            return isValid;
        };

        const extractFormData = (row) => {
            const formData = {};
            row.querySelectorAll('select, input').forEach((field) => {
                formData[field.name] = field.value.trim();
            });
            return formData;
        };

        const buildTextCell = (text, className) => {
            const cell = document.createElement('td');
            if (className) {
                cell.className = className;
            }
            if (text) {
                cell.textContent = text;
                cell.title = text;
            }
            return cell;
        };

        const buildAddressCell = (client) => {
            const cell = document.createElement('td');
            cell.className = 'address-cell';

            const button = document.createElement('button');
            button.type = 'button';
            button.className = 'address-button';
            button.dataset.fullAddress = client.address || '';
            button.dataset.companyName = client.companyName || '';
            button.title = client.address || '';

            const span = document.createElement('span');
            span.className = 'text-truncate w-100 d-inline-block';
            span.textContent = client.address || '';

            button.appendChild(span);
            cell.appendChild(button);
            return cell;
        };

        const buildPhoneCell = (phone) => {
            const cell = document.createElement('td');
            cell.className = 'compact-cell';

            if (phone) {
                const badge = document.createElement('span');
                badge.className = 'badge bg-primary-subtle text-primary-emphasis phone-badge';
                badge.textContent = phone;
                badge.title = phone;
                cell.appendChild(badge);
            } else {
                const placeholder = document.createElement('span');
                placeholder.className = 'text-muted';
                placeholder.textContent = '-';
                cell.appendChild(placeholder);
            }

            return cell;
        };

        const createDataRow = (client) => {
            const row = document.createElement('tr');
            row.dataset.role = 'client-data-row';
            row.dataset.clientId = client.clientId;
            row.dataset.companyCode = client.companyCode;

            row.appendChild(buildTextCell(client.companyName, 'fw-semibold compact-cell text-truncate'));
            row.appendChild(buildTextCell(client.branchName || '', 'compact-cell text-truncate'));
            row.appendChild(buildTextCell(client.agencyName || '', 'compact-cell text-truncate'));
            row.appendChild(buildAddressCell(client));
            row.appendChild(buildTextCell(client.managerName || '', 'compact-cell text-truncate'));

            row.appendChild(buildPhoneCell(client.regionalPhone || ''));
            row.appendChild(buildPhoneCell(client.managerPhone || ''));

            return row;
        };

        const insertClientRow = (client) => {
            const newRow = createDataRow(client);
            tableBody.appendChild(newRow);
            applyAndRender();
            return newRow;
        };

        const setButtonState = (button, {disabled, text}) => {
            if (!button) {
                return;
            }
            if (!button.dataset.originalText) {
                button.dataset.originalText = button.textContent;
            }
            button.disabled = Boolean(disabled);
            button.textContent = text ?? button.dataset.originalText;
            if (!disabled) {
                button.textContent = button.dataset.originalText;
            }
        };

        const toNullable = (value) => {
            if (typeof value !== 'string') {
                return null;
            }
            const trimmed = value.trim();
            return trimmed.length === 0 ? null : trimmed;
        };

        const sanitizePhoneNumber = (value) => {
            if (typeof value !== 'string') {
                return '';
            }
            return value.replace(/[^0-9]/g, '');
        };

        const postClient = async (payload) => {
            const response = await fetch(API_ENDPOINT, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(payload)
            });

            const rawBody = await response.text();
            if (!response.ok) {
                let message = '거래처 등록에 실패했습니다. 다시 시도해주세요.';
                if (rawBody) {
                    try {
                        const errorBody = JSON.parse(rawBody);
                        if (errorBody && typeof errorBody.message === 'string') {
                            message = errorBody.message;
                        }
                    } catch (parseError) {
                        message = rawBody;
                    }
                }
                throw new Error(message);
            }

            return rawBody ? JSON.parse(rawBody) : null;
        };

        const handleSave = async (row, actionButton) => {
            resetValidationState(row);
            if (!validateRow(row)) {
                const invalidField = row.querySelector('.is-invalid');
                if (invalidField) {
                    invalidField.focus();
                }
                return;
            }

            const formData = extractFormData(row);
            const sanitizedRegionalPhone = sanitizePhoneNumber(formData.regionalPhone);
            const sanitizedManagerPhone = sanitizePhoneNumber(formData.managerPhone);

            if (!sanitizedManagerPhone) {
                const phoneField = row.querySelector('input[name="managerPhone"]');
                if (phoneField) {
                    phoneField.classList.add('is-invalid');
                    phoneField.focus();
                }
                alert('전화번호에는 숫자가 포함되어야 합니다.');
                return;
            }

            const payload = {
                companyCode: formData.companyCode,
                branchName: toNullable(formData.branchName),
                agencyName: toNullable(formData.agencyName),
                address: toNullable(formData.address),
                managerName: formData.managerName,
                regionalPhone: toNullable(sanitizedRegionalPhone),
                managerPhone: sanitizedManagerPhone
            };

            setButtonState(actionButton, {disabled: true, text: '저장 중...'});

            try {
                const client = await postClient(payload);
                insertClientRow(client);
                row.remove();
                applyAndRender();
                alert('거래처가 등록되었습니다.');
            } catch (error) {
                alert(error.message || '거래처 등록 중 오류가 발생했습니다.');
            } finally {
                setButtonState(actionButton, {disabled: false});
            }
        };

        if (addRowButton && formTemplate) {
            addRowButton.addEventListener('click', () => {
                const existingFormRow = tableBody.querySelector(FORM_ROW_SELECTOR);
                if (existingFormRow) {
                    focusFirstField(existingFormRow);
                    return;
                }

                const fragment = formTemplate.content.cloneNode(true);
                const formRow = fragment.querySelector('tr');
                if (!formRow) {
                    return;
                }

                formRow.querySelectorAll('input, select').forEach((field) => {
                    field.addEventListener('input', () => field.classList.remove('is-invalid'));
                    field.addEventListener('change', () => field.classList.remove('is-invalid'));
                });

                const firstDataRow = tableBody.querySelector(DATA_ROW_SELECTOR);
                if (firstDataRow) {
                    tableBody.insertBefore(formRow, firstDataRow);
                } else {
                    tableBody.prepend(formRow);
                }

                applyAndRender();
                focusFirstField(formRow);
            });
        }

        if (tableBody) {
            tableBody.addEventListener('click', async (event) => {
                const addressButton = event.target.closest('.address-button');
                if (addressButton) {
                    event.preventDefault();
                    const fullAddress = addressButton.dataset.fullAddress || '';
                    const companyName = addressButton.dataset.companyName || '';
                    if (addressModalBody) {
                        addressModalBody.textContent = fullAddress || '주소 정보가 없습니다.';
                    }
                    if (addressModalTitle) {
                        addressModalTitle.textContent = companyName ? `${companyName} 주소` : '주소 상세';
                    }
                    if (addressModalInstance) {
                        addressModalInstance.show();
                    } else if (fullAddress) {
                        alert(fullAddress);
                    }
                    return;
                }

                const actionButton = event.target.closest('[data-action]');
                if (!actionButton) {
                    return;
                }

                const formRow = actionButton.closest(FORM_ROW_SELECTOR);
                if (!formRow) {
                    return;
                }

                const action = actionButton.dataset.action;
                if (action === 'cancel-form') {
                    formRow.remove();
                    applyAndRender();
                } else if (action === 'save-form') {
                    await handleSave(formRow, actionButton);
                }
            });
        }
        if (searchInput) {
            state.searchKeyword = searchInput.value || '';
            searchInput.addEventListener('input', () => {
                state.searchKeyword = searchInput.value || '';
                applyAndRender({resetPage: true});
            });
        }

        if (clearButton && searchInput) {
            clearButton.addEventListener('click', () => {
                searchInput.value = '';
                state.searchKeyword = '';
                applyAndRender({resetPage: true});
                searchInput.focus();
            });
        }

        if (sortButtons.length > 0) {
            const defaultSortButton = sortButtons.find((button) => button.dataset.defaultSort === 'true');
            if (defaultSortButton) {
                const defaultColumnIndex = Number(defaultSortButton.dataset.columnIndex);
                if (!Number.isNaN(defaultColumnIndex)) {
                    state.sortColumnIndex = defaultColumnIndex;
                    state.sortDirection = 'asc';
                }
            }

            sortButtons.forEach((button) => {
                const columnIndex = Number(button.dataset.columnIndex);
                if (!Number.isNaN(columnIndex)) {
                    button.dataset.sortState = 'default';
                }

                button.addEventListener('click', () => {
                    const targetIndex = Number(button.dataset.columnIndex);
                    if (Number.isNaN(targetIndex)) {
                        return;
                    }

                    if (state.sortColumnIndex === targetIndex) {
                        state.sortDirection = state.sortDirection === 'asc' ? 'desc' : 'asc';
                    } else {
                        state.sortColumnIndex = targetIndex;
                        state.sortDirection = 'asc';
                    }

                    updateSortIndicators();
                    applyAndRender({resetPage: true});
                });
            });
        }

        updateSortIndicators();
        applyAndRender({resetPage: true});
    });
</script>
</body>
</html>
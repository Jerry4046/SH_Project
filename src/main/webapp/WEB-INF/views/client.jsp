<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %> <!-- ✅ 헤더 콘텐츠 -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>거래처 목록</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
    <style>
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

        @media (max-width: 576px) {
            .search-area .input-group {
                max-width: 100%;
            }
        }
    </style>
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-4 border-0">
                    <div class="d-flex flex-column flex-sm-row align-items-sm-start justify-content-between gap-3">
                        <div class="flex-grow-1 w-100">
                            <h1 class="h3 mb-1">거래처 목록</h1>
                            <div class="search-area mt-3">
                                <div class="input-group shadow-sm">
                                    <span class="input-group-text bg-white border-end-0">🔍</span>
                                    <input type="search" class="form-control border-start-0" id="clientSearch"
                                           placeholder="회사 이름, 지점명, 대리점명, 주소, 성함 또는 연락처로 검색하세요." aria-label="거래처 검색">
                                    <button class="btn btn-outline-secondary" type="button" id="clearClientSearch">지우기</button>
                                </div>
                            </div>
                        </div>
                        <a href="#" class="btn btn-primary align-self-start mt-2 mt-sm-0" role="button" aria-disabled="true">거래처 등록</a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="clientTable">
                            <thead class="table-light">
                            <tr>
                                <th scope="col" class="text-nowrap">
                                    <button type="button" class="sort-button" data-column="0" data-sort-state="asc" data-label="회사 이름">
                                        <span class="sort-label">회사 이름</span>
                                        <span class="sort-indicator" aria-hidden="true"></span>
                                    </button>
                                </th>
                                <th scope="col" class="text-nowrap">
                                    <button type="button" class="sort-button" data-column="1" data-label="지점명">
                                        <span class="sort-label">지점명</span>
                                        <span class="sort-indicator" aria-hidden="true"></span>
                                    </button>
                                </th>
                                <th scope="col" class="text-nowrap">
                                    <button type="button" class="sort-button" data-column="2" data-label="대리점명">
                                        <span class="sort-label">대리점명</span>
                                        <span class="sort-indicator" aria-hidden="true"></span>
                                    </button>
                                </th>
                                <th scope="col" class="text-nowrap">
                                    <button type="button" class="sort-button" data-column="3" data-label="주소">
                                        <span class="sort-label">주소</span>
                                        <span class="sort-indicator" aria-hidden="true"></span>
                                    </button>
                                </th>
                                <th scope="col" class="text-nowrap">
                                    <button type="button" class="sort-button" data-column="4" data-label="성함">
                                        <span class="sort-label">성함</span>
                                        <span class="sort-indicator" aria-hidden="true"></span>
                                    </button>
                                </th>
                                <th scope="col" class="text-nowrap">
                                    <button type="button" class="sort-button" data-column="5" data-label="연락처">
                                        <span class="sort-label">연락처</span>
                                        <span class="sort-indicator" aria-hidden="true"></span>
                                    </button>
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td class="fw-semibold">에이비씨 상사</td>
                                <td>서울 강남지점</td>
                                <td>강남 대리점</td>
                                <td>서울특별시 강남구 테헤란로 123</td>
                                <td>김철수</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">02-1234-5678</span></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">스타물산</td>
                                <td>부산 해운대지점</td>
                                <td>해운대 대리점</td>
                                <td>부산광역시 해운대구 센텀로 45</td>
                                <td>이영희</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">051-987-6543</span></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">굿모닝 유통</td>
                                <td>대구 중구지점</td>
                                <td>중구 직영 대리점</td>
                                <td>대구광역시 중구 동성로 89</td>
                                <td>박민수</td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">헤리티지 트레이딩</td>
                                <td>광주 첨단지점</td>
                                <td>첨단 파트너 대리점</td>
                                <td>광주광역시 북구 첨단과기로 77</td>
                                <td>최수정</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">062-444-5555</span></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">네오텍</td>
                                <td>대전 둔산지점</td>
                                <td>둔산 프리미엄 대리점</td>
                                <td>대전광역시 서구 둔산대로 102</td>
                                <td>정우성</td>
                                <td><span class="badge bg-primary-subtle text-primary-emphasis">042-666-7777</span></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const table = document.getElementById('clientTable');
        if (!table) {
            return;
        }

        const tbody = table.querySelector('tbody');
        let rows = Array.from(tbody.querySelectorAll('tr'));

        const getCellText = (row, columnIndex) => {
            const cell = row.cells[columnIndex];
            return cell ? cell.textContent.trim().toLowerCase() : '';
        };

        const defaultSortedRows = rows.slice().sort((rowA, rowB) => {
            const textA = getCellText(rowA, 0);
            const textB = getCellText(rowB, 0);
            return textA.localeCompare(textB, 'ko');
        });
        defaultSortedRows.forEach(row => tbody.appendChild(row));

        rows = Array.from(tbody.querySelectorAll('tr'));
        rows.forEach((row, index) => {
            row.dataset.originalOrder = index;
        });
        const originalOrder = rows.slice();

        const sortButtons = table.querySelectorAll('.sort-button');
        const searchInput = document.getElementById('clientSearch');
        const clearButton = document.getElementById('clearClientSearch');

        const updateAriaLabel = (button, state) => {
            const baseLabel = button.dataset.label || button.textContent.trim();
            let stateLabel = '정상';
            if (state === 'asc') {
                stateLabel = '오름차순';
            } else if (state === 'desc') {
                stateLabel = '내림차순';
            }
            button.setAttribute('aria-label', baseLabel + ' 정렬, ' + stateLabel);
        };

        const refreshIndicator = (button, state) => {
            const indicator = button.querySelector('.sort-indicator');
            if (indicator) {
                const symbol = state === 'asc' ? '▲' : state === 'desc' ? '▼' : '↕';
                indicator.textContent = symbol;
            }
            button.classList.toggle('text-primary', state === 'asc' || state === 'desc');
            updateAriaLabel(button, state);
        };

        const applySort = (columnIndex, state) => {
            if (state === 'default') {
                originalOrder.forEach(row => tbody.appendChild(row));
                return;
            }

            const sortedRows = rows.slice().sort((rowA, rowB) => {
                const textA = getCellText(rowA, columnIndex);
                const textB = getCellText(rowB, columnIndex);
                const comparison = textA.localeCompare(textB, 'ko');
                if (comparison === 0) {
                    return Number(rowA.dataset.originalOrder) - Number(rowB.dataset.originalOrder);
                }
                return state === 'asc' ? comparison : -comparison;
            });

            sortedRows.forEach(row => tbody.appendChild(row));
        };

        sortButtons.forEach(button => {
            const initialState = button.dataset.sortState || 'default';
            button.dataset.sortState = initialState;
            refreshIndicator(button, initialState);

            button.addEventListener('click', () => {
                const currentState = button.dataset.sortState || 'default';
                const nextState = currentState === 'asc' ? 'desc' : currentState === 'desc' ? 'default' : 'asc';

                applySort(Number(button.dataset.column), nextState);

                sortButtons.forEach(otherButton => {
                    if (otherButton !== button) {
                        otherButton.dataset.sortState = 'default';
                        refreshIndicator(otherButton, 'default');
                    }
                });

                button.dataset.sortState = nextState;
                refreshIndicator(button, nextState);
            });
        });

        const filterRows = keyword => {
            const normalizedKeyword = keyword.trim().toLowerCase();
            rows.forEach(row => {
                const cells = Array.from(row.cells);
                const hasMatch = normalizedKeyword === '' || cells.some(cell => cell.textContent.toLowerCase().includes(normalizedKeyword));
                row.style.display = hasMatch ? '' : 'none';
            });
        };

        if (searchInput) {
            searchInput.addEventListener('input', () => {
                filterRows(searchInput.value);
            });
        }

        if (clearButton && searchInput) {
            clearButton.addEventListener('click', () => {
                searchInput.value = '';
                filterRows('');
                searchInput.focus();
            });
        }

        filterRows(searchInput ? searchInput.value : '');
    });
</script>
</body>
</html>
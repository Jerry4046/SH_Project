<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>코드 등록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .form-section {
            border: 1px solid #dee2e6;
            border-radius: .5rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            background-color: #ffffff;
        }
        .table-responsive {
            max-height: 320px;
            overflow-y: auto;
        }
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
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="container py-4">
    <h2 class="mb-4">코드그룹 관리</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-success" role="alert">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">${error}</div>
    </c:if>

    <div class="form-section">
        <form method="post" action="${pageContext.request.contextPath}/codes/groups" class="row g-3">
            <div class="col-md-4">
                <label for="groupCodeSelect" class="form-label">그룹코드</label>
                <div class="combo-field">
                    <select id="groupCodeSelect" class="form-select pe-5" required>
                        <option value="">선택하세요</option>
                        <option value="__manual__">직접입력</option>
                        <c:forEach var="group" items="${codeGroups}">
                            <option value="${group.groupCode}"
                                    data-name="${fn:escapeXml(group.groupName)}"
                                    data-description="${fn:escapeXml(group.description)}"
                                    data-active="${group.active}">
                                ${group.groupCode} - ${group.groupName}
                            </option>
                        </c:forEach>
                    </select>
                    <button type="button"
                            class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 d-none"
                            aria-label="목록 열기">
                        <span aria-hidden="true">▾</span>
                        <span class="visually-hidden">목록 열기</span>
                    </button>
                    <div class="manual-input-wrapper d-none" id="groupCodeManualWrapper">
                        <input type="text" id="groupCodeManualInput" class="manual-input form-control"
                               placeholder="그룹코드를 입력하거나 검색하세요" autocomplete="off" list="groupCodeSearchList"
                               maxlength="20" disabled>
                    </div>
                </div>
                <datalist id="groupCodeSearchList"></datalist>
                <input type="hidden" id="groupCode" name="groupCode">
            </div>
            <div class="col-md-3">
                <label for="groupName" class="form-label">그룹이름</label>
                <input type="text" class="form-control" id="groupName" name="groupName" maxlength="50" required>
            </div>
            <div class="col-md-3">
                <label for="groupDescription" class="form-label">설명</label>
                <input type="text" class="form-control" id="groupDescription" name="description" maxlength="200">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="1" id="groupActive" name="active" checked>
                    <label class="form-check-label" for="groupActive">사용</label>
                </div>
            </div>
            <div class="col-12 text-end">
                <button type="submit" class="btn btn-primary">코드그룹 저장</button>
            </div>
        </form>
    </div>

    <div class="form-section">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">등록된 코드그룹</h5>
        </div>
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th scope="col">그룹코드</th>
                    <th scope="col">그룹이름</th>
                    <th scope="col">설명</th>
                    <th scope="col">사용여부</th>
                    <th scope="col">등록일</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="group" items="${codeGroups}">
                    <tr>
                        <td>${group.groupCode}</td>
                        <td>${group.groupName}</td>
                        <td>${group.description}</td>
                        <td>
                            <span class="badge ${group.active ? 'bg-success' : 'bg-secondary'}">
                                ${group.active ? '사용' : '미사용'}
                            </span>
                        </td>
                        <td><c:out value="${group.createdAt}"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty codeGroups}">
                    <tr>
                        <td colspan="5" class="text-center text-muted">등록된 코드그룹이 없습니다.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <h2 class="mb-4">공통코드 관리</h2>
    <div class="form-section">
        <form method="post" action="${pageContext.request.contextPath}/codes/items" class="row g-3">
            <div class="col-md-4">
                <label for="itemGroupCodeSelect" class="form-label">그룹코드</label>
                <div class="combo-field">
                    <select id="itemGroupCodeSelect" class="form-select pe-5" required>
                        <option value="">선택하세요</option>
                        <option value="__manual__">직접입력</option>
                    </select>
                    <button type="button"
                            class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 d-none"
                            aria-label="목록 열기">
                        <span aria-hidden="true">▾</span>
                        <span class="visually-hidden">목록 열기</span>
                    </button>
                    <div class="manual-input-wrapper d-none" id="itemGroupCodeManualWrapper">
                        <input type="text" id="itemGroupCodeManualInput" class="manual-input form-control"
                               placeholder="그룹코드를 입력하거나 검색하세요" autocomplete="off" list="itemGroupCodeSearchList"
                               maxlength="20" disabled>
                    </div>
                </div>
                <datalist id="itemGroupCodeSearchList"></datalist>
                <input type="hidden" id="itemGroupCode" name="groupCode">
            </div>
            <div class="col-md-3">
                <label for="itemCodeSelect" class="form-label">코드</label>
                <div class="combo-field">
                    <select id="itemCodeSelect" class="form-select pe-5" required>
                        <option value="">선택하세요</option>
                        <option value="__manual__">직접입력</option>
                    </select>
                    <button type="button"
                            class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 d-none"
                            aria-label="목록 열기">
                        <span aria-hidden="true">▾</span>
                        <span class="visually-hidden">목록 열기</span>
                    </button>
                    <div class="manual-input-wrapper d-none" id="itemCodeManualWrapper">
                        <input type="text" id="itemCodeManualInput" class="manual-input form-control"
                               placeholder="코드를 입력하거나 검색하세요" autocomplete="off" list="itemCodeSearchList"
                               maxlength="30" disabled>
                    </div>
                </div>
                <datalist id="itemCodeSearchList"></datalist>
                <input type="hidden" id="itemCodeValue" name="code">
            </div>
            <div class="col-md-3">
                <label for="itemCodeName" class="form-label">코드이름</label>
                <input type="text" class="form-control" id="itemCodeName" name="codeLabel" maxlength="100" required>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="1" id="itemActive" name="active" checked>
                    <label class="form-check-label" for="itemActive">사용</label>
                </div>
            </div>
            <div class="col-12 text-end">
                <button type="submit" class="btn btn-primary">공통코드 저장</button>
            </div>
        </form>
    </div>

    <template id="itemCodeOptionsTemplate">
        <c:forEach var="item" items="${codeItems}">
            <option value="${item.code}"
                    data-group-code="${item.groupCode}"
                    data-name="${fn:escapeXml(item.codeLabel)}"
                    data-active="${item.active}">
                ${item.code} - ${item.codeLabel}
            </option>
        </c:forEach>
    </template>

    <div class="form-section">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">등록된 공통코드</h5>
        </div>
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th scope="col">그룹코드</th>
                    <th scope="col">코드</th>
                    <th scope="col">코드이름</th>
                    <th scope="col">사용여부</th>
                    <th scope="col">등록일</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${codeItems}">
                    <tr>
                        <td>${item.groupCode}</td>
                        <td>${item.code}</td>
                        <td>${item.codeLabel}</td>
                        <td>
                            <span class="badge ${item.active ? 'bg-success' : 'bg-secondary'}">
                                ${item.active ? '사용' : '미사용'}
                            </span>
                        </td>
                        <td><c:out value="${item.createdAt}"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty codeItems}">
                    <tr>
                        <td colspan="5" class="text-center text-muted">등록된 공통코드가 없습니다.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    (function () {
        document.addEventListener('DOMContentLoaded', () => {
            const groupOptionsData = collectGroupOptions();
            const itemOptionsData = collectItemOptions();

            document.querySelectorAll('.combo-field').forEach(setupComboToggle);

            // 그룹 폼 요소
            const groupNameInput = document.getElementById('groupName');
            const groupDescriptionInput = document.getElementById('groupDescription');
            const groupActiveCheckbox = document.getElementById('groupActive');

            // 아이템 폼 요소 (이름은 codeLabel로 바뀌었지만 id는 itemCodeName 그대로)
            const itemCodeLabelInput = document.getElementById('itemCodeName');
            const itemActiveCheckbox = document.getElementById('itemActive');

            let groupFieldsFromOption = false;
            let itemFieldsFromOption = false;

            // 1) 그룹 콤보
            const groupCombo = setupLookupCombo({
                selectId: 'groupCodeSelect',
                manualWrapperId: 'groupCodeManualWrapper',
                manualInputId: 'groupCodeManualInput',
                hiddenInputId: 'groupCode',
                datalistId: 'groupCodeSearchList',
                placeholder: '그룹코드 선택',
                optionsProvider: () => groupOptionsData,
                onOptionSelected: (option) => {
                    // ✅ 여기서는 "그룹" 폼을 채워야 함
                    groupFieldsFromOption = true;
                    if (groupNameInput) {
                        groupNameInput.value = option.name || '';
                    }
                    if (groupDescriptionInput) {
                        groupDescriptionInput.value = option.description || '';
                    }
                    if (groupActiveCheckbox) {
                        groupActiveCheckbox.checked = !!option.active;
                    }
                },
                onManualValue: () => {
                    if (groupFieldsFromOption) {
                        clearGroupForm();
                        groupFieldsFromOption = false;
                    }
                },
                onCleared: () => {
                    clearGroupForm();
                    groupFieldsFromOption = false;
                }
            });
            groupCombo.refresh();

            // 2) 아이템의 '그룹코드' 콤보
            const itemGroupCombo = setupLookupCombo({
                selectId: 'itemGroupCodeSelect',
                manualWrapperId: 'itemGroupCodeManualWrapper',
                manualInputId: 'itemGroupCodeManualInput',
                hiddenInputId: 'itemGroupCode',
                datalistId: 'itemGroupCodeSearchList',
                placeholder: '그룹코드 선택',
                optionsProvider: () => groupOptionsData,
                onOptionSelected: () => {
                    itemCodeCombo.setDisabled(false);
                    itemCodeCombo.refresh();
                },
                onManualValue: () => {
                    itemCodeCombo.clear();
                    itemCodeCombo.setDisabled(true);
                },
                onCleared: () => {
                    itemCodeCombo.clear();
                    itemCodeCombo.setDisabled(true);
                }
            });
            itemGroupCombo.refresh();

            // 3) 아이템의 '코드' 콤보
            const itemCodeCombo = setupLookupCombo({
                selectId: 'itemCodeSelect',
                manualWrapperId: 'itemCodeManualWrapper',
                manualInputId: 'itemCodeManualInput',
                hiddenInputId: 'itemCodeValue',
                datalistId: 'itemCodeSearchList',
                placeholder: '공통코드 선택',
                optionsProvider: () => {
                    const groupCode = itemGroupCombo.getValue();
                    if (!groupCode) {
                        return [];
                    }
                    return itemOptionsData
                        .filter(item => item.groupCode === groupCode)
                        .map(item => ({
                            code: item.code,
                            label: item.code + (item.name ? ' - ' + item.name : ''),
                            name: item.name,
                            active: item.active
                        }));
                },
                onOptionSelected: (option) => {
                    itemFieldsFromOption = true;
                    // ✅ 여기서도 이름 변수 통일
                    if (itemCodeLabelInput) {
                        itemCodeLabelInput.value = option.name || '';
                    }
                    if (itemActiveCheckbox) {
                        itemActiveCheckbox.checked = !!option.active;
                    }
                },
                onManualValue: () => {
                    if (itemFieldsFromOption) {
                        resetItemForm();
                        itemFieldsFromOption = false;
                    }
                },
                onCleared: () => {
                    resetItemForm();
                    itemFieldsFromOption = false;
                }
            });
            itemCodeCombo.refresh();
            itemCodeCombo.setDisabled(true);

            function clearGroupForm() {
                if (groupNameInput) {
                    groupNameInput.value = '';
                }
                if (groupDescriptionInput) {
                    groupDescriptionInput.value = '';
                }
                if (groupActiveCheckbox) {
                    groupActiveCheckbox.checked = true;
                }
            }

            function resetItemForm() {
                if (itemCodeLabelInput) {
                    itemCodeLabelInput.value = '';
                }
                if (itemActiveCheckbox) {
                    itemActiveCheckbox.checked = true;
                }
            }
        });

        // ===== 아래는 공통 유틸 =====

        function setupComboToggle(field) {
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
                    select.dispatchEvent(new MouseEvent(eventType, { bubbles: true }));
                });
            });
        }

        function collectGroupOptions() {
            const select = document.getElementById('groupCodeSelect');
            if (!select) {
                return [];
            }
            return Array.from(select.querySelectorAll('option'))
                .filter(option => option.value && option.value !== '__manual__')
                .map(option => ({
                    code: option.value,
                    label: option.textContent ? option.textContent.trim() : option.value,
                    name: option.dataset.name || '',
                    description: option.dataset.description || '',
                    active: option.dataset.active === 'true'
                }));
        }

        function collectItemOptions() {
            const template = document.getElementById('itemCodeOptionsTemplate');
            if (!template || !('content' in template)) {
                return [];
            }
            return Array.from(template.content.querySelectorAll('option')).map(option => ({
                code: option.value,
                groupCode: option.dataset.groupCode || '',
                label: option.textContent ? option.textContent.trim() : option.value,
                name: option.dataset.name || '',
                active: option.dataset.active === 'true'
            }));
        }

        function setupLookupCombo(config) {
            const {
                selectId,
                manualWrapperId,
                manualInputId,
                hiddenInputId,
                datalistId,
                placeholder,
                optionsProvider,
                onOptionSelected,
                onManualValue,
                onCleared,
                onValueChange
            } = config;

            const selectEl = document.getElementById(selectId);
            const manualWrapper = manualWrapperId ? document.getElementById(manualWrapperId) : null;
            const manualInput = manualInputId ? document.getElementById(manualInputId) : null;
            const hiddenInput = document.getElementById(hiddenInputId);
            const datalistEl = datalistId ? document.getElementById(datalistId) : null;

            if (!selectEl || !hiddenInput) {
                return createLookupComboStub();
            }

            const manualToken = '__manual__';
            let availableOptions = [];
            let manualActive = false;
            let lastNotifiedCode = hiddenInput.value ? hiddenInput.value.trim() : '';
            let lastNotifiedOptionCode = null;

            function refreshAvailableOptions() {
                availableOptions = optionsProvider ? [...optionsProvider()] : [];
            }

            function setManualState(isManual, options = {}) {
                if (!manualWrapper || !manualInput) {
                    manualActive = false;
                    return;
                }
                manualActive = isManual;
                if (isManual) {
                    manualWrapper.classList.remove('d-none');
                    manualInput.disabled = selectEl.disabled;
                    if (!selectEl.disabled) {
                        manualInput.disabled = false;
                        manualInput.focus();
                        manualInput.select();
                    }
                } else {
                    manualWrapper.classList.add('d-none');
                    manualInput.disabled = true;
                    if (!options.preserveValue) {
                        manualInput.value = '';
                    }
                }
                updateSelectValidity();
            }

            function renderSelect() {
                const currentValue = hiddenInput.value ? hiddenInput.value.trim() : '';
                selectEl.innerHTML = '';
                const placeholderOption = new Option(placeholder || '선택하세요', '');
                placeholderOption.disabled = true;
                placeholderOption.selected = !currentValue;
                selectEl.appendChild(placeholderOption);

                if (manualInput) {
                    selectEl.appendChild(new Option('직접입력', manualToken));
                }

                availableOptions.forEach(option => {
                    const optEl = new Option(option.label || option.code, option.code);
                    if (option.name !== undefined) {
                        optEl.dataset.name = option.name;
                    }
                    if (option.description !== undefined) {
                        optEl.dataset.description = option.description;
                    }
                    if (option.active !== undefined) {
                        optEl.dataset.active = option.active ? 'true' : 'false';
                    }
                    selectEl.appendChild(optEl);
                });

                if (currentValue) {
                    const matched = availableOptions.find(option => option.code === currentValue);
                    if (matched) {
                        selectEl.value = matched.code;
                        setManualState(false);
                    } else if (manualInput) {
                        selectEl.value = manualToken;
                        setManualState(true, { preserveValue: true });
                        manualInput.value = currentValue;
                    }
                } else {
                    selectEl.value = '';
                    setManualState(false);
                }

                updateSelectValidity();
            }

            function updateDatalist(query = '') {
                if (!datalistEl) {
                    return;
                }
                const normalized = query ? query.trim().toLowerCase() : '';
                datalistEl.innerHTML = '';
                if (!availableOptions.length) {
                    return;
                }
                const filtered = availableOptions.filter(option => {
                    if (!normalized) return true;
                    const searchable = (option.code + ' ' + (option.label || '') + ' ' + (option.name || '')).toLowerCase();
                    return searchable.includes(normalized);
                }).slice(0, 20);

                filtered.forEach(option => {
                    const display = option.label || (option.code + (option.name ? ' - ' + option.name : ''));
                    const opt = document.createElement('option');
                    opt.value = display;
                    opt.dataset.code = option.code;
                    datalistEl.appendChild(opt);
                });
            }

            function matchDatalist(value) {
                if (!datalistEl || !value) {
                    return null;
                }
                return Array.from(datalistEl.options).find(option => option.value === value) || null;
            }

            function notifyValueChange(code, option) {
                const normalized = code ? code.trim() : '';
                const optionCode = option ? option.code : null;

                if (normalized === lastNotifiedCode && optionCode === lastNotifiedOptionCode) {
                    return;
                }

                lastNotifiedCode = normalized;
                lastNotifiedOptionCode = optionCode;

                if (typeof onValueChange === 'function') {
                    onValueChange(normalized, option);
                }

                if (!normalized) {
                    if (typeof onCleared === 'function') {
                        onCleared();
                    }
                    return;
                }

                if (option) {
                    if (typeof onOptionSelected === 'function') {
                        onOptionSelected(option);
                    }
                } else if (typeof onManualValue === 'function') {
                    onManualValue(normalized);
                }
            }

            function applyResolvedValue(code, option) {
                const normalized = code ? code.trim() : '';
                hiddenInput.value = normalized;
                notifyValueChange(normalized, option);
                updateSelectValidity();
            }

            function handleSelectChange() {
                const value = selectEl.value;
                if (!value) {
                    setManualState(false);
                    applyResolvedValue('', null);
                    updateDatalist('');
                    return;
                }

                if (value === manualToken) {
                    setManualState(true, { preserveValue: true });
                    updateDatalist(manualInput ? manualInput.value : '');
                    applyResolvedValue(manualInput ? manualInput.value : '', null);
                    return;
                }

                setManualState(false);
                const option = availableOptions.find(item => item.code === value) || null;
                applyResolvedValue(value, option);
                updateDatalist('');
            }

            function handleManualInput(event) {
                if (!manualInput) return;

                if (selectEl.value !== manualToken) {
                    selectEl.value = manualToken;
                    setManualState(true, { preserveValue: true });
                }

                const value = event.target.value || '';
                updateDatalist(value);

                const matched = matchDatalist(value);
                if (matched) {
                    const option = availableOptions.find(item => item.code === matched.dataset.code);
                    if (option) {
                        selectEl.value = option.code;
                        setManualState(false);
                        applyResolvedValue(option.code, option);
                        updateDatalist('');
                        return;
                    }
                }
                applyResolvedValue(value, null);
            }

            function handleManualBlur() {
                if (!manualInput) return;

                const value = manualInput.value || '';
                const matched = matchDatalist(value);
                if (!value) {
                    applyResolvedValue('', null);
                    return;
                }
                if (matched) {
                    const option = availableOptions.find(item => item.code === matched.dataset.code);
                    if (option) {
                        selectEl.value = option.code;
                        setManualState(false);
                        applyResolvedValue(option.code, option);
                        updateDatalist('');
                        return;
                    }
                }
                applyResolvedValue(value, null);
            }

            function updateSelectValidity() {
                if (!selectEl.required) return;

                if (!manualInput) {
                    selectEl.setCustomValidity(selectEl.value ? '' : '값을 선택하세요.');
                    return;
                }

                if (manualActive) {
                    const hasValue = !!(hiddenInput.value && hiddenInput.value.trim());
                    selectEl.setCustomValidity(hasValue ? '' : '값을 입력하세요.');
                } else {
                    selectEl.setCustomValidity(selectEl.value ? '' : '값을 선택하세요.');
                }
            }

            selectEl.addEventListener('change', handleSelectChange);

            if (manualInput) {
                manualInput.addEventListener('input', handleManualInput);
                manualInput.addEventListener('blur', handleManualBlur);
            }

            refreshAvailableOptions();
            renderSelect();
            updateDatalist('');

            return {
                refresh() {
                    refreshAvailableOptions();
                    renderSelect();
                    updateDatalist(manualInput && manualActive ? manualInput.value : '');
                },
                getValue() {
                    return hiddenInput.value ? hiddenInput.value.trim() : '';
                },
                setValue(value) {
                    hiddenInput.value = value || '';
                    refresh();
                },
                clear() {
                    hiddenInput.value = '';
                    setManualState(false);
                    selectEl.value = '';
                    updateDatalist('');
                    applyResolvedValue('', null);
                },
                setDisabled(disabled) {
                    selectEl.disabled = disabled;
                    if (manualInput) {
                        manualInput.disabled = disabled || !manualActive;
                    }
                    const field = selectEl.closest('.combo-field');
                    const toggle = field ? field.querySelector('.combo-toggle') : null;
                    if (toggle) {
                        toggle.disabled = disabled;
                    }
                    updateSelectValidity();
                }
            };
        }

        function createLookupComboStub() {
            return {
                refresh() {},
                getValue() { return ''; },
                setValue() {},
                clear() {},
                setDisabled() {}
            };
        }
    })();
</script>

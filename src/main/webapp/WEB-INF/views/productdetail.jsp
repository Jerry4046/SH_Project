<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
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
                <button type="button" class="btn btn-outline-primary" id="productTabBtn">제품</button>
                <button type="button" class="btn btn-outline-primary active" id="codeTabBtn">제품코드</button>
            </div>

            <div id="codeForm">
                <form id="codeRegisterForm" autocomplete="off" onsubmit="return false;">
                    <div class="row g-3 align-items-end mb-3">
                        <div class="col-md">
                            <label class="form-label" for="codeCompanyName">회사 이름</label>
                            <div class="combo-field position-relative">
                                <select id="codeCompanyName" class="form-select pe-5" data-placeholder="선택하세요"
                                        data-selected-code="${param.companyCode}">
                                    <option value="">선택하세요</option>
                                    <option value="__manual__">직접입력</option>
                                    <c:forEach var="company" items="${companies}">
                                        <option value="${company.companyCode}">${company.companyName}</option>
                                    </c:forEach>
                                </select>
                                <input type="text" id="codeCompanyNameInput"
                                       class="manual-input form-control position-absolute top-0 start-0 w-100 h-100 pe-5 z-1 d-none"
                                       placeholder="회사 이름을 입력하세요" autocomplete="off" disabled>
                                <button type="button"
                                        class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 z-2 d-none"
                                        aria-label="목록 열기">
                                    <span aria-hidden="true">▾</span>
                                    <span class="visually-hidden">목록 열기</span>
                                </button>
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
                            <div class="combo-field position-relative">
                                <select id="codeTypeName" class="form-select pe-5" data-placeholder="선택하세요"
                                        data-selected-code="${param.typeCode}" disabled>
                                    <option value="">선택하세요</option>
                                    <option value="__manual__">직접입력</option>
                                </select>
                                <input type="text" id="codeTypeNameInput"
                                       class="manual-input form-control position-absolute top-0 start-0 w-100 h-100 pe-5 z-1 d-none"
                                       placeholder="타입 이름을 입력하세요" autocomplete="off" disabled>
                                <button type="button"
                                        class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 z-2 d-none"
                                        aria-label="목록 열기">
                                    <span aria-hidden="true">▾</span>
                                    <span class="visually-hidden">목록 열기</span>
                                </button>
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
                            <div class="combo-field position-relative">
                                <select id="codeCategoryName" class="form-select pe-5" data-placeholder="선택하세요"
                                        data-selected-code="${param.categoryCode}" disabled>
                                    <option value="">선택하세요</option>
                                    <option value="__manual__">직접입력</option>
                                </select>
                                <input type="text" id="codeCategoryNameInput"
                                       class="manual-input form-control position-absolute top-0 start-0 w-100 h-100 pe-5 z-1 d-none"
                                       placeholder="카테고리 이름을 입력하세요" autocomplete="off" disabled>
                                <button type="button"
                                        class="combo-toggle btn btn-outline-secondary position-absolute top-0 end-0 h-100 px-3 z-2 d-none"
                                        aria-label="목록 열기">
                                    <span aria-hidden="true">▾</span>
                                    <span class="visually-hidden">목록 열기</span>
                                </button>
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

            <div id="productForm" style="display:none;">
                <form action="${pageContext.request.contextPath}/product/register" method="post" class="mt-3">
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
                        <label class="form-label" for="piecesPerBox">박스당 수량</label>
                        <input type="number" name="piecesPerBox" id="piecesPerBox" class="form-control" min="1" value="1" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="totalQty">총재고</label>
                        <input type="number" name="totalQty" id="totalQty" class="form-control" min="0" value="0" required>
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
                <button type="button" class="btn btn-warning" onclick="toggleDetailEdit()">수정</button>
            </div>
            <form action="${pageContext.request.contextPath}/product/update" method="post" id="detailForm">
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
                            <th>박스재고</th>
                            <th>낱개</th>
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
                            <td><span class="value"><c:out value="${product.productCode}" /></span></td>
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
                                <span class="value"><c:out value="${product.piecesPerBox}" /></span>
                                <input type="number" name="piecesPerBox" min="1" value="<c:out value='${product.piecesPerBox}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value"><c:out value="${empty product.stock ? 0 : product.stock.boxQty}" /></span>
                                <input type="number" name="boxQty" min="0" value="<c:out value='${empty product.stock ? 0 : product.stock.boxQty}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value"><c:out value="${empty product.stock ? 0 : product.stock.looseQty}" /></span>
                                <input type="number" name="looseQty" min="0" value="<c:out value='${empty product.stock ? 0 : product.stock.looseQty}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
                            </td>
                            <td>
                                <span class="value"><c:out value="${empty product.stock ? 0 : product.stock.totalQty}" /></span>
                                <input type="number" name="totalQty" min="0" value="<c:out value='${empty product.stock ? 0 : product.stock.totalQty}'/>"
                                       class="form-control form-control-sm edit-field" style="display:none;" disabled>
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

<script>

</script>

</body>
</html>
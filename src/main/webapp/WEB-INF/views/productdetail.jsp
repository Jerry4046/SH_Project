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
            <h2>제품 등록</h2>
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
                                </thead>
                                <tbody>
                                <tr class="${product.active ? '' : 'text-muted'}">
                                    <td class="edit-col" style="display:none;">
                                        <input type="checkbox" onchange="toggleDetailRow(this)">
                                    </td>
                                    <td><c:out value="${product.user.name}"/></td>
                                    <td><input type="text" name="productCode" value="${product.productCode}" class="form-control form-control-sm" disabled></td>
                                    <td><input type="text" name="itemCode" value="${product.itemCode}" class="form-control form-control-sm" disabled></td>
                                    <td><input type="text" name="spec" value="${product.spec}" class="form-control form-control-sm" disabled></td>
                                    <td><input type="text" name="pdName" value="${product.pdName}" class="form-control form-control-sm" disabled></td>
                                    <td><input type="number" name="piecesPerBox" value="${empty product.stock.piecesPerBox ? 0 : product.stock.piecesPerBox}" class="form-control form-control-sm" disabled></td>
                                    <td><input type="number" name="boxQty" value="${empty product.stock.boxQty ? 0 : product.stock.boxQty}" class="form-control form-control-sm" disabled></td>
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
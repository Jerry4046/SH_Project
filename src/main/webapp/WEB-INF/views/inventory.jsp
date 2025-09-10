<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>제품 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" /> <!-- ✅ 헤더 포함 -->

<div class="container mt-5">

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

    <!-- 검색창 -->
    <div class="mb-3">
        <input type="text" class="form-control" placeholder="상품명을 검색하세요" id="searchInput" onkeyup="filterTable()">
    </div>

    <!-- 테이블 -->
    <div class="table-responsive">
       <table class="table table-hover align-middle text-center">
            <thead class="table-light">
              <tr>
                  <th class="edit-col" style="display:none;"></th>
                  <th>상품명</th>
                  <th>박스당 수량</th>
                  <th>박스재고</th>
                  <th>낱개</th>
                  <th>총재고</th>
                  <th>단가</th>
                  <th>최소재고</th>
                  <th>사용여부</th>
                  <th>상세</th>
              </tr>
              </thead>
              <tbody id="productTable">
              <c:forEach var="product" items="${productList}">
                  <form action="${pageContext.request.contextPath}/product/update" method="post">
                  <tr class="${product.active ? '' : 'text-muted'}">
                      <td class="edit-col" style="display:none;">
                          <input type="checkbox" class="row-check" onchange="toggleRow(this)">
                      </td>
                      <td>
                          <span class="value">${product.pdName}</span>
                          <input type="text" name="pdName" value="${product.pdName}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td>
                          <span class="value">${empty product.stock.piecesPerBox ? 0 : product.stock.piecesPerBox}</span>
                          <input type="number" name="piecesPerBox" value="${empty product.stock.piecesPerBox ? 0 : product.stock.piecesPerBox}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td>
                          <span class="value">${empty product.stock.boxQty ? 0 : product.stock.boxQty}</span>
                          <input type="number" name="boxQty" value="${empty product.stock.boxQty ? 0 : product.stock.boxQty}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td>
                          <span class="value">${empty product.stock.looseQty ? 0 : product.stock.looseQty}</span>
                          <input type="number" name="looseQty" value="${empty product.stock.looseQty ? 0 : product.stock.looseQty}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td>
                          <span class="value">${empty product.stock.totalQty ? 0 : product.stock.totalQty}</span>
                          <input type="number" name="totalQty" value="${empty product.stock.totalQty ? 0 : product.stock.totalQty}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td>
                          <span class="value">${product.getPrice()}</span>
                          <input type="number" step="0.01" name="price" value="${product.getPrice()}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td>
                          <span class="value">${product.minStockQuantity}</span>
                          <input type="number" name="minStockQuantity" value="${product.minStockQuantity}" class="form-control form-control-sm edit-field" style="display:none" disabled>
                      </td>
                      <td>
                          <span class="value">${product.active ? '사용' : '미사용'}</span>
                          <select name="active" class="form-select form-select-sm edit-field" style="display:none" disabled>
                              <option value="true" ${product.active ? 'selected' : ''}>사용</option>
                              <option value="false" ${!product.active ? 'selected' : ''}>미사용</option>
                          </select>
                      </td>
                      <td>
                          <a href="${pageContext.request.contextPath}/product/detail/${product.productCode}" class="btn btn-sm btn-outline-primary">상세</a>
                          <input type="hidden" name="originalCode" value="${product.productCode}">
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

<!-- ✅ 검색 필터 스크립트 -->
<script>
    function filterTable() {
        const input = document.getElementById("searchInput").value.toLowerCase();
        const rows = document.querySelectorAll("#productTable tr");

            rows.forEach(row => {
                if (row.id === "registerRow") return ;

            const nameCell = row.cells[1];
            if (!nameCell) return;
            const name = nameCell.textContent.toLowerCase();

            row.style.display = name.includes(input) ? "" : "none";
        });
      }
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
  </script>


</body>
</html>

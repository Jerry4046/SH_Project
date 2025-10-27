<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>입/출고 현황</title>
    <link rel="stylesheet" href="<c:url value='/css/bootstrap.min.css'/>">
    <style>
        .summary-card {
            border-left: 4px solid rgba(13, 110, 253, 0.5);
            transition: transform 0.2s ease;
        }

        .summary-card:hover {
            transform: translateY(-4px);
        }

        .badge-inbound {
            background-color: rgba(25, 135, 84, 0.15);
            color: #198754;
        }

        .badge-outbound {
            background-color: rgba(220, 53, 69, 0.15);
            color: #dc3545;
        }

        .table thead th {
            white-space: nowrap;
        }

        .table tbody td {
            vertical-align: middle;
        }

        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 0.35rem;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container py-5">
    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-4">
        <div>
            <h2 class="mb-1">입/출고 현황</h2>
            <p class="text-muted mb-0">창고 내 자재의 입고/출고 흐름을 한 눈에 확인하세요.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-secondary">재고 현황</a>
            <a href="${pageContext.request.contextPath}/transaction/register" class="btn btn-primary">입/출고 등록</a>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card shadow-sm summary-card">
                <div class="card-body">
                    <p class="text-muted mb-1">총 입고 수량</p>
                    <h4 class="mb-0">
                        <fmt:formatNumber value="${inboundTotal}" type="number" /> EA
                    </h4>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm summary-card">
                <div class="card-body">
                    <p class="text-muted mb-1">총 출고 수량</p>
                    <h4 class="mb-0">
                        <fmt:formatNumber value="${outboundTotal}" type="number" /> EA
                    </h4>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm summary-card">
                <div class="card-body">
                    <p class="text-muted mb-1">미확정 건</p>
                    <h4 class="mb-0">
                        <fmt:formatNumber value="${pendingCount}" type="number" /> 건
                    </h4>
                </div>
            </div>
        </div>
    </div>

    <form class="row g-3 align-items-end mb-4" method="get" action="">
        <div class="col-md-3">
            <label for="dateFrom" class="form-label">기간</label>
            <input type="date" class="form-control" id="dateFrom" name="fromDate" value="${param.fromDate}">
            <small class="text-muted">부터</small>
        </div>
        <div class="col-md-3">
            <label for="dateTo" class="form-label">&nbsp;</label>
            <input type="date" class="form-control" id="dateTo" name="toDate" value="${param.toDate}">
            <small class="text-muted">까지</small>
        </div>
        <div class="col-md-2">
            <label for="typeFilter" class="form-label">유형</label>
            <select id="typeFilter" name="type" class="form-select">
                <option value="" ${empty param.type ? 'selected' : ''}>전체</option>
                <option value="IN" ${param.type eq 'IN' ? 'selected' : ''}>입고</option>
                <option value="OUT" ${param.type eq 'OUT' ? 'selected' : ''}>출고</option>
            </select>
        </div>
        <div class="col-md-2">
            <label for="statusFilter" class="form-label">상태</label>
            <select id="statusFilter" name="status" class="form-select">
                <option value="" ${empty param.status ? 'selected' : ''}>전체</option>
                <option value="PENDING" ${param.status eq 'PENDING' ? 'selected' : ''}>미확정</option>
                <option value="COMPLETED" ${param.status eq 'COMPLETED' ? 'selected' : ''}>완료</option>
            </select>
        </div>
        <div class="col-md-2">
            <label for="keyword" class="form-label">검색</label>
            <input type="text" id="keyword" name="keyword" class="form-control" placeholder="제품명/담당자" value="${param.keyword}">
        </div>
        <div class="col-12 d-flex justify-content-end gap-2">
            <button type="submit" class="btn btn-primary">조회</button>
            <a href="${pageContext.request.requestURI}" class="btn btn-outline-secondary">초기화</a>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th scope="col">#</th>
                <th scope="col">처리일</th>
                <th scope="col">유형</th>
                <th scope="col">제품명</th>
                <th scope="col">수량</th>
                <th scope="col">창고</th>
                <th scope="col">담당자</th>
                <th scope="col">상태</th>
                <th scope="col">비고</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty transactions}">
                    <c:forEach var="transaction" items="${transactions}" varStatus="status">
                        <tr>
                            <th scope="row">${status.index + 1}</th>
                            <td>
                                <fmt:formatDate value="${transaction.processedAt}" pattern="yyyy-MM-dd"/>
                                <div class="text-muted small">
                                    <fmt:formatDate value="${transaction.processedAt}" pattern="HH:mm"/>
                                </div>
                            </td>
                            <td>
                                <span class="badge ${transaction.type eq 'IN' ? 'badge-inbound' : 'badge-outbound'}">
                                    <c:choose>
                                        <c:when test="${transaction.type eq 'IN'}">입고</c:when>
                                        <c:otherwise>출고</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="text-start">
                                <strong>${transaction.productName}</strong>
                                <div class="text-muted small">${transaction.productCode}</div>
                            </td>
                            <td>
                                <strong>
                                    <fmt:formatNumber value="${transaction.quantity}" type="number" /> EA
                                </strong>
                            </td>
                            <td>${transaction.warehouseName}</td>
                            <td>${transaction.handledBy}</td>
                            <td class="text-start">
                                <span class="status-indicator"
                                      style="background-color: ${transaction.status eq 'COMPLETED' ? '#198754' : '#ffc107'}"></span>
                                <c:choose>
                                    <c:when test="${transaction.status eq 'COMPLETED'}">완료</c:when>
                                    <c:otherwise>미확정</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-start">${transaction.remark}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="9" class="py-5 text-muted">표시할 입/출고 내역이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <c:if test="${not empty pagination}">
        <nav aria-label="입출고 페이지네이션" class="d-flex justify-content-center">
            <ul class="pagination">
                <li class="page-item ${pagination.first ? 'disabled' : ''}">
                    <a class="page-link" href="?page=0" tabindex="-1">처음</a>
                </li>
                <li class="page-item ${pagination.hasPrevious ? '' : 'disabled'}">
                    <a class="page-link" href="?page=${pagination.number - 1}">이전</a>
                </li>
                <c:forEach begin="0" end="${pagination.totalPages - 1}" var="page">
                    <li class="page-item ${pagination.number eq page ? 'active' : ''}">
                        <a class="page-link" href="?page=${page}">${page + 1}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${pagination.hasNext ? '' : 'disabled'}">
                    <a class="page-link" href="?page=${pagination.number + 1}">다음</a>
                </li>
                <li class="page-item ${pagination.last ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${pagination.totalPages - 1}">마지막</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<script src="<c:url value='/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>

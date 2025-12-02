package com.project.SH.dto;

public record PurchaseOrderSearchRequest(
        String baseDateFrom,
        String baseDateTo,
        String prodCd,
        String custCd,
        Integer pageCurrent,
        Integer pageSize
) {
}
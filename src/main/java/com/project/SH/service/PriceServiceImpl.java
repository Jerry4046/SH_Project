package com.project.SH.service;

import com.project.SH.domain.Product;

public interface PriceServiceImpl {

    // 가격 등록 메서드
    void registerPrice(Product product, Double price, Long accountSeq);

    // 최신 가격 조회 메서드
    Double getLatestPrice(Product product);
}
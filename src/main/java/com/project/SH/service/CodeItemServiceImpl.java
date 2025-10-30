package com.project.SH.service;

import com.project.SH.domain.CodeItem;

import java.util.List;

public interface CodeItemServiceImpl  {
    List<CodeItem> getAll();

    List<CodeItem> search(String groupCode, String query, boolean activeOnly);

    CodeItem save(String groupCode, String code, String codeLabel, boolean active);
}
package com.project.SH.service;

import com.project.SH.domain.CodeGroup;

import java.util.List;

public interface CodeGroupServiceImpl {
    List<CodeGroup> getAll();

    List<CodeGroup> search(String query, boolean activeOnly);

    CodeGroup save(String groupCode, String groupName, String description, boolean active);
}
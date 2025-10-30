package com.project.SH.service;

import com.project.SH.domain.CodeGroup;
import com.project.SH.domain.CodeItem;
import com.project.SH.domain.CodeItemId;
import com.project.SH.repository.CodeGroupRepository;
import com.project.SH.repository.CodeItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CodeItemService implements CodeItemServiceImpl {

    private final CodeItemRepository codeItemRepository;
    private final CodeGroupRepository codeGroupRepository;

    @Override
    public List<CodeItem> getAll() {
        return codeItemRepository.findAllWithGroup();
    }

    @Override
    public List<CodeItem> search(String groupCode, String query, boolean activeOnly) {
        if (groupCode == null || groupCode.isBlank()) {
            return List.of();
        }
        return codeItemRepository.search(groupCode, normalizeQuery(query), activeOnly);
    }

    @Override
    @Transactional
    public CodeItem save(String groupCode, String code, String codeLabel, boolean active) {
        CodeGroup codeGroup = codeGroupRepository.findById(groupCode)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 코드그룹입니다."));

        CodeItemId id = new CodeItemId(groupCode, code);
        CodeItem codeItem = codeItemRepository.findById(id)
                .orElseGet(() -> CodeItem.builder()
                        .id(id)
                        .group(codeGroup)
                        .build());
        codeItem.setGroup(codeGroup);
        codeItem.setCodeLabel(codeLabel);
        codeItem.setActive(active);
        return codeItemRepository.save(codeItem);
    }

    private String normalizeQuery(String query) {
        return (query == null || query.isBlank()) ? null : query.trim();
    }
}
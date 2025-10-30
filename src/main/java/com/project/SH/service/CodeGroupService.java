package com.project.SH.service;

import com.project.SH.domain.CodeGroup;
import com.project.SH.repository.CodeGroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CodeGroupService  implements CodeGroupServiceImpl{

    private final CodeGroupRepository codeGroupRepository;

    @Override
    public List<CodeGroup> getAll() {
        return codeGroupRepository.findAll(Sort.by(Sort.Direction.ASC, "groupCode"));
    }

    @Override
    public List<CodeGroup> search(String query, boolean activeOnly) {
        return codeGroupRepository.search(normalizeQuery(query), activeOnly);
    }

    @Override
    public CodeGroup save(String groupCode, String groupName, String description, boolean active) {
        CodeGroup codeGroup = codeGroupRepository.findById(groupCode)
                .orElseGet(() -> CodeGroup.builder().groupCode(groupCode).build());
        codeGroup.setGroupName(groupName);
        codeGroup.setDescription(normalizeDescription(description));
        codeGroup.setActive(active);
        return codeGroupRepository.save(codeGroup);
    }

    private String normalizeQuery(String query) {
        return (query == null || query.isBlank()) ? null : query.trim();
    }

    private String normalizeDescription(String description) {
        if (description == null) {
            return null;
        }
        String trimmed = description.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
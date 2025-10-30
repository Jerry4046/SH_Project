package com.project.SH.controller;

import com.project.SH.service.CodeGroupService;
import com.project.SH.service.CodeItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/codes")
@RequiredArgsConstructor
public class CodeLookupApiController {

    private final CodeGroupService codeGroupService;
    private final CodeItemService codeItemService;

    @GetMapping("/groups")
    public List<LookupResponse> searchGroups(@RequestParam(value = "query", required = false) String query,
                                             @RequestParam(value = "activeOnly", defaultValue = "false") boolean activeOnly) {
        return codeGroupService.search(query, activeOnly).stream()
                .map(group -> new LookupResponse(group.getGroupCode(),
                        group.getGroupCode() + " - " + group.getGroupName(),
                        group.isActive(),
                        group.getGroupName(),
                        group.getDescription()))
                .toList();
    }

    @GetMapping("/items")
    public List<LookupResponse> searchItems(@RequestParam("groupCode") String groupCode,
                                            @RequestParam(value = "query", required = false) String query,
                                            @RequestParam(value = "activeOnly", defaultValue = "false") boolean activeOnly) {
        return codeItemService.search(groupCode, query, activeOnly).stream()
                .map(item -> new LookupResponse(item.getCode(),
                        item.getCode() + " - " + item.getCodeLabel(),
                        item.isActive(),
                        item.getCodeLabel(),
                        null))
                .toList();
    }

    public record LookupResponse(String value, String label, boolean active, String name, String description) {
    }
}
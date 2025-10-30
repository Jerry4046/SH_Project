package com.project.SH.controller;

import com.project.SH.service.CodeGroupService;
import com.project.SH.service.CodeItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/codes")
@RequiredArgsConstructor
public class CodeManagementController {

    private final CodeGroupService codeGroupService;
    private final CodeItemService codeItemService;

    @GetMapping("/manage")
    public String view(Model model, @RequestParam(value = "groupFilter", required = false) String groupFilter) {
        model.addAttribute("codeGroups", codeGroupService.getAll());
        if (groupFilter != null && !groupFilter.isBlank()) {
            model.addAttribute("codeItems", codeItemService.search(groupFilter, null, false));
            model.addAttribute("selectedGroupFilter", groupFilter);
        } else {
            model.addAttribute("codeItems", codeItemService.getAll());
        }
        return "code-manage";
    }

    @PostMapping("/groups")
    public String saveGroup(@RequestParam("groupCode") String groupCode,
                            @RequestParam("groupName") String groupName,
                            @RequestParam(value = "description", required = false) String description,
                            @RequestParam(value = "active", defaultValue = "0") int active,
                            RedirectAttributes redirectAttributes) {
        try {
            codeGroupService.save(groupCode.trim(), groupName.trim(), description, active == 1);
            redirectAttributes.addFlashAttribute("message", "코드그룹이 저장되었습니다.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "코드그룹 저장 중 오류가 발생했습니다: " + ex.getMessage());
        }
        return "redirect:/codes/manage";
    }

    @PostMapping("/items")
    public String saveItem(@RequestParam("groupCode") String groupCode,
                           @RequestParam("code") String code,
                           @RequestParam("codeLabel") String codeLabel,
                           @RequestParam(value = "active", defaultValue = "0") int active,
                           RedirectAttributes redirectAttributes) {
        try {
            codeItemService.save(groupCode.trim(), code.trim(), codeLabel.trim(), active == 1);
            redirectAttributes.addFlashAttribute("message", "공통코드가 저장되었습니다.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "공통코드 저장 중 오류가 발생했습니다: " + ex.getMessage());
        }
        return "redirect:/codes/manage";
    }
}
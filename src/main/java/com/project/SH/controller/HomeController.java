package com.project.SH.controller;

import com.project.SH.config.CustomUserDetails;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest; // Jakarta EE로 수정


@Controller
public class HomeController {

    @GetMapping("/home")
    public String home(@AuthenticationPrincipal CustomUserDetails userDetails, Model model, HttpServletRequest request) {
        // 인증 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        String grade = userDetails.getUser().getGrade();

        // 세션에 정보 저장
        request.getSession().setAttribute("username", username);
        request.getSession().setAttribute("grade", grade);

        // 세션 정보를 모델에 추가 (옵션, 필요시 사용)
        model.addAttribute("username", username);
        model.addAttribute("grade", grade);

        return "home"; // 해당 페이지로 이동
    }
}


package com.project.SH.controller;

import com.project.SH.service.SignUpService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class SignUpController {

    private final SignUpService signupService;

    @GetMapping("/signup")
    public String showRegisterForm() {
        return "signup"; // signup.jsp
    }

    @PostMapping("/signup")
    public String registerUser(@RequestParam String name,
                               @RequestParam String password,
                               @RequestParam String grade,
                               Model model) {

        try {
            signupService.signup(name,password ,grade);
            model.addAttribute("message", "회원가입 성공!");
            return "login"; // 회원가입 후 로그인 페이지로 이동
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("error","회원가입 실패 Test");
            return "signup";
        }
    }

}

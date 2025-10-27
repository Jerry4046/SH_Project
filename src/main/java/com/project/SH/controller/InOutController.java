package com.project.SH.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class InOutController {

    @GetMapping("/inout")
    public String viewInOutPage() {
        return "inout";
    }
}
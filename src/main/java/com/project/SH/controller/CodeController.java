package com.project.SH.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;



@Controller
public class CodeController {

    @GetMapping("/productcode")
    public String showProductList(Model model) {

        return "productcode";  // /WEB-INF/views/inventory.jsp
    }

}
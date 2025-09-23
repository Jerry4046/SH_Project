package com.project.SH.controller;


import com.project.SH.domain.ProductCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class ClientController {

    @GetMapping("/client")
    public String showProductList(Model model) {

        return "client";  // /WEB-INF/views/Client.jsp
    }
}

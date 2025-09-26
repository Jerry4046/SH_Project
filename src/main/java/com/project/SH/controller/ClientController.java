package com.project.SH.controller;


import com.project.SH.service.ClientService;
import com.project.SH.service.ProductCodeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class ClientController {

    private final ProductCodeService productCodeService;
    private final ClientService clientService;

    @GetMapping("/client")
    public String showProductList(Model model) {
        model.addAttribute("companies", productCodeService.getCompanies());
        model.addAttribute("clients", clientService.getClients());
        return "client";  // /WEB-INF/views/Client.jsp
    }
}
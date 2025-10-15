package com.project.SH.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class FileCountMaxEnforcerFilter extends OncePerRequestFilter {

    private static final Long UNLIMITED = -1L;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    jakarta.servlet.http.HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {
        request.getServletContext().setAttribute(
                "org.apache.tomcat.util.http.fileupload.fileCountMax", UNLIMITED
        );
        // 옵션: 시스템 프로퍼티도 보강
        System.setProperty("org.apache.tomcat.util.http.fileupload.fileCountMax", "-1");
        chain.doFilter(request, response);
    }
}

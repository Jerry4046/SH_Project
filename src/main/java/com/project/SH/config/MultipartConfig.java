package com.project.SH.config;

import jakarta.servlet.ServletContext;
import org.apache.catalina.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.web.servlet.ServletContextInitializer;

@Configuration
@ConditionalOnClass(TomcatServletWebServerFactory.class)
public class MultipartConfig {
    private static final Logger log = LoggerFactory.getLogger(MultipartConfig.class);

    private static final String FILE_COUNT_MAX_ATTR =
            "org.apache.tomcat.util.http.fileupload.fileCountMax";

    @Value("${app.multipart.max-file-count:-1}")
    private long maxFileCount;

    @Bean
    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> tomcatFileCountCustomizer() {
        return factory -> factory.addContextCustomizers(context -> {
            ServletContext sc = context.getServletContext();
            sc.setAttribute(FILE_COUNT_MAX_ATTR, Long.valueOf(maxFileCount));
            log.info("Tomcat fileCountMax set (context customizer) = {}", maxFileCount);
        });
    }

    @Bean
    public ServletContextInitializer multipartAttrInitializer() {
        return sc -> {
            sc.setAttribute(FILE_COUNT_MAX_ATTR, Long.valueOf(maxFileCount));
            log.info("Tomcat fileCountMax set (servlet initializer) = {}", maxFileCount);
        };
    }
}

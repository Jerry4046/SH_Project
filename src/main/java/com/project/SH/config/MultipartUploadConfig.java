package com.project.SH.config;

import jakarta.servlet.MultipartConfigElement;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.unit.DataSize;

@Configuration
public class MultipartUploadConfig {

    private static final DataSize MAX_FILE_SIZE = DataSize.ofMegabytes(20);
    private static final DataSize MAX_REQUEST_SIZE = DataSize.ofMegabytes(40);

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        factory.setMaxFileSize(MAX_FILE_SIZE);
        factory.setMaxRequestSize(MAX_REQUEST_SIZE);
        return factory.createMultipartConfig();
    }

    @Bean
    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> multipartTomcatCustomizer() {
        return factory -> factory.addContextCustomizers(context -> {
            context.setAllowCasualMultipartParsing(true);
            context.setMaxFileCount(-1);
            context.setMaxFileSize(MAX_FILE_SIZE.toBytes());
            context.setMaxRequestSize(MAX_REQUEST_SIZE.toBytes());
        });
    }
}
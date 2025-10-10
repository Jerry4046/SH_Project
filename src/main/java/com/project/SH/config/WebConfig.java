package com.project.SH.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${app.media.base-directory}")
    private String mediaBaseDirectory;

    @Value("${app.media.url-prefix:/media}")
    private String mediaUrlPrefix;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path uploadPath = Paths.get(mediaBaseDirectory).toAbsolutePath().normalize();
        String resourceLocation = "file:" + uploadPath.toUri().getPath();

        registry.addResourceHandler(mediaUrlPrefix + "/**")
                .addResourceLocations(resourceLocation)
                .setCachePeriod(3600);
    }
}
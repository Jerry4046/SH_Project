package com.project.SH;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ShApplication {

    public static void main(String[] args) {
        // Tomcat이 뜨기 전, 가장 먼저 시스템 프로퍼티로 박아두기
        System.setProperty("org.apache.tomcat.util.http.fileupload.fileCountMax", "-1");

        SpringApplication.run(ShApplication.class, args);
    }

}

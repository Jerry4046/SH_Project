/*
package com.project.SH;

import com.project.SH.dao.UserDao;
import com.project.SH.domain.User;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class Test implements CommandLineRunner {

    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;

    public Test(UserDao userDao, PasswordEncoder passwordEncoder) {
        this.userDao = userDao;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) throws Exception {
        // admin 계정이 이미 존재하는지 확인

            User admin = User.builder()
                    .uuid(UUID.randomUUID().toString())
                    .name("admin1")
                    .password(passwordEncoder.encode("1234"))
                    .grade("A")
                    .situation(1)
                    .build();

            userDao.save(admin);
            System.out.println("✅ [admin] 계정이 초기화되었습니다.");

    }
}
*/

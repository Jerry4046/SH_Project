package com.project.SH.service;

import com.project.SH.dao.UserDao;
import com.project.SH.domain.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SignUpServiceImpl implements SignUpService {

    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void signup(String name, String rawPassword, String grade) {
        String encodedPassword = passwordEncoder.encode(rawPassword);
        User user = User.builder()
                .uuid(UUID.randomUUID().toString())
                .name(name)
                .password(encodedPassword)
                .grade(grade)
                .situation(1)
                .build();
        userDao.save(user);
    }
}

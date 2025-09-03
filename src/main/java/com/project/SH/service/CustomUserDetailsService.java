package com.project.SH.service;

import com.project.SH.dao.UserDao;
import com.project.SH.domain.User;
import com.project.SH.config.CustomUserDetails;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserDao userDao;

    public CustomUserDetailsService(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userDao.findByName(username);
        if (user == null) {
            throw new UsernameNotFoundException("사용자 없음: " + username);
        }
        return new CustomUserDetails(user);
    }
}

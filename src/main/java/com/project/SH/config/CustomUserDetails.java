package com.project.SH.config;

import com.project.SH.domain.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

public class CustomUserDetails implements UserDetails {

    private final User user;

    public CustomUserDetails(User user) {
        this.user = user;
    }

    @Override public Collection<? extends GrantedAuthority> getAuthorities() {
        // 등급이 A면 ROLE_ADMIN, 아니면 ROLE_USER 부여
        String role = user.getGrade().equals("A") ? "ROLE_ADMIN" : "ROLE_USER";
        return List.of(new SimpleGrantedAuthority(role));
        //return Collections.singleton(() -> user.getGrade()); // 권한 부여
    }

    @Override public String getPassword() { return user.getPassword(); }
    @Override public String getUsername() { return user.getName(); }

    @Override public boolean isAccountNonExpired() { return true; }
    @Override public boolean isAccountNonLocked() { return true; }
    @Override public boolean isCredentialsNonExpired() { return true; }
    @Override public boolean isEnabled() { return user.getSituation() == 1; }

    public User getUser() {
        return this.user;
    }

}

package com.project.SH.dao;

import com.project.SH.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserDao extends JpaRepository<User, Integer>{

    User findByName(String name);

}

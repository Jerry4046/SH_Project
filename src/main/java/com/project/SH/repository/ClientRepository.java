package com.project.SH.repository;

import com.project.SH.domain.Client;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClientRepository extends JpaRepository<Client, Long> {

    @EntityGraph(attributePaths = "company")
    List<Client> findAllByOrderByCreatedAtDesc();
}
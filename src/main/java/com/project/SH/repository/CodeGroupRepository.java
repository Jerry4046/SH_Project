package com.project.SH.repository;

import com.project.SH.domain.CodeGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CodeGroupRepository extends JpaRepository<CodeGroup, String> {

    @Query("""
            select cg from CodeGroup cg
            where (:activeOnly = false or cg.active = true)
              and ((:query is null)
                   or lower(cg.groupCode) like lower(concat('%', :query, '%'))
                   or lower(cg.groupName) like lower(concat('%', :query, '%')))
            order by cg.groupCode asc
            """)
    List<CodeGroup> search(@Param("query") String query, @Param("activeOnly") boolean activeOnly);
}
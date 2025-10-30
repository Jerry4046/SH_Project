package com.project.SH.repository;

import com.project.SH.domain.CodeItem;
import com.project.SH.domain.CodeItemId;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CodeItemRepository extends JpaRepository<CodeItem, CodeItemId> {

    @Query("""
            select ci from CodeItem ci
            join fetch ci.group cg
            where cg.groupCode = :groupCode
              and (:activeOnly = false or ci.active = true)
              and ((:query is null)
                   or lower(ci.id.code) like lower(concat('%', :query, '%'))
                   or lower(ci.codeLabel) like lower(concat('%', :query, '%')))
            order by ci.id.code asc
            """)
    List<CodeItem> search(@Param("groupCode") String groupCode,
                          @Param("query") String query,
                          @Param("activeOnly") boolean activeOnly);

    @EntityGraph(attributePaths = "group")
    @Query("select ci from CodeItem ci")
    List<CodeItem> findAllWithGroup();
}
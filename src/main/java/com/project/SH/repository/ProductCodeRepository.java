package com.project.SH.repository;

import com.project.SH.domain.ProductCode;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ProductCodeRepository extends JpaRepository<ProductCode, Long> {
    Optional<ProductCode> findByCompanyInitialAndTypeCodeAndCategoryCode(String companyInitial,
                                                                         String typeCode,
                                                                         String categoryCode);
    // For loading type names per company (category_code = '0000')
    List<ProductCode> findByCompanyInitialAndCategoryCode(String companyInitial, String categoryCode);

    // For loading category names under a type
    List<ProductCode> findByCompanyInitialAndTypeCodeAndCategoryCodeNot(String companyInitial,
                                                                        String typeCode,
                                                                        String categoryCode);

    // For loading all company names (type_code = '0000', category_code = '0000')
    List<ProductCode> findByTypeCodeAndCategoryCode(String typeCode, String categoryCode);

    // For global name maps
    List<ProductCode> findByCategoryCode(String categoryCode);

    List<ProductCode> findByCategoryCodeNot(String categoryCode);
}
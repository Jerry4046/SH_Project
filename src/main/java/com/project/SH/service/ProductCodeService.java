package com.project.SH.service;

import com.project.SH.domain.CategoryCode;
import com.project.SH.domain.CompanyCode;
import com.project.SH.domain.Product;
import com.project.SH.domain.ProductCode;
import com.project.SH.domain.TypeCode;
import com.project.SH.dto.NextItemCodeResponse;
import com.project.SH.repository.CategoryCodeRepository;
import com.project.SH.repository.CompanyCodeRepository;
import com.project.SH.repository.ProductCodeRepository;
import com.project.SH.repository.ProductRepository;
import com.project.SH.repository.TypeCodeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProductCodeService implements ProductCodeServiceImpl {

    private static final String ROOT_CODE = "0000";
    private static final int ITEM_CODE_LENGTH = 4;

    private final ProductCodeRepository productCodeRepository;
    private final CompanyCodeRepository companyCodeRepository;
    private final TypeCodeRepository typeCodeRepository;
    private final CategoryCodeRepository categoryCodeRepository;
    private final ProductRepository productRepository;

    @Override
    public List<ProductCode> getAllProductCodes() {
        return productCodeRepository.findAll();
    }

    @Override
    public ProductCode createProductCode(String companyCode, String typeCode, String categoryCode, String description) {
        final String normalizedDescription = description != null ? description.trim() : null;
        final boolean isCompanyLevel = ROOT_CODE.equals(typeCode) && ROOT_CODE.equals(categoryCode);
        final boolean isTypeLevel = !ROOT_CODE.equals(typeCode) && ROOT_CODE.equals(categoryCode);
        final boolean isCategoryLevel = !ROOT_CODE.equals(typeCode) && !ROOT_CODE.equals(categoryCode);

        ensureTypeCode(ROOT_CODE, null);
        ensureCategoryCode(ROOT_CODE, null);

        final String resolvedDescription;
        if (isCompanyLevel) {
            resolvedDescription = resolveName(normalizedDescription, companyCode);
        } else if (isTypeLevel) {
            resolvedDescription = resolveName(normalizedDescription, typeCode);
        } else if (isCategoryLevel) {
            resolvedDescription = resolveName(normalizedDescription, categoryCode);
        } else {
            resolvedDescription = normalizedDescription;
        }

        if (isCompanyLevel) {
            companyCodeRepository.findById(companyCode)
                    .map(existing -> {
                        if (normalizedDescription != null && !normalizedDescription.isBlank()
                                && !normalizedDescription.equals(existing.getCompanyName())) {
                            existing.setCompanyName(normalizedDescription);
                            return companyCodeRepository.save(existing);
                        }
                        return existing;
                    })
                    .orElseGet(() -> companyCodeRepository.save(CompanyCode.builder()
                            .companyCode(companyCode)
                            .companyName(resolvedDescription)
                            .build()));
        } else {
            companyCodeRepository.findById(companyCode)
                    .orElseThrow(() -> new IllegalArgumentException("등록되지 않은 회사 코드입니다."));
        }

        if (isTypeLevel) {
            ensureTypeCode(typeCode, normalizedDescription);
        } else if (!ROOT_CODE.equals(typeCode)) {
            ensureTypeCode(typeCode, null);
        }

        if (isCategoryLevel) {
            ensureCategoryCode(categoryCode, normalizedDescription);
        }

        return productCodeRepository
                .findByCompanyCodeAndTypeCodeAndCategoryCode(companyCode, typeCode, categoryCode)
                .map(existing -> updateDescriptionIfNeeded(existing, normalizedDescription))
                .orElseGet(() -> productCodeRepository.save(ProductCode.builder()
                        .companyCode(companyCode)
                        .typeCode(typeCode)
                        .categoryCode(categoryCode)
                        .description(resolvedDescription)
                        .build()));
    }

    private ProductCode updateDescriptionIfNeeded(ProductCode code, String description) {
        if (description != null && !description.isBlank() && !description.equals(code.getDescription())) {
            code.setDescription(description);
            return productCodeRepository.save(code);
        }
        return code;
    }

    private void ensureTypeCode(String typeCode, String description) {
        final String resolvedName = resolveName(description, typeCode);
        typeCodeRepository.findById(typeCode)
                .map(existing -> {
                    if (description != null && !description.isBlank() && !resolvedName.equals(existing.getTypeName())) {
                        existing.setTypeName(resolvedName);
                        return typeCodeRepository.save(existing);
                    }
                    return existing;
                })
                .orElseGet(() -> typeCodeRepository.save(TypeCode.builder()
                        .typeCode(typeCode)
                        .typeName(resolvedName)
                        .build()));
    }

    private void ensureCategoryCode(String categoryCode, String description) {
        final String resolvedName = resolveName(description, categoryCode);
        categoryCodeRepository.findById(categoryCode)
                .map(existing -> {
                    if (description != null && !description.isBlank() && !resolvedName.equals(existing.getCategoryName())) {
                        existing.setCategoryName(resolvedName);
                        return categoryCodeRepository.save(existing);
                    }
                    return existing;
                })
                .orElseGet(() -> categoryCodeRepository.save(CategoryCode.builder()
                        .categoryCode(categoryCode)
                        .categoryName(resolvedName)
                        .build()));
    }

    private String resolveName(String candidate, String fallback) {
        return candidate != null && !candidate.isBlank() ? candidate : fallback;
    }

    @Override
    public List<CompanyCode> getCompanies() {
        // DB가 반환한 회사 코드를 이름순으로 정렬해서 전달
        // (값이 비어 보이는 문제를 줄이기 위해 명시적으로 정렬 사용)
        return companyCodeRepository.findAll(org.springframework.data.domain.Sort.by("companyName"));
    }

    @Override
    public List<ProductCode> getTypesByCompanyCode(String companyCode) {
        return productCodeRepository.findByCompanyCodeAndCategoryCode(companyCode, ROOT_CODE);
    }

    @Override
    public List<ProductCode> getCategoriesByCompanyCodeAndTypeCode(String companyCode, String typeCode) {
        return productCodeRepository.findByCompanyCodeAndTypeCodeAndCategoryCodeNot(companyCode, typeCode, ROOT_CODE);
    }

    @Override
    public Map<String, String> getCompanyNameMap() {
        List<CompanyCode> companies = getCompanies();
        Map<String, String> map = new LinkedHashMap<>();
        for (CompanyCode c : companies) {
            map.putIfAbsent(c.getCompanyCode(), c.getCompanyName());
        }
        return map;
    }

    @Override
    public Map<String, String> getTypeNameMap() {
        List<ProductCode> types = productCodeRepository.findByCategoryCode(ROOT_CODE);
        Map<String, String> map = new LinkedHashMap<>();
        for (ProductCode t : types) {
            if (!ROOT_CODE.equals(t.getTypeCode())) {
                map.putIfAbsent(t.getTypeCode(), t.getDescription());
            }
        }
        return map;
    }

    @Override
    public Map<String, String> getCategoryNameMap() {
        List<ProductCode> categories = productCodeRepository.findByCategoryCodeNot(ROOT_CODE);
        Map<String, String> map = new LinkedHashMap<>();
        for (ProductCode cat : categories) {
            map.putIfAbsent(cat.getCategoryCode(), cat.getDescription());
        }
        return map;
    }

    @Override
    public String getNextItemCodeForBase(String productCode) {
        final String base = requireCode(productCode, "제품 코드");
        return formatItemCode(determineNextValue(base));
    }

    public String getNextItemCode(String companyCode, String typeCode, String categoryCode) {
        final String base = buildBaseProductCode(companyCode, typeCode, categoryCode);
        return formatItemCode(determineNextValue(base));
    }

    @Override
    public NextItemCodeResponse previewNextItemCode(String companyCode, String typeCode, String categoryCode) {
        final String base = buildBaseProductCode(companyCode, typeCode, categoryCode);
        final String itemCode = formatItemCode(determineNextValue(base));
        return new NextItemCodeResponse(base, itemCode, buildFullProductCode(base, itemCode));
    }

    @Override
    public String buildFullProductCode(String productCode, String itemCode) {
        final String base = requireCode(productCode, "제품 코드");
        final String item = itemCode != null ? itemCode.trim() : "";
        if (item.isEmpty()) {
            return base;
        }
        return base + "_" + item;
    }

    private String buildBaseProductCode(String companyCode, String typeCode, String categoryCode) {
        final String company = requireCode(companyCode, "회사 코드");
        final String type = requireCode(typeCode, "타입 코드");
        final String category = requireCode(categoryCode, "카테고리 코드");
        return String.join("_", company, type, category);
    }

    private int determineNextValue(String baseProductCode) {
        final String prefix = baseProductCode + "_";

        final int lastFromFullCode = productRepository.findTopByProductCodeStartingWith(prefix)
                .map(Product::getProductCode)
                .map(code -> extractSuffixValue(code, prefix))
                .orElse(0);

        final int lastFromLegacy = productRepository.findTopByProductCodeOrderByItemCodeDesc(baseProductCode)
                .map(Product::getItemCode)
                .map(this::parseItemCode)
                .orElse(0);

        return Math.max(lastFromFullCode, lastFromLegacy) + 1;
    }

    private int extractSuffixValue(String productCode, String prefix) {
        if (productCode == null || prefix == null) {
            return 0;
        }
        if (!productCode.startsWith(prefix)) {
            return 0;
        }
        final String suffix = productCode.substring(prefix.length());
        return parseItemCode(suffix);
    }

    private int parseItemCode(String value) {
        if (value == null) {
            return 0;
        }
        final String digits = value.replaceAll("\\D", "");
        if (digits.isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(digits);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    private String formatItemCode(int value) {
        return String.format("%0" + ITEM_CODE_LENGTH + "d", Math.max(value, 0));
    }

    private String requireCode(String value, String label) {
        final String trimmed = value != null ? value.trim() : "";
        if (trimmed.isEmpty()) {
            throw new IllegalArgumentException(label + "는 필수입니다.");
        }
        return trimmed;
    }
}
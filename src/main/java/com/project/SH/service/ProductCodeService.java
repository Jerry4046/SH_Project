package com.project.SH.service;

import com.project.SH.domain.CodeItem;
import com.project.SH.domain.CodeItemId;
import com.project.SH.domain.CompanyCode;
import com.project.SH.domain.Product;
import com.project.SH.domain.ProductCode;
import com.project.SH.dto.NextItemCodeResponse;
import com.project.SH.repository.CodeItemRepository;
import com.project.SH.repository.ProductCodeRepository;
import com.project.SH.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProductCodeService implements ProductCodeServiceImpl {

    private static final String ROOT_CODE = "0000";
    private static final int ITEM_CODE_LENGTH = 4;
    private static final String COMPANY_CODE_GROUP = "PD_CP";
    private static final String TYPE_CODE_GROUP = "PD_TY";
    private static final String CATEGORY_CODE_GROUP = "PD_CT";

    private final ProductCodeRepository productCodeRepository;
    private final CodeItemRepository codeItemRepository;
    private final ProductRepository productRepository;

    @Override
    public List<ProductCode> getAllProductCodes() {
        return productCodeRepository.findAll();
    }

    @Override
    @Transactional
    public ProductCode createProductCode(String companyCode, String typeCode, String categoryCode, String description) {
        final String normalizedDescription = description != null ? description.trim() : null;
        final boolean isCompanyLevel = ROOT_CODE.equals(typeCode) && ROOT_CODE.equals(categoryCode);
        final boolean isTypeLevel = !ROOT_CODE.equals(typeCode) && ROOT_CODE.equals(categoryCode);
        final boolean isCategoryLevel = !ROOT_CODE.equals(typeCode) && !ROOT_CODE.equals(categoryCode);

        CodeItem company = requireCodeItem(COMPANY_CODE_GROUP, companyCode);
        CodeItem type = isCompanyLevel || ROOT_CODE.equals(typeCode)
                ? null
                : requireCodeItem(TYPE_CODE_GROUP, typeCode);
        CodeItem category = isCategoryLevel
                ? requireCodeItem(CATEGORY_CODE_GROUP, categoryCode)
                : null;

        final String resolvedDescription = resolveDescription(normalizedDescription, company, type, category,
                isCompanyLevel, isTypeLevel, isCategoryLevel);

        return ProductCode.builder()
                .companyCode(companyCode)
                .typeCode(typeCode)
                .categoryCode(categoryCode)
                .description(resolvedDescription)
                .build();
    }


    private String resolveDescription(String candidate, CodeItem company, CodeItem type, CodeItem category,
                                      boolean isCompanyLevel, boolean isTypeLevel, boolean isCategoryLevel) {
        if (candidate != null && !candidate.isBlank()) {
            return candidate;
        }
        if (isCategoryLevel && category != null) {
            return category.getCodeLabel();
        }
        if (isTypeLevel && type != null) {
            return type.getCodeLabel();
        }
        if (isCompanyLevel && company != null) {
            return company.getCodeLabel();
        }
        if (category != null) {
            return category.getCode();
        }
        if (type != null) {
            return type.getCode();
        }
        return company != null ? company.getCode() : candidate;
    }

    @Override
    public List<CompanyCode> getCompanies() {
        return codeItemRepository.search(COMPANY_CODE_GROUP, null, true)
                .stream()
                .map(item -> CompanyCode.builder()
                        .companyCode(item.getCode())
                        .companyName(item.getCodeLabel())
                        .build())
                .toList();
    }

    @Override
    public List<ProductCode> getTypesByCompanyCode(String companyCode) {
        List<ProductCode> productCodes = productCodeRepository.findByCompanyCodeAndCategoryCode(companyCode, ROOT_CODE);
        synchronizeDescriptions(productCodes, TYPE_CODE_GROUP);
        return productCodes;
    }

    @Override
    public List<ProductCode> getCategoriesByCompanyCodeAndTypeCode(String companyCode, String typeCode) {
        List<ProductCode> productCodes = productCodeRepository
                .findByCompanyCodeAndTypeCodeAndCategoryCodeNot(companyCode, typeCode, ROOT_CODE);
        synchronizeDescriptions(productCodes, CATEGORY_CODE_GROUP);
        return productCodes;
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
        List<CodeItem> types = codeItemRepository.search(TYPE_CODE_GROUP, null, true);
        Map<String, String> map = new LinkedHashMap<>();
        for (CodeItem t : types) {
            if (!ROOT_CODE.equals(t.getCode())) {
                map.putIfAbsent(t.getCode(), t.getCodeLabel());
            }
        }
        return map;
    }

    @Override
    public Map<String, String> getCategoryNameMap() {
        List<CodeItem> categories = codeItemRepository.search(CATEGORY_CODE_GROUP, null, true);
        Map<String, String> map = new LinkedHashMap<>();
        for (CodeItem cat : categories) {
            map.putIfAbsent(cat.getCode(), cat.getCodeLabel());
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


    private CodeItem requireCodeItem(String groupCode, String code) {
        final String resolvedCode = requireCode(code, "코드");
        return codeItemRepository.findById(new CodeItemId(groupCode, resolvedCode))
                .filter(CodeItem::isActive)
                .orElseThrow(() -> new IllegalArgumentException("등록되지 않은 코드입니다. 그룹: " + groupCode + ", 코드: " + resolvedCode));
    }

    private void synchronizeDescriptions(List<ProductCode> productCodes, String groupCode) {
        if (productCodes == null || productCodes.isEmpty()) {
            return;
        }
        Map<String, String> labelMap = buildLabelMap(groupCode);
        for (ProductCode code : productCodes) {
            if (code == null) {
                continue;
            }
            final String key = CATEGORY_CODE_GROUP.equals(groupCode) ? code.getCategoryCode() : code.getTypeCode();
            if (key == null) {
                continue;
            }
            String label = labelMap.get(key);
            if (label != null && (code.getDescription() == null || !code.getDescription().equals(label))) {
                code.setDescription(label);
            }
        }
    }

    private Map<String, String> buildLabelMap(String groupCode) {
        List<CodeItem> items = codeItemRepository.search(groupCode, null, true);
        Map<String, String> map = new LinkedHashMap<>();
        for (CodeItem item : items) {
            map.put(item.getCode(), item.getCodeLabel());
        }
        return map;
    }
}
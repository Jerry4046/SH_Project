package com.project.SH.util;

import java.util.Map;

public class CodeNameMapper {
    private static final Map<String, String> COMPANY_NAMES = Map.of(
            "SE", "서울우유",
            "DO", "동원"
    );

    private static final Map<String, String> TYPE_NAMES = Map.of(
            "0001", "종이"

    );

    private static final Map<String, String> CATEGORY_NAMES = Map.of(
            "0001", "띠지"
    );

    public static Map<String, String> getCompanyNames() {
        return COMPANY_NAMES;
    }

    public static Map<String, String> getTypeNames() {
        return TYPE_NAMES;
    }

    public static Map<String, String> getCategoryNames() {
        return CATEGORY_NAMES;
    }
}
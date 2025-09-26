package com.project.SH.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record CreateClientRequest(
        @NotBlank(message = "회사 코드를 선택하세요.")
        @Size(max = 10, message = "회사 코드는 10자리 이하여야 합니다.")
        String companyCode,

        @Size(max = 100, message = "지점명은 100자 이하여야 합니다.")
        String branchName,

        @Size(max = 100, message = "대리점명은 100자 이하여야 합니다.")
        String agencyName,

        @Size(max = 255, message = "주소는 255자 이하여야 합니다.")
        String address,

        @NotBlank(message = "담당자 성함을 입력하세요.")
        @Size(max = 50, message = "담당자 성함은 50자 이하여야 합니다.")
        String managerName,

        @NotBlank(message = "전화번호를 입력하세요.")
        @Size(max = 20, message = "전화번호는 20자 이하여야 합니다.")
        @Pattern(regexp = "[0-9\\-]+", message = "전화번호는 숫자와 하이픈만 입력 가능합니다.")
        String managerPhone
) {
}
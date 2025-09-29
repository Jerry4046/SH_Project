package com.project.SH.dto;

import com.project.SH.domain.Client;

import java.time.LocalDateTime;

public class ClientResponse {

    private final Long clientId;
    private final String clientCode;
    private final String companyCode;
    private final String companyName;
    private final String branchName;
    private final String agencyName;
    private final String address;
    private final String managerName;
    private final String regionalPhone;
    private final String managerPhone;
    private final LocalDateTime createdAt;
    private final LocalDateTime updatedAt;

    public ClientResponse(Long clientId,
                          String clientCode,
                          String companyCode,
                          String companyName,
                          String branchName,
                          String agencyName,
                          String address,
                          String managerName,
                          String regionalPhone,
                          String managerPhone,
                          LocalDateTime createdAt,
                          LocalDateTime updatedAt) {
        this.clientId = clientId;
        this.clientCode = clientCode;
        this.companyCode = companyCode;
        this.companyName = companyName;
        this.branchName = branchName;
        this.agencyName = agencyName;
        this.address = address;
        this.managerName = managerName;
        this.regionalPhone = regionalPhone;
        this.managerPhone = managerPhone;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public static ClientResponse from(Client client) {
        return new ClientResponse(
                client.getClientId(),
                client.getClientCode(),
                client.getCompany().getCompanyCode(),
                client.getCompany().getCompanyName(),
                client.getBranchName(),
                client.getAgencyName(),
                client.getAddress(),
                client.getManagerName(),
                formatPhoneNumber(client.getRegionalPhone()),
                formatPhoneNumber(client.getManagerPhone()),
                client.getCreatedAt(),
                client.getUpdatedAt()
        );
    }

    private static String formatPhoneNumber(String raw) {
        if (raw == null) {
            return null;
        }

        String digits = raw.replaceAll("\\D", "");
        if (digits.isEmpty()) {
            return null;
        }

        if (digits.startsWith("02")) {
            if (digits.length() == 9) {
                return String.format("%s-%s-%s", digits.substring(0, 2), digits.substring(2, 5), digits.substring(5));
            }
            if (digits.length() == 10) {
                return String.format("%s-%s-%s", digits.substring(0, 2), digits.substring(2, 6), digits.substring(6));
            }
            if (digits.length() > 2) {
                int middleLength = digits.length() - 2 - 4;
                middleLength = Math.max(2, middleLength);
                int middleEnd = 2 + middleLength;
                return String.format("%s-%s-%s", digits.substring(0, 2), digits.substring(2, middleEnd), digits.substring(middleEnd));
            }
            return digits;
        }

        if (digits.length() == 11) {
            return String.format("%s-%s-%s", digits.substring(0, 3), digits.substring(3, 7), digits.substring(7));
        }
        if (digits.length() == 10) {
            return String.format("%s-%s-%s", digits.substring(0, 3), digits.substring(3, 6), digits.substring(6));
        }
        if (digits.length() == 8) {
            return String.format("%s-%s", digits.substring(0, 4), digits.substring(4));
        }
        if (digits.length() == 7) {
            return String.format("%s-%s", digits.substring(0, 3), digits.substring(3));
        }

        return digits;
    }

    public Long getClientId() {
        return clientId;
    }

    public String getClientCode() {
        return clientCode;
    }

    public String getCompanyCode() {
        return companyCode;
    }

    public String getCompanyName() {
        return companyName;
    }

    public String getBranchName() {
        return branchName;
    }

    public String getAgencyName() {
        return agencyName;
    }

    public String getAddress() {
        return address;
    }

    public String getManagerName() {
        return managerName;
    }

    public String getRegionalPhone() {
        return regionalPhone;
    }

    public String getManagerPhone() {
        return managerPhone;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}
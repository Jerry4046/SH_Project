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
                client.getManagerPhone(),
                client.getCreatedAt(),
                client.getUpdatedAt()
        );
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
package com.project.SH.service;

import com.project.SH.domain.Client;
import com.project.SH.domain.CompanyCode;
import com.project.SH.dto.ClientResponse;
import com.project.SH.dto.CreateClientRequest;
import com.project.SH.repository.ClientRepository;
import com.project.SH.repository.CompanyCodeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClientService {

    private final ClientRepository clientRepository;
    private final CompanyCodeRepository companyCodeRepository;

    @Transactional
    public ClientResponse createClient(CreateClientRequest request) {
        CompanyCode company = companyCodeRepository.findById(request.companyCode())
                .orElseThrow(() -> new IllegalArgumentException("등록되지 않은 회사 코드입니다."));

        Client client = Client.builder()
                .company(company)
                .managerName(request.managerName().trim())
                .branchName(trimToNull(request.branchName()))
                .agencyName(trimToNull(request.agencyName()))
                .address(trimToNull(request.address()))
                .regionalPhone(normalizePhoneNumber(request.regionalPhone()))
                .managerPhone(requirePhoneNumber(request.managerPhone()))
                .build();

        return ClientResponse.from(clientRepository.save(client));
    }

    @Transactional(readOnly = true)
    public List<ClientResponse> getClients() {
        return clientRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(ClientResponse::from)
                .toList();
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String normalizePhoneNumber(String phone) {
        if (phone == null) {
            return null;
        }
        String digits = phone.replaceAll("\\D", "");
        return digits.isEmpty() ? null : digits;
    }

    private String requirePhoneNumber(String phone) {
        String normalized = normalizePhoneNumber(phone);
        if (normalized == null) {
            throw new IllegalArgumentException("전화번호는 숫자를 포함해야 합니다.");
        }
        return normalized;
    }
}
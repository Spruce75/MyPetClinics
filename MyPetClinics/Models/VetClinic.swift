//
//  VetClinicsData.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 13.6.2025.
//

import Foundation

struct VetClinic: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let postalCode: String
    let city: String
    let country: String
    let websiteURL: URL
    let phoneNumber: String
    let email: String
    let rating: Int        // 0…5
    let emergencyInfo: String?
    var isBookmarked: Bool
}

extension VetClinic {
    /// Мок-данные
    static let mockData: [VetClinic] = [
        VetClinic(
            id: UUID(),
            name: "Eläinlääkäriasema Status Oy",
            address: "Pyynikintori 8",
            postalCode: "33230",
            city: "Tampere",
            country: "Finland",
            websiteURL: URL(string: "http://elainlaakariasemastatus.fi/")!,
            phoneNumber: "060092110",
            email: "info@elainlaakariasemastatus.fi",
            rating: 3,
            emergencyInfo: "24/7 – emergency services",
            isBookmarked: false
        )
    ]
}

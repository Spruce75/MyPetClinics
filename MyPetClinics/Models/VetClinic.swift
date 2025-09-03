//
//  VetClinicsData.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 13.6.2025.
//

//import Foundation
//
//struct VetClinic: Identifiable {
//    let id: UUID = UUID()
//    let name: String
//    let address: String
//    let postalCode: String
//    let city: String
//    let country: String
//    let websiteURL: URL
//    let phoneNumber: String
//    let email: String
//    let rating: Int
//    let emergencyInfo: String?
//    let description: String
//    let pricesText: String
//    
//    let instagramURL: URL?
//    let facebookURL: URL?
//    
//    let staff: [StaffMember]
//    let clinicPhotos: [String]?
//    
//    var isBookmarked: Bool
//}

import Foundation

struct VetClinic: Identifiable {
    let id: UUID = UUID()
    let name: String
    let address: String
    let postalCode: String
    let city: String
    let country: String
    let websiteURL: URL
    let phoneNumber: String
    let email: String
    let rating: Int
    let emergencyInfo: String?
    let description: String
    let pricesText: String
    
    let instagramURL: URL?
    let facebookURL: URL?
    
    let staff: [StaffMember]
    let clinicPhotos: [String]?
    
    let type: String
    let onlineConsultationAvailable: Bool
    
    var isBookmarked: Bool
    
    let latitude: Double
    let longitude: Double
}

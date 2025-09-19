//
//  VaccinationDetails.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 18.9.2025.
//

import UIKit

struct VaccinationDetails {
    let id: UUID
    let petId: UUID
    let title: String
    let dateGiven: Date?
    let createdAt: Date
    let notes: String?
    let imageData: Data?
    
    let imagesData: [Data]?
}

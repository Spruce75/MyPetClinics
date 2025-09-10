//
//  PetProfile.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import Foundation

// MARK: - Enums

enum PetSex: String, CaseIterable {
    case male
    case female

    var localizedTitle: String {
        switch self {
        case .male:   return String(localized: "male_title", defaultValue: "Male")
        case .female: return String(localized: "female_title", defaultValue: "Female")
        }
    }
}

enum PetIdentificationType: String, CaseIterable {
    case none
    case microchip
    case tattoo

    var localizedTitle: String {
        switch self {
        case .none:      return String(localized: "ident_none_title", defaultValue: "None")
        case .microchip: return String(localized: "ident_microchip_title", defaultValue: "Microchip")
        case .tattoo:    return String(localized: "ident_tattoo_title", defaultValue: "Tattoo")
        }
    }
}

enum PetSpecies: Equatable {
    case cat
    case dog
    case other(String)

    var localizedTitle: String {
        switch self {
        case .cat: return String(localized: "cat_title", defaultValue: "Cat")
        case .dog: return String(localized: "dog_title", defaultValue: "Dog")
        case .other(let custom):
            return custom.isEmpty
                ? String(localized: "other_title", defaultValue: "Other")
                : custom
        }
    }
}

// MARK: - Domain

struct PetProfile {
    let id: UUID
    var name: String
    var fullName: String?

    var sex: PetSex?
    var species: PetSpecies

    var breed: String?
    var colorMarkings: String?

    var dateOfBirth: Date?
    var weightInKilograms: Double?

    var identificationType: PetIdentificationType
    var identificationNumber: String?

    var avatarImageData: Data?
    var avatarFileName: String?

    let createdAt: Date
    var updatedAt: Date
    
    var owners: [PetOwner] = []
}

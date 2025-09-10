//
//  PetProfileFormData.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import Foundation

/// Входные данные от формы создания/редактирования.
struct PetProfileFormData {
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
    
    var owners: [PetOwnerFormData] = []
}

extension PetProfileFormData {
    init(from profile: PetProfile) {
        self.init(
            name: profile.name,
            fullName: profile.fullName,
            sex: profile.sex,
            species: profile.species,
            breed: profile.breed,
            colorMarkings: profile.colorMarkings,
            dateOfBirth: profile.dateOfBirth,
            weightInKilograms: profile.weightInKilograms,
            identificationType: profile.identificationType,
            identificationNumber: profile.identificationNumber,
            avatarImageData: profile.avatarImageData,
            avatarFileName: profile.avatarFileName
        )
        let converted = profile.owners.map {
            PetOwnerFormData(fullName: $0.fullName, address: $0.address, contactDetails: $0.contactDetails)
        }
        self.owners = converted + Array(repeating: PetOwnerFormData(), count: max(0, 3 - converted.count))

//        self.owners = profile.owners.map {
//            PetOwnerFormData(fullName: $0.fullName, address: $0.address, contactDetails: $0.contactDetails)
//        }
    }
}

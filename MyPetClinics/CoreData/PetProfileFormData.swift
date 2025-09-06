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
    }
}

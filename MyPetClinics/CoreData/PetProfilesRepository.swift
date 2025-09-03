//
//  PetProfilesRepository.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import Foundation

protocol PetProfilesRepository {
    @discardableResult
    func create(from formData: PetProfileFormData,
                avatarFileName: String?) throws -> PetProfile

    func fetchAll() throws -> [PetProfile]
    func update(_ profile: PetProfile) throws
    func delete(id: UUID) throws
}

enum PetProfilesError: Error {
    case notFound
    case saveFailed(Error)
    case fetchFailed(Error)
    case deleteFailed(Error)
}


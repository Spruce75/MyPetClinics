//
//  PetProfileCoreData+Mapper.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import Foundation
import CoreData

// MARK: - Кодирование/декодирование species

private enum SpeciesCoding {
    static func encode(_ value: PetSpecies) -> String {
        switch value {
        case .cat: return "cat"
        case .dog: return "dog"
        case .other(let custom): return "other:\(custom)"
        }
    }
    
    static func decode(_ raw: String) -> PetSpecies {
        if raw == "cat" { return .cat }
        if raw == "dog" { return .dog }
        if raw.hasPrefix("other:") {
            let custom = String(raw.dropFirst("other:".count))
            return .other(custom)
        }
        return .other(raw) // на всякий
    }
}

extension PetProfileCoreData {
    
    // MARK: - Удобный мост для Optional Double (когда Use Scalar Type = OFF)
    var weightInKilogramsValue: Double? {
        get { weightInKilograms?.doubleValue }
        set { weightInKilograms = newValue.map(NSNumber.init) }
    }
    
    // MARK: - CoreData -> Domain (мягкая)
    func asDomain() -> PetProfile? {
        guard
            let name = name,
            let speciesRaw = species,
            let identificationTypeRaw = identificationType,
            let createdAt = createdAt,
            let updatedAt = updatedAt
        else { return nil }
        
        return PetProfile(
            id: id ?? UUID(),
            name: name,
            fullName: fullName,
            sex: sex.flatMap(PetSex.init(rawValue:)),
            species: SpeciesCoding.decode(speciesRaw),
            breed: breed,
            colorMarkings: colorMarkings,
            dateOfBirth: dateOfBirth,
            weightInKilograms: weightInKilogramsValue,
            identificationType: PetIdentificationType(rawValue: identificationTypeRaw) ?? .none,
            identificationNumber: identificationNumber,
            avatarFileName: avatarFileName,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
    // MARK: - CoreData -> Domain (жёсткая)
    /// Возвращает не-опциональный доменный объект.
    /// Если обязательных полей нет, в Debug упадёт assertion и будет возвращён "защитный" объект.
    func toDomain(
        file: StaticString = #file,
        line: UInt = #line
    ) -> PetProfile {
        guard let domain = asDomain() else {
            assertionFailure("PetProfileCoreData corrupted: required attributes are nil", file: file, line: line)
            // Защитные значения — чтобы UI не крэшился в релизе
            return PetProfile(
                id: id ?? UUID(),
                name: name ?? "—",
                fullName: fullName,
                sex: sex.flatMap(PetSex.init(rawValue:)),
                species: species.map(SpeciesCoding.decode) ?? .other("Unknown"),
                breed: breed,
                colorMarkings: colorMarkings,
                dateOfBirth: dateOfBirth,
                weightInKilograms: weightInKilogramsValue,
                identificationType: identificationType.flatMap(PetIdentificationType.init(rawValue:)) ?? .none,
                identificationNumber: identificationNumber,
                avatarFileName: avatarFileName,
                createdAt: createdAt ?? Date(),
                updatedAt: updatedAt ?? Date()
            )
        }
        return domain
    }
    
    // MARK: - Domain -> CoreData
    func apply(from domain: PetProfile) {
        id = domain.id
        name = domain.name
        fullName = domain.fullName
        sex = domain.sex?.rawValue
        species = SpeciesCoding.encode(domain.species)
        breed = domain.breed
        colorMarkings = domain.colorMarkings
        dateOfBirth = domain.dateOfBirth
        weightInKilogramsValue = domain.weightInKilograms
        identificationType = domain.identificationType.rawValue
        identificationNumber = domain.identificationNumber
        avatarFileName = domain.avatarFileName
        createdAt = domain.createdAt
        updatedAt = domain.updatedAt
    }
}

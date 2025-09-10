//
//  PetOwnerFormData.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 8.9.2025.
//

// PetOwnerFormData.swift
import Foundation

/// Данные одного владельца, которые заполняются в форме.
struct PetOwnerFormData {
    var fullName: String?
    var address: String?
    var contactDetails: String?
}

extension PetOwnerFormData {
    /// Полностью пустой слот (ничего не введено).
    var isEmpty: Bool {
        (fullName?.nilIfBlank == nil)
        && (address?.nilIfBlank == nil)
        && (contactDetails?.nilIfBlank == nil)
    }
}

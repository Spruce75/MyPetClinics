//
//  OwnersViewController + Bridges.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 8.9.2025.
//

// OwnersViewController + Bridges.swift
import Foundation

extension OwnersViewController.OwnerFormData {
    func asPetOwnerFormData() -> PetOwnerFormData {
        PetOwnerFormData(fullName: fullName, address: address, contactDetails: contactDetails)
    }
}

extension PetOwnerFormData {
    func asOwnersVCFormData() -> OwnersViewController.OwnerFormData {
        OwnersViewController.OwnerFormData(fullName: fullName, address: address, contactDetails: contactDetails)
    }
}

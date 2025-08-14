//
//  MockVetClinicsService.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 16.6.2025.
//

import Foundation

final class MockVetClinicService: VetClinicService {

    private var storage: [VetClinic] = VetClinic.mockData

    func fetchClinics(completion: @escaping ([VetClinic]) -> Void) {
        completion(storage)
    }

    func updateBookmark(_ clinic: VetClinic, isBookmarked: Bool, completion: (() -> Void)?) {
        if let index = storage.firstIndex(where: { $0.id == clinic.id }) {
            storage[index].isBookmarked = isBookmarked
        }
        NotificationCenter.default.post(name: .vetClinicBookmarksDidChange, object: nil)
        completion?()
    }
}


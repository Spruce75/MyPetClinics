//
//  ClinicsStorage.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 16.6.2025.
//

import Foundation

final class ClinicsStorage {
  static let shared = ClinicsStorage()

  private(set) var clinics: [VetClinic] = []

  private init() {

  }

  func fetchClinics(completion: @escaping () -> Void) {
    clinics = VetClinic.mockData
    completion()
  }

  func updateBookmark(for clinicID: UUID, isBookmarked: Bool, completion: (() -> Void)? = nil) {
    if let idx = clinics.firstIndex(where: { $0.id == clinicID }) {
      clinics[idx].isBookmarked = isBookmarked
    }
    completion?()
  }
}

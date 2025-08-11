//
//  MockVetClinicsService.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 16.6.2025.
//

import Foundation

final class MockVetClinicService: VetClinicService {
  func fetchClinics(completion: @escaping ([VetClinic]) -> Void) {
    completion(VetClinic.mockData)
  }
  func updateBookmark(_ clinic: VetClinic, isBookmarked: Bool, completion: (() -> Void)?) {
   
    completion?()
  }
}

//
//  VetClinicsService.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 16.6.2025.
//

import Foundation

protocol VetClinicService {
  func fetchClinics(completion: @escaping ([VetClinic]) -> Void)
  func updateBookmark(_ clinic: VetClinic, isBookmarked: Bool, completion: (() -> Void)?)
}

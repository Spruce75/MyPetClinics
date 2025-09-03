//
//  FilterConfigurationProvider.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 3.8.2025.
//

import Foundation

enum FilterConfigurationProvider {
    static func defaultSections() -> [FilterSection] {
        return [
            FilterSection(
                title: String(localized: "clinic_type_title"),
                options: [
                    FilterOption(name: "Vet clinic"),
                    FilterOption(name: "Vet hospital"),
                    FilterOption(name: "Private veterinarian")
                ]
            ),
            FilterSection(
                title: String(localized: "other_filters_title"),
                options: [
                    FilterOption(name: "Open 24/7"),
                    FilterOption(name: "Weekend & Holiday Open"),
                    FilterOption(name: "Emergency Services"),
                    FilterOption(name: "Online Consultation Available")
                ]
            )
        ]
    }
}

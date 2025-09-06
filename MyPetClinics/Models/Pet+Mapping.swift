//
//  Pet+Mapping.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import Foundation

extension Pet {
    init(from profile: PetProfile) {
        self.init(
            id: profile.id,
            name: profile.name,
            imageName: profile.avatarFileName ?? "no photo",
            unreadNotificationsCount: 0,
            avatarImageData: profile.avatarImageData
        )
    }
}

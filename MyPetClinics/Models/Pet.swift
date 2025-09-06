//
//  Pet.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 18.8.2025.
//

import Foundation

struct Pet: Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    var unreadNotificationsCount: Int

    let avatarImageData: Data?

    init(id: UUID = UUID(),
         name: String,
         imageName: String,
         unreadNotificationsCount: Int,
         avatarImageData: Data? = nil) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.unreadNotificationsCount = unreadNotificationsCount
        self.avatarImageData = avatarImageData
    }
}


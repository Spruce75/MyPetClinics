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

    // Позволяет как передавать id, так и не передавать его (создастся новый)
    init(id: UUID = UUID(),
         name: String,
         imageName: String,
         unreadNotificationsCount: Int) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.unreadNotificationsCount = unreadNotificationsCount
    }
}


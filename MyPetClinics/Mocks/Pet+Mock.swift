//
//  Pet+Mock.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 18.8.2025.
//

import Foundation

extension Pet {
    static let sampleLuna   = Pet(
        name: "Luna",
        imageName: "Luna cat",
        unreadNotificationsCount: 3
    )
    
    static let sampleMax    = Pet(
        name: "Max",
        imageName: "Max dog",
        unreadNotificationsCount: 2
    )
    
    static let sampleCharlie = Pet(
        name: "Charlie",
        imageName: "Charlie cat",
        unreadNotificationsCount: 0
    )
    
    static let sampleBella  = Pet(
        name: "Bella",
        imageName: "Bella dog",
        unreadNotificationsCount: 4
    )
    
    static let mockData: [Pet] = [
        .sampleLuna, .sampleMax, .sampleCharlie, .sampleBella
    ]
}

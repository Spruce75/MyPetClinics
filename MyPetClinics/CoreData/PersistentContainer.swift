//
//  PersistentContainer.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import Foundation
import CoreData

final class PersistentContainer {
    
    static let shared = PersistentContainer()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyPetClinics")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    private init() {}
}

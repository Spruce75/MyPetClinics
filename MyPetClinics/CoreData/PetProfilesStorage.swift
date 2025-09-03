//
//  PetProfilesStorage.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

//import UIKit
//import CoreData
//
///// Уведомление об изменениях (пригодится для обновления UI списков).
//extension Notification.Name {
//    static let petProfilesStorageDidChange = Notification.Name("petProfilesStorageDidChange")
//}
//
///// Репозиторий поверх Core Data. Никаких сокращений имен.
//final class PetProfilesStorage: NSObject {
//
//    static let shared = PetProfilesStorage()
//
//    // MARK: - Core Data
//
//    let viewContext: NSManagedObjectContext = PersistentContainer.shared.persistentContainer.viewContext
//
//    private var fetchedResultsController: NSFetchedResultsController<PetProfileCoreData>!
//    var onContentUpdated: (() -> Void)?
//
//    private override init() {
//        super.init()
//        initializeFetchedResultsController()
//    }
//
//    // MARK: - Public API
//
//    func fetchAll() -> [PetProfile] {
//        let objects = fetchedResultsController.fetchedObjects ?? []
//        return objects.compactMap { $0.asDomain() }
//    }
//
//    func create(from formData: PetProfileFormData, completion: @escaping (Bool) -> Void) {
//        let entity = PetProfileCoreData(context: viewContext)
//        let now = Date()
//        let domainModel = PetProfile(
//            id: UUID(),
//            name: formData.name,
//            fullName: formData.fullName,
//            sex: formData.sex,
//            species: formData.species,
//            breed: formData.breed,
//            colorMarkings: formData.colorMarkings,
//            dateOfBirth: formData.dateOfBirth,
//            weightInKilograms: formData.weightInKilograms,
//            identificationType: formData.identificationType,
//            identificationNumber: formData.identificationNumber,
//            avatarFileName: formData.avatarFileName,
//            createdAt: now,
//            updatedAt: now
//        )
//        entity.apply(from: domainModel)
//
//        do {
//            try viewContext.save()
//            notifyDataChange()
//            completion(true)
//        } catch {
//            print("Core Data save error: \(error)")
//            completion(false)
//        }
//    }
//    
//    func delete(by id: UUID, completion: @escaping (Bool) -> Void) {
//        let context = viewContext
//        context.perform {
//            let request: NSFetchRequest<PetProfileCoreData> = PetProfileCoreData.fetchRequest()
//            request.fetchLimit = 1
//            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                if let object = try context.fetch(request).first {
//                    context.delete(object)
//                    try context.save()
//                    self.notifyDataChange()
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//            } catch {
//                if context.hasChanges { context.rollback() }
//                print("Core Data delete error: \(error)")
//                completion(false)
//            }
//        }
//    }
//    
//    // MARK: - Internal helpers
//
//    private func notifyDataChange() {
//        NotificationCenter.default.post(name: .petProfilesStorageDidChange, object: viewContext)
//        onContentUpdated?()
//    }
//
//    private func initializeFetchedResultsController() {
//        let request: NSFetchRequest<PetProfileCoreData> = PetProfileCoreData.fetchRequest()
//        // самые свежие сверху
//        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
//
//        fetchedResultsController = NSFetchedResultsController(
//            fetchRequest: request,
//            managedObjectContext: viewContext,
//            sectionNameKeyPath: nil,
//            cacheName: nil
//        )
//        fetchedResultsController.delegate = self
//
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            print("FRC init error: \(error)")
//        }
//    }
//}
//
//// MARK: - NSFetchedResultsControllerDelegate
//
//extension PetProfilesStorage: NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        notifyDataChange()
//    }
//}

import UIKit
import CoreData

/// Уведомление об изменениях (пригодится для обновления UI списков).
extension Notification.Name {
    static let petProfilesStorageDidChange = Notification.Name("petProfilesStorageDidChange")
}

/// Репозиторий поверх Core Data. Никаких сокращений имен.
final class PetProfilesStorage: NSObject {

    static let shared = PetProfilesStorage()

    // MARK: - Core Data

    let viewContext: NSManagedObjectContext = PersistentContainer.shared.persistentContainer.viewContext

    private var fetchedResultsController: NSFetchedResultsController<PetProfileCoreData>!
    var onContentUpdated: (() -> Void)?

    private override init() {
        super.init()
        initializeFetchedResultsController()
    }

    // MARK: - Public API

    func fetchAll() -> [PetProfile] {
        let objects = fetchedResultsController.fetchedObjects ?? []
        return objects.compactMap { $0.asDomain() }
    }

    func create(from formData: PetProfileFormData, completion: @escaping (Bool) -> Void) {
        let entity = PetProfileCoreData(context: viewContext)
        let now = Date()
        let domainModel = PetProfile(
            id: UUID(),
            name: formData.name,
            fullName: formData.fullName,
            sex: formData.sex,
            species: formData.species,
            breed: formData.breed,
            colorMarkings: formData.colorMarkings,
            dateOfBirth: formData.dateOfBirth,
            weightInKilograms: formData.weightInKilograms,
            identificationType: formData.identificationType,
            identificationNumber: formData.identificationNumber,
            avatarFileName: formData.avatarFileName,
            createdAt: now,
            updatedAt: now
        )
        entity.apply(from: domainModel)

        do {
            try viewContext.save()
            notifyDataChange()
            completion(true)
        } catch {
            print("Core Data save error: \(error)")
            completion(false)
        }
    }

    func delete(by id: UUID, completion: @escaping (Bool) -> Void) {
        let context = viewContext
        context.perform {
            let request: NSFetchRequest<PetProfileCoreData> = PetProfileCoreData.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                if let object = try context.fetch(request).first {
                    context.delete(object)
                    try context.save()
                    self.notifyDataChange()
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                if context.hasChanges { context.rollback() }
                print("Core Data delete error: \(error)")
                completion(false)
            }
        }
    }

    /// Обновляет уже существующий профиль по id данными из формы.
    func update(by id: UUID, from data: PetProfileFormData, completion: @escaping (Bool) -> Void) {
        let context = viewContext
        context.perform {
            let request: NSFetchRequest<PetProfileCoreData> = PetProfileCoreData.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                guard let object = try context.fetch(request).first else {
                    completion(false)
                    return
                }

                let now = Date()
                // Берём исходную дату создания, чтобы не терять её при апдейте
                let originalCreatedAt = object.createdAt ?? now

                // Собираем доменную модель с новыми значениями
                let updatedDomain = PetProfile(
                    id: id,
                    name: data.name,
                    fullName: data.fullName,
                    sex: data.sex,
                    species: data.species,
                    breed: data.breed,
                    colorMarkings: data.colorMarkings,
                    dateOfBirth: data.dateOfBirth,
                    weightInKilograms: data.weightInKilograms,
                    identificationType: data.identificationType,
                    identificationNumber: data.identificationNumber,
                    avatarFileName: data.avatarFileName,
                    createdAt: originalCreatedAt,
                    updatedAt: now
                )

                // Маппим доменную модель обратно в Core Data объект
                object.apply(from: updatedDomain)

                try context.save()
                self.notifyDataChange()
                completion(true)
            } catch {
                if context.hasChanges { context.rollback() }
                print("Core Data update error: \(error)")
                completion(false)
            }
        }
    }

    // MARK: - Internal helpers

    private func notifyDataChange() {
        NotificationCenter.default.post(name: .petProfilesStorageDidChange, object: viewContext)
        onContentUpdated?()
    }

    private func initializeFetchedResultsController() {
        let request: NSFetchRequest<PetProfileCoreData> = PetProfileCoreData.fetchRequest()
        // самые свежие сверху
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("FRC init error: \(error)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension PetProfilesStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notifyDataChange()
    }
}

//
//  VaccinationsStorage.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 14.9.2025.
//

//import UIKit
//import CoreData
//
//final class VaccinationsStorage {
//
//    static let shared = VaccinationsStorage()
//    private init() {}
//
//    private let viewContext: NSManagedObjectContext = PersistentContainer.shared.persistentContainer.viewContext
//
//    // MARK: - Fetch
//    func fetchVaccinations(forPetId petId: UUID) -> [VaccinationListItem] {
//        let request = NSFetchRequest<NSManagedObject>(entityName: "VaccinationCoreData")
//        request.predicate = NSPredicate(format: "petId == %@", petId as CVarArg)
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "dateGiven", ascending: false),
//            NSSortDescriptor(key: "createdAt", ascending: false)
//        ]
//
//        do {
//            let objects = try viewContext.fetch(request)
//            let mapped: [VaccinationListItem] = objects.map { obj in
//                let id = (obj.value(forKey: "id") as? UUID) ?? UUID()
//                let title = obj.value(forKey: "title") as? String
//                let dateGiven = obj.value(forKey: "dateGiven") as? Date
//                let createdAt = (obj.value(forKey: "createdAt") as? Date) ?? .distantPast
//                return VaccinationListItem(id: id, title: title?.nilIfBlank, dateGiven: dateGiven, createdAt: createdAt)
//            }
//
//            // Перестраховка: если дат несколько — финально сортируем по dateGiven/createdAt
//            return mapped.sorted {
//                ($0.dateGiven ?? $0.createdAt) > ($1.dateGiven ?? $1.createdAt)
//            }
//        } catch {
//            print("VaccinationsStorage fetch error:", error)
//            return []
//        }
//    }
//    
//    func fetchVaccination(by id: UUID) -> VaccinationDetails? {
//        let request = NSFetchRequest<NSManagedObject>(entityName: "VaccinationCoreData")
//        request.fetchLimit = 1
//        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//        do {
//            guard let obj = try viewContext.fetch(request).first else { return nil }
//            return VaccinationDetails(
//                id: (obj.value(forKey: "id") as? UUID) ?? id,
//                petId: (obj.value(forKey: "petId") as? UUID) ?? UUID(),
//                title: (obj.value(forKey: "title") as? String) ?? "",
//                dateGiven: obj.value(forKey: "dateGiven") as? Date,
//                createdAt: (obj.value(forKey: "createdAt") as? Date) ?? .distantPast,
//                notes: obj.value(forKey: "notes") as? String,
//                imageData: obj.value(forKey: "imageData") as? Data
//            )
//        } catch {
//            print("VaccinationsStorage fetch single error:", error)
//            return nil
//        }
//    }
//    
//    // MARK: - Create
//    func createVaccination(
//        forPetId petId: UUID,
//        title: String,
//        dateGiven: Date?,
//        notes: String?,
//        images: [UIImage]
//    ) {
//        guard let entity = NSEntityDescription.entity(forEntityName: "VaccinationCoreData", in: viewContext) else { return }
//        
//        let object = NSManagedObject(entity: entity, insertInto: viewContext)
//        object.setValue(UUID(), forKey: "id")
//        object.setValue(petId, forKey: "petId")
//        object.setValue(title, forKey: "title")
//        object.setValue(dateGiven, forKey: "dateGiven")
//        object.setValue(Date(), forKey: "createdAt")
//        
//        if let notes, !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            object.setValue(notes, forKey: "notes")
//        }
//        
//        if let first = images.first, let data = first.jpegData(compressionQuality: 0.85) {
//            object.setValue(data, forKey: "imageData") // Binary Data (Allows External Storage можно оставить включённым)
//        }
//        
//        do {
//            try viewContext.save()
//        } catch {
//            print("VaccinationsStorage save error:", error)
//        }
//    }
//    
//    @discardableResult
//    func deleteVaccination(by id: UUID) -> Bool {
//        let request = NSFetchRequest<NSManagedObject>(entityName: "VaccinationCoreData")
//        request.fetchLimit = 1
//        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//        do {
//            if let object = try viewContext.fetch(request).first {
//                viewContext.delete(object)
//                try viewContext.save()
//                return true
//            }
//        } catch {
//            print("VaccinationsStorage delete error:", error)
//        }
//        return false
//    }
//}

import UIKit
import CoreData

final class VaccinationsStorage {
    
    static let shared = VaccinationsStorage()
    private init() {}
    
    private let viewContext: NSManagedObjectContext = PersistentContainer.shared.persistentContainer.viewContext
    
    // MARK: - Fetch list
    func fetchVaccinations(forPetId petId: UUID) -> [VaccinationListItem] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "VaccinationCoreData")
        request.predicate = NSPredicate(format: "petId == %@", petId as CVarArg)
        request.sortDescriptors = [
            NSSortDescriptor(key: "dateGiven", ascending: false),
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        do {
            let objects = try viewContext.fetch(request)
            let mapped: [VaccinationListItem] = objects.map { object in
                let id = (object.value(forKey: "id") as? UUID) ?? UUID()
                let title = object.value(forKey: "title") as? String
                let dateGiven = object.value(forKey: "dateGiven") as? Date
                let createdAt = (object.value(forKey: "createdAt") as? Date) ?? .distantPast
                return VaccinationListItem(
                    id: id,
                    title: title?.nilIfBlank,
                    dateGiven: dateGiven,
                    createdAt: createdAt
                )
            }
            
            return mapped.sorted { ($0.dateGiven ?? $0.createdAt) > ($1.dateGiven ?? $1.createdAt) }
        } catch {
            print("VaccinationsStorage fetch error:", error)
            return []
        }
    }
    
    // MARK: - Fetch single
    func fetchVaccination(by id: UUID) -> VaccinationDetails? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "VaccinationCoreData")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            guard let object = try viewContext.fetch(request).first else { return nil }
            
            // читаем Transformable [Data] с запасом (вдруг приехало как [NSData])
            let imagesArrayData: [Data]? = {
                if let arr = object.value(forKey: "imagesData") as? [Data] {
                    return arr
                } else if let nsArr = object.value(forKey: "imagesData") as? [NSData] {
                    return nsArr.map { Data(referencing: $0) }
                } else {
                    return nil
                }
            }()
            
            return VaccinationDetails(
                id: (object.value(forKey: "id") as? UUID) ?? id,
                petId: (object.value(forKey: "petId") as? UUID) ?? UUID(),
                title: (object.value(forKey: "title") as? String) ?? "",
                dateGiven: object.value(forKey: "dateGiven") as? Date,
                createdAt: (object.value(forKey: "createdAt") as? Date) ?? .distantPast,
                notes: object.value(forKey: "notes") as? String,
                imageData: object.value(forKey: "imageData") as? Data,   // fallback на одно фото
                imagesData: imagesArrayData                               // НОВОЕ: массив фото
            )
        } catch {
            print("VaccinationsStorage fetch single error:", error)
            return nil
        }
    }
    
    // MARK: - Create
    func createVaccination(
        forPetId petId: UUID,
        title: String,
        dateGiven: Date?,
        notes: String?,
        images: [UIImage]
    ) {
        guard let entity = NSEntityDescription.entity(forEntityName: "VaccinationCoreData", in: viewContext) else { return }
        
        let object = NSManagedObject(entity: entity, insertInto: viewContext)
        object.setValue(UUID(), forKey: "id")
        object.setValue(petId, forKey: "petId")
        object.setValue(title, forKey: "title")
        object.setValue(dateGiven, forKey: "dateGiven")
        object.setValue(Date(), forKey: "createdAt")
        
        if let notes = notes?.trimmingCharacters(in: .whitespacesAndNewlines), !notes.isEmpty {
            object.setValue(notes, forKey: "notes")
        } else {
            object.setValue(nil, forKey: "notes")
        }
        
        // НОВОЕ: несколько фото
        let imagesDataArray: [Data] = images.compactMap { $0.jpegData(compressionQuality: 0.85) }
        if !imagesDataArray.isEmpty {
            object.setValue(imagesDataArray, forKey: "imagesData")          // Transformable
            object.setValue(imagesDataArray.first, forKey: "imageData")      // старое поле (одно фото)
        } else {
            object.setValue(nil, forKey: "imagesData")
            object.setValue(nil, forKey: "imageData")
        }
        
        do {
            try viewContext.save()
        } catch {
            print("VaccinationsStorage save error:", error)
        }
    }
    
    // MARK: - Update
    @discardableResult
    func updateVaccination(
        id: UUID,
        title: String,
        dateGiven: Date?,
        notes: String?,
        images: [UIImage]
    ) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "VaccinationCoreData")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            guard let object = try viewContext.fetch(request).first else { return false }
            
            object.setValue(title, forKey: "title")
            object.setValue(dateGiven, forKey: "dateGiven")
            
            if let trimmedNotes = notes?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedNotes.isEmpty {
                object.setValue(trimmedNotes, forKey: "notes")
            } else {
                object.setValue(nil, forKey: "notes")
            }
            
            let imagesDataArray: [Data] = images.compactMap { $0.jpegData(compressionQuality: 0.85) }
            if !imagesDataArray.isEmpty {
                object.setValue(imagesDataArray, forKey: "imagesData")
                object.setValue(imagesDataArray.first, forKey: "imageData")
            } else {
                object.setValue(nil, forKey: "imagesData")
                object.setValue(nil, forKey: "imageData")
            }
            
            try viewContext.save()
            return true
        } catch {
            print("VaccinationsStorage update error:", error)
            return false
        }
    }
    
    // MARK: - Delete
    @discardableResult
    func deleteVaccination(by id: UUID) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "VaccinationCoreData")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            if let object = try viewContext.fetch(request).first {
                viewContext.delete(object)
                try viewContext.save()
                return true
            }
        } catch {
            print("VaccinationsStorage delete error:", error)
        }
        return false
    }
}

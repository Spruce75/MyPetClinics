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
//
//    private let viewContext: NSManagedObjectContext = PersistentContainer.shared.persistentContainer.viewContext
//
//    private func resolveEntityName() -> String? {
//        let candidateNames = ["VaccinationRecord", "VaccinationCoreData", "Vaccination"]
//        for name in candidateNames {
//            if NSEntityDescription.entity(forEntityName: name, in: viewContext) != nil {
//                return name
//            }
//        }
//        return nil
//    }
//
//    func fetchVaccinations(forPetId petId: UUID) -> [VaccinationListItem] {
//        guard let entityName = resolveEntityName() else {
//            // В модели ещё нет сущности вакцинаций — просто пусто.
//            return []
//        }
//
//        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
//        // Пробуем разные названия поля внешнего ключа.
//        let petKeyCandidates = ["petId", "profileId", "ownerPetId", "petUUID"]
//        var predicate: NSPredicate?
//        for key in petKeyCandidates {
//            // Проверка ключа «на лету»: если такого ключа нет — Core Data не ругается при создании predicate.
//            predicate = NSPredicate(format: "%K == %@", key, petId as CVarArg)
//            break
//        }
//        request.predicate = predicate
//        // Сортируем так: сначала по дате вакцинации (если есть), иначе — по createdAt убыв.
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "dateGiven", ascending: false),
//            NSSortDescriptor(key: "date", ascending: false),
//            NSSortDescriptor(key: "createdAt", ascending: false)
//        ]
//
//        do {
//            let objects = try viewContext.fetch(request)
//            let mapped: [VaccinationListItem] = objects.map { obj in
//                let id = (obj.value(forKey: "id") as? UUID)
//                    ?? (obj.value(forKey: "uuid") as? UUID)
//                    ?? UUID()
//
//                let title = (obj.value(forKey: "title") as? String)
//                    ?? (obj.value(forKey: "name") as? String)
//
//                let dateGiven = (obj.value(forKey: "dateGiven") as? Date)
//                    ?? (obj.value(forKey: "date") as? Date)
//
//                let createdAt = (obj.value(forKey: "createdAt") as? Date) ?? Date.distantPast
//
//                return VaccinationListItem(
//                    id: id,
//                    title: title?.nilIfBlank,
//                    dateGiven: dateGiven,
//                    createdAt: createdAt
//                )
//            }
//
//            // Финальная сортировка в памяти: по dateGiven/createdAt убыв.
//            return mapped.sorted {
//                let lhsDate = $0.dateGiven ?? $0.createdAt
//                let rhsDate = $1.dateGiven ?? $1.createdAt
//                return lhsDate > rhsDate
//            }
//        } catch {
//            print("VaccinationsStorage fetch error: \(error)")
//            return []
//        }
//    }
//}
//
//extension VaccinationsStorage {
//
//    /// Создаёт запись вакцинации (ищет подходящие имена атрибутов динамически).
//    func createVaccination(
//        forPetId petId: UUID,
//        title: String,
//        dateGiven: Date?,
//        notes: String?,
//        images: [UIImage]
//    ) {
//        guard
//            let entityName = resolveEntityName(),
//            let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext)
//        else { return }
//
//        let object = NSManagedObject(entity: entity, insertInto: viewContext)
//
//        // Универсальная установка значения по списку возможных ключей
//        func set(_ value: Any?, keys: [String]) {
//            guard let value else { return }
//            let attributes = entity.attributesByName
//            if let key = keys.first(where: { attributes[$0] != nil }) {
//                object.setValue(value, forKey: key)
//            }
//        }
//
//        set(UUID(), keys: ["id", "uuid"])
//        set(petId,keys: ["petId", "profileId", "ownerPetId", "petUUID"])
//        set(title,keys: ["title", "name"])
//        set(dateGiven,keys: ["dateGiven", "date"])
//        set(Date(),keys: ["createdAt", "created_at", "createdDate"])
//        if let notes, !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            set(notes,keys: ["notes", "details", "info", "text"])
//        }
//
//        // Сохраняем 1-е фото в *imageData/… если есть
//        if let first = images.first, let data = first.jpegData(compressionQuality: 0.85) {
//            set(data,keys: ["imageData", "image", "photo", "photoData"])
//        }
//
//        // Если есть трансформируемое поле для массива — положим туда массив Data
//        let allDatas = images.compactMap { $0.jpegData(compressionQuality: 0.82) }
//        if !allDatas.isEmpty {
//            set(allDatas as NSArray,keys: ["images", "imagesData", "photos", "photosData"])
//        }
//
//        do { try viewContext.save() }
//        catch { print("VaccinationsStorage save error:", error) }
//    }
//}

import UIKit
import CoreData

final class VaccinationsStorage {

    static let shared = VaccinationsStorage()
    private init() {}

    private let viewContext: NSManagedObjectContext = PersistentContainer.shared.persistentContainer.viewContext

    // MARK: - Fetch
    func fetchVaccinations(forPetId petId: UUID) -> [VaccinationListItem] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "VaccinationCoreData")
        request.predicate = NSPredicate(format: "petId == %@", petId as CVarArg)
        request.sortDescriptors = [
            NSSortDescriptor(key: "dateGiven", ascending: false),
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        do {
            let objects = try viewContext.fetch(request)
            let mapped: [VaccinationListItem] = objects.map { obj in
                let id = (obj.value(forKey: "id") as? UUID) ?? UUID()
                let title = obj.value(forKey: "title") as? String
                let dateGiven = obj.value(forKey: "dateGiven") as? Date
                let createdAt = (obj.value(forKey: "createdAt") as? Date) ?? .distantPast
                return VaccinationListItem(id: id, title: title?.nilIfBlank, dateGiven: dateGiven, createdAt: createdAt)
            }

            // Перестраховка: если дат несколько — финально сортируем по dateGiven/createdAt
            return mapped.sorted {
                ($0.dateGiven ?? $0.createdAt) > ($1.dateGiven ?? $1.createdAt)
            }
        } catch {
            print("VaccinationsStorage fetch error:", error)
            return []
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

        if let notes, !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            object.setValue(notes, forKey: "notes")
        }

        if let first = images.first, let data = first.jpegData(compressionQuality: 0.85) {
            object.setValue(data, forKey: "imageData") // Binary Data (Allows External Storage можно оставить включённым)
        }

        do {
            try viewContext.save()
        } catch {
            print("VaccinationsStorage save error:", error)
        }
    }
}

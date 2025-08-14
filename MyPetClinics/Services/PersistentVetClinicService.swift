//
//  PersistentVetClinicService.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 13.8.2025.
//

import Foundation

final class PersistentVetClinicService: VetClinicService {

    private var storage: [VetClinic] = VetClinic.mockData

    private let defaults = UserDefaults.standard
    private let bookmarksKey = "vetClinicBookmarks.v1"
    private var savedBookmarks: Set<String> {
        get { Set(defaults.array(forKey: bookmarksKey) as? [String] ?? []) }
        set { defaults.set(Array(newValue), forKey: bookmarksKey) }
    }

    init() {
        let saved = savedBookmarks
        storage = storage.map { clinic in
            var c = clinic
            c.isBookmarked = saved.contains(Self.key(for: clinic))
            return c
        }
    }

    func fetchClinics(completion: @escaping ([VetClinic]) -> Void) {
        completion(storage)
    }

    func updateBookmark(_ clinic: VetClinic, isBookmarked: Bool, completion: (() -> Void)?) {
        if let index = storage.firstIndex(where: { $0.id == clinic.id }) {
            storage[index].isBookmarked = isBookmarked
        }

        var set = savedBookmarks
        let key = Self.key(for: clinic)
        if isBookmarked { set.insert(key) } else { set.remove(key) }
        savedBookmarks = set

        NotificationCenter.default.post(name: .vetClinicBookmarksDidChange, object: nil)
        completion?()
    }

    // MARK: - Key building

    private static func key(for clinic: VetClinic) -> String {
        let urlKey = normalizedWebsiteKey(clinic.websiteURL)
        if !urlKey.isEmpty { return "web:\(urlKey)" }

        let name = clinic.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let addr = clinic.address.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let city = clinic.city.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return "na:\(name)|\(addr)|\(city)"
    }

    private static func normalizedWebsiteKey(_ url: URL) -> String {
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return "" }
        var host = (comps.host ?? "").lowercased()
        if host.hasPrefix("www.") { host.removeFirst(4) }
        var path = comps.percentEncodedPath
        if path.hasSuffix("/") && path.count > 1 { path.removeLast() }
        return host + path
    }
}

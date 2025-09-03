//
//  String+Utils.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 1.9.2025.
//

import Foundation

extension String {
    /// Возвращает nil, если строка пустая или состоит из пробелов/переводов строк
    var nilIfBlank: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}

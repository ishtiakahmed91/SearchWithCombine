//
//  Models.swift
//  SearchWithCombine
//
//  Created by Ishtiak Ahmed on 16.09.21.
//

import Foundation

// MARK: - Word
struct Word: Codable {
    let meanings: [Meaning]?
}

// MARK: - Meaning
struct Meaning: Codable {
    let definitions: [WordDefinition]?
}

// MARK: - WordDefinition
struct WordDefinition: Codable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
    let definition: String?
    let example: String?
}

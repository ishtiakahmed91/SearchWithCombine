//
//  WordSearchModels.swift
//  SearchWithCombine
//
//  (c) Ishtiak Ahmed (2021)
//

import UIKit

enum Search {
    enum FetchWordDefinitions {
        struct Request {
            let searchText: String
        }

        struct Response {
            let wordDefinitions: [WordDefinition]?
        }

        struct ViewModel {
            let wordDefinitions: [WordDefinition]?
        }
    }
}

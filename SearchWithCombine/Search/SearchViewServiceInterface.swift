//
//  SearchViewServiceInterface.swift
//  SearchWithCombine
//
//  Created by Ishtiak Ahmed on 16.09.21.
//

import Combine
import Foundation

protocol SearchServiceInterfaceProtocol: AnyObject {
    func requestWordDefinitions(for searchText: String) -> AnyPublisher<[Word], Error>
}

final class SearchViewServiceInterface: SearchServiceInterfaceProtocol {
    private let decoder: JSONDecoder
    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }

    func requestWordDefinitions(for searchText: String) -> AnyPublisher<[Word], Error> {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchText)"

        guard let castedURL = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: castedURL)
        request.httpMethod = "GET"

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [Word].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

//
//  SearchInteractor.swift
//  SearchWithCombine
//
//  (c) Ishtiak Ahmed (2021)
//

import UIKit
import Combine

protocol SearchDataStore {
    
}

protocol SearchBusinessLogic {
    func fetchWordDefinitions(request: Search.FetchWordDefinitions.Request)
}

class SearchInteractor: SearchDataStore {
    // MARK: Instance Properties
    var presenter: SearchPresentationLogic?

    private let service: SearchServiceInterfaceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: SearchViewServiceInterface = .init(),
         subscriptions: Set<AnyCancellable> = .init()) {
        self.service = service
        self.cancellables = subscriptions
    }
}

extension SearchInteractor: SearchBusinessLogic {
    func fetchWordDefinitions(request: Search.FetchWordDefinitions.Request) {

        service.requestWordDefinitions(for: request.searchText)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] words in
                let wordDefinitions = words.compactMap { word in
                    word.meanings?.compactMap({ meaning in
                        return meaning.definitions
                    }).reduce([], +)
                }.reduce([], +)

                let response = Search.FetchWordDefinitions.Response(wordDefinitions: wordDefinitions)
                self?.presenter?.presentWordDefinitions(response: response)
            }
            .store(in: &cancellables)
    }
}

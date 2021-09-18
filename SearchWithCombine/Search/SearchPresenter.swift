//
//  SearchPresenter.swift
//  SearchWithCombine
//
//  (c) Ishtiak Ahmed (2021)
//

import UIKit

protocol SearchPresentationLogic {
    func presentWordDefinitions(response: Search.FetchWordDefinitions.Response)
}

class SearchPresenter {
    weak var viewController: SearchDisplayLogic?
}

extension SearchPresenter: SearchPresentationLogic {
    func presentWordDefinitions(response: Search.FetchWordDefinitions.Response) {
        let viewModel = Search.FetchWordDefinitions.ViewModel(wordDefinitions: response.wordDefinitions)
        viewController?.displayWordDefinitions(viewModel: viewModel)
    }
}

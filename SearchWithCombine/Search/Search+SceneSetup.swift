//
//  Search+SceneSetup.swift
//  SearchWithCombine
//
//  (c) Ishtiak Ahmed (2021)
//

import UIKit

extension SearchViewController {
    func sceneSetup() {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
}

//
//  WordSearchViewController.swift
//  SearchWithCombine
//
//  (c) Ishtiak Ahmed (2021)
//

import UIKit
import Combine

enum Section {
    case main
}

typealias WordDefinitionsDiffableDataSource = UITableViewDiffableDataSource<Section, WordDefinition>
typealias WordDefinitionsSnapshot = NSDiffableDataSourceSnapshot<Section, WordDefinition>

protocol SearchDisplayLogic: AnyObject {
    func displayWordDefinitions(viewModel: Search.FetchWordDefinitions.ViewModel)
}

class SearchViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: SearchBusinessLogic?

    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var wordDefinitionsTableView: UITableView!

    private var wordDefinitions: [WordDefinition]? = []
    private var wordDefinitionsDiffableDataSource: WordDefinitionsDiffableDataSource!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Object Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sceneSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sceneSetup()
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
        searchBar.isUserInteractionEnabled = true
        searchBar.delegate = self

        wordDefinitionsDiffableDataSource = WordDefinitionsDiffableDataSource(
            tableView: wordDefinitionsTableView,
            cellProvider: { _, _, dataSet in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                cell.textLabel?.text = dataSet.definition
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = dataSet.example
                cell.detailTextLabel?.numberOfLines = 0
                return cell
            }
        )

        publishSearchBarTextChanged()
    }
}

// MARK: - Private Functions
private extension SearchViewController {
    func publishSearchBarTextChanged() {
        let publisher = NotificationCenter.default.publisher(
            for: UISearchTextField.textDidChangeNotification,
            object: searchBar.searchTextField
        )

        publisher.compactMap { ($0.object as? UISearchTextField)?.text }
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.count >= 2 }
            .sink { [weak self] searchText in
                self?.fetchWordDefinitions(by: searchText)
            }.store(in: &cancellables)
    }

    func fetchWordDefinitions(by searchText: String) {
        let request = Search.FetchWordDefinitions.Request(searchText: searchText)
        interactor?.fetchWordDefinitions(request: request)
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        guard let wordDefinitions = wordDefinitions else { return }

        var snapshot = WordDefinitionsSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(wordDefinitions)

        wordDefinitionsDiffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Display Logic
extension SearchViewController: SearchDisplayLogic {
    func displayWordDefinitions(viewModel: Search.FetchWordDefinitions.ViewModel) {
        wordDefinitions = viewModel.wordDefinitions
        applySnapshot(animatingDifferences: false)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        wordDefinitions = []
        applySnapshot(animatingDifferences: false)
    }
}


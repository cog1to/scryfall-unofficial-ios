//
//  CardSearchViewController.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

/**
 * Card search view controller. Shows search bar and list of search results.
 */
class CardSearchViewController: UITableViewController, BindableType {
    var searchController: UISearchController!
    var viewModel: CardSearchViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        // Setup search controller.
        definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func bindViewModel() {
        // Listen to search controller updates.
        searchController.rx.updateSearchResults
            .filter { $0 != nil && $0!.count > 0 }
            .map { $0! }
            .debounce(RxTimeInterval(0.5), scheduler: MainScheduler.instance)
            .subscribe(viewModel.onSearch.inputs)
            .disposed(by: disposeBag)
        
        // Reload table when change in cards array is detected.
        viewModel.cards.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        // Request next page when loading cell becomes visible.
        tableView.rx.willDisplayCell
            .filter { cell, indexPath in
                return type(of: cell) == LoadingCell.self
            }.subscribe(onNext: { (_) in
                self.viewModel.onNextPage.execute(())
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        // Open card details when user select an item.
        tableView.rx.itemSelected
            .filter { [unowned self] indexPath in
                return indexPath.row != self.viewModel.cards.value.count
            }.map {
                return self.viewModel.cards.value[$0.row]
            }.subscribe(viewModel.showAction.inputs)
            .disposed(by: disposeBag)
    }
}

extension CardSearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 0
        }
        
        // Add 'loading' cell if view model indicates that there's more cards to load.
        return viewModel.cards.value.count + (viewModel.hasMore.value ? 1 : 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Loading cell
        if indexPath.row == viewModel.cards.value.count {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            return loadingCell
        }
        
        // Card search result cell.
        let cardCell = tableView.dequeueReusableCell(withIdentifier: "CardSearchCell", for: indexPath) as! CardSearchCell
        let card = viewModel.cards.value[indexPath.row]
        cardCell.configure(for: card)
        return cardCell
    }
}

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

class CardSearchViewController: UITableViewController, BindableType {
    var searchController: UISearchController!
    var viewModel: CardSearchViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func bindViewModel() {
        searchController.rx.updateSearchResults
            .filter { $0 != nil && $0!.count > 0 }
            .map { $0! }
            .debounce(RxTimeInterval(0.5), scheduler: MainScheduler.instance)
            .subscribe(viewModel.onSearch.inputs)
            .disposed(by: disposeBag)
        
        viewModel.cards.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .filter { cell, indexPath in
                return type(of: cell) == LoadingCell.self
            }.subscribe(onNext: { (_) in
                self.viewModel.onNextPage.execute(())
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
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
        if (section == 0) {
            return viewModel.cards.value.count + (viewModel.hasMore.value ? 1 : 0)
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.cards.value.count {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            return loadingCell
        }
        
        let cardCell = tableView.dequeueReusableCell(withIdentifier: "CardSearchCell", for: indexPath) as! CardSearchCell
        let card = viewModel.cards.value[indexPath.row]
        cardCell.configure(for: card)
        return cardCell
    }
}

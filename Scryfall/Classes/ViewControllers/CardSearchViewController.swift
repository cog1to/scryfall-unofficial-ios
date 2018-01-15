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
class CardSearchViewController: UIViewController, BindableType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityLabel: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    
    var viewModel: CardSearchViewModel!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        let noItemsLabel = UILabel()
        noItemsLabel.numberOfLines = 0
        noItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        noItemsLabel.font = Style.font(forKey: .text)
        noItemsLabel.textColor = Style.color(forKey: .gray)
        noItemsLabel.text = "Sorry, No cards matching your criteria found"
        tableView.tableFooterView = UIView()
        
        tableView.backgroundView = nil
        tableView.backgroundColor = Style.color(forKey: .background)
        
        definesPresentationContext = true
        
        loadingView.backgroundColor = Style.color(forKey: .background)
        loadingView.layer.cornerRadius = 4.0
        
        menuButton.tintColor = Style.color(forKey: .printingText)
    }
    
    func bindViewModel() {
        // Perform searh when search bar text changes.
        searchField.rx.text
            .filter { $0 != nil && $0!.count > 0 }
            .map { $0! }
            .debounce(RxTimeInterval(0.5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
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
            }.do(onNext: { [unowned self] in
                self.tableView.deselectRow(at: $0, animated: true)
            }).map {
                return self.viewModel.cards.value[$0.row]
            }.subscribe(viewModel.showAction.inputs)
            .disposed(by: disposeBag)
        
        // Loading indicator.
        viewModel.loading.asObservable().distinctUntilChanged().map{ !$0 }.asDriver(onErrorJustReturn: false).drive(loadingView.rx.isHidden).disposed(by: disposeBag)
        viewModel.loading.asObservable().distinctUntilChanged().asDriver(onErrorJustReturn: false).drive(activityLabel.rx.isAnimating).disposed(by: disposeBag)
    }
}

extension CardSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 0
        }
        
        // Add 'loading' cell if view model indicates that there's more cards to load.
        return viewModel.cards.value.count + (viewModel.hasMore.value ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Loading cell
        if indexPath.row == viewModel.cards.value.count {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            loadingCell.selectionStyle = .none
            return loadingCell
        }
        
        // Card search result cell.
        let cardCell = tableView.dequeueReusableCell(withIdentifier: "CardSearchCell", for: indexPath) as! CardSearchCell
        let card = viewModel.cards.value[indexPath.row]
        cardCell.configure(for: card)
        
        // Customize selection color.
        let selectionView = UIView()
        selectionView.backgroundColor = Style.color(forKey: .tint).withAlphaComponent(0.3)
        cardCell.selectedBackgroundView =  selectionView;
        
        return cardCell
    }
}

//
//  SetListViewController.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/28/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx
import Action

/**
 * All Sets list view controller.
 */
class SetListViewController: DynamicHeaderViewController, BindableType {
    
    let cellIdentifier = "SetsListCell"
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityLabel: UIActivityIndicatorView!
    
    var optionsViewController: ListSettingsHeader<SetSortOrder, CardSetType>!
    
    var viewModel: SetsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Style.color(forKey: .navigationTint)
        
        optionsViewController = ListSettingsHeader<SetSortOrder, CardSetType>(view: searchOptionsView, presenter: self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SetsListCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.refreshControl = UIRefreshControl()
        
        searchOptionsView.firstOptionLabel.text = "Sort by"
        searchOptionsView.secondOptionLabel.text = "Set type"
        searchOptionsView.delimiterLabel.isHidden = true
        searchOptionsView.sortDirectionButton.isHidden = true
        
        definesPresentationContext = true
        
        loadingView.backgroundColor = Style.color(forKey: .background)
        loadingView.layer.cornerRadius = Constants.commonCornerRadius
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "All sets"
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // We bind data source after view appears to remove the lag between tapping on "all sets" button and UI response.
        let sets = viewModel.sets.asObservable()
        sets.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { [unowned self] index, model, cell in
            if let cell = cell as? SetsListCell {
                cell.configure(for: model, tableView: self.tableView, indexPath: IndexPath(row: index, section: 0))
            }
        }
        .disposed(by: disposeBag)
        
        sets.asDriver(onErrorJustReturn: []).drive(onNext: { [unowned self] _ in
            self.tableView.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)

        viewModel.refreshSubject.onNext(false)
    }
    
    func bindViewModel() {
        setupNavigationBackAction()
        
        optionsViewController.setFirstOption(viewModel.sortOrder.value)
        optionsViewController.setSecondOption(viewModel.setType.value)
        
        tableView.rx.itemSelected
            .do(onNext: { [unowned self] in
                self.tableView.deselectRow(at: $0, animated: true)
            }).map { [unowned self] in
                return self.viewModel.sets.value[$0.row]
            }.subscribe(viewModel.onSet.inputs)
            .disposed(by: disposeBag)

        // Refresh.
        tableView.refreshControl?.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
            self.viewModel.refreshSubject.onNext(true)
        }).disposed(by: disposeBag)
        
        // Connect UX to view mode settings
        optionsViewController.firstOptionSelected = Action { [unowned self] sortOrder in
            self.viewModel.sortOrder.value = sortOrder
            return Observable.just(())
        }

        // Connect UX to view mode settings
        optionsViewController.secondOptionSelected = Action { [unowned self] type in
            self.viewModel.setType.value = type
            return Observable.just(())
        }
    }
    
    func setupNavigationBackAction() {
        self.navigationItem.hidesBackButton = true
        var customBackButton = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        customBackButton.rx.action = viewModel.onBack
        self.navigationItem.leftBarButtonItem = customBackButton
    }
}

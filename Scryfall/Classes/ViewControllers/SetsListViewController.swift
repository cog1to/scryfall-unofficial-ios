//
//  SetsListViewController.swift
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
class SetsListViewController: UIViewController, BindableType {
    
    let cellIdentifier = "SetsListCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityLabel: UIActivityIndicatorView!
    @IBOutlet weak var searchOptionsView: ListSettingsHeaderView!
    @IBOutlet var searchOptionsConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraints: Array<NSLayoutConstraint>!
    
    var optionsViewController: ListSettingsHeader<SetSortOrder, CardSetType>!
    
    var viewModel: SetsListViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Style.color(forKey: .navigationTint)
        
        optionsViewController = ListSettingsHeader<SetSortOrder, CardSetType>(view: searchOptionsView, presenter: self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SetsListCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.rx.didScroll.subscribe(onNext: { [unowned self] in
            self.scrollViewDidScroll(self.tableView)
        }).disposed(by: disposeBag)
        
        searchOptionsView.firstOptionLabel.text = "Sort by"
        searchOptionsView.secondOptionLabel.text = "Set type"
        
        definesPresentationContext = true
        
        loadingView.backgroundColor = Style.color(forKey: .background)
        loadingView.layer.cornerRadius = Constants.commonCornerRadius
    }
    
    fileprivate var maxSettingsHeaderHeight: CGFloat = 0
    fileprivate var settingsHeaderConstraint: NSLayoutConstraint!
    fileprivate var previousScrollOffset: CGFloat = 0
    
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
        
        if (settingsHeaderConstraint == nil) {
            maxSettingsHeaderHeight = searchOptionsView.frame.size.height
            settingsHeaderConstraint = NSLayoutConstraint(item: searchOptionsView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: maxSettingsHeaderHeight)
            view.addConstraint(settingsHeaderConstraint)
        }
        
        searchOptionsConstraint.isActive = false
        
        // We bind data source after view appears to remove the lag between tapping on "all sets" button and UI response.
        viewModel.sets
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { [unowned self] index, model, cell in
                if let cell = cell as? SetsListCell {
                    cell.configure(for: model, tableView: self.tableView, indexPath: IndexPath(row: index, section: 0))
                }
            }
            .disposed(by: disposeBag)
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
        var customBackButton = UIBarButtonItem(title: "Back", style: .done,
                                               target: nil, action: nil)
        customBackButton.rx.action = viewModel.onBack
        self.navigationItem.leftBarButtonItem = customBackButton
    }
}

// MARK: - Scrolling / Options header

extension SetsListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let settingsHeaderConstraint = settingsHeaderConstraint else {
            return
        }
        
        guard canAnimateHeader(scrollView) else {
            return
        }
        
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        var newHeight = settingsHeaderConstraint.constant
        if isScrollingDown {
            newHeight = max(0, settingsHeaderConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeight = min(maxSettingsHeaderHeight, settingsHeaderConstraint.constant + abs(scrollDiff))
        }
        
        if newHeight != settingsHeaderConstraint.constant {
            settingsHeaderConstraint.constant = newHeight
            scrollView.setContentOffset(CGPoint(x: 0, y: previousScrollOffset), animated: false)
        }
        
        previousScrollOffset = scrollView.contentOffset.y
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + settingsHeaderConstraint.constant
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
}

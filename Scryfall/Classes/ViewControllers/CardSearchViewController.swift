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
import Action

/**
 * Card search view controller. Shows search bar and list of search results.
 */
class CardSearchViewController: UIViewController, BindableType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityLabel: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var searchOptionsView: ListSettingsHeaderView!
    @IBOutlet var searchOptionsConstraint: NSLayoutConstraint!
    
    @IBOutlet var bottomConstraints: Array<NSLayoutConstraint>!
    
    var searchOptionsViewController: ListSettingsHeader<DisplayMode, SortOrder>!
    
    var noItemsLabel = UILabel()
    
    var viewModel: CardSearchViewModel!
    
    var popover: PopoverMenuView!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Style.color(forKey: .navigationTint)
        
        searchOptionsViewController = ListSettingsHeader<DisplayMode, SortOrder>(view: searchOptionsView, presenter: self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        noItemsLabel.numberOfLines = 0
        noItemsLabel.lineBreakMode = .byWordWrapping
        noItemsLabel.textAlignment = .center
        noItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        noItemsLabel.font = Style.font(forKey: .text)
        noItemsLabel.textColor = Style.color(forKey: .gray)
        noItemsLabel.text = "Sorry, no cards matching current search criteria found"
        noItemsLabel.isHidden = true
        
        tableView.addSubview(noItemsLabel)
        noItemsLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        noItemsLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        tableView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=20)-[label]-(>=20)-|", options: [], metrics: nil, views: ["label":noItemsLabel]))
        tableView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=20)-[label]-(>=20)-|", options: [], metrics: nil, views: ["label":noItemsLabel]))
        tableView.tableFooterView = UIView()
        
        definesPresentationContext = true
        
        loadingView.backgroundColor = Style.color(forKey: .background)
        loadingView.layer.cornerRadius = Constants.commonCornerRadius
        
        menuButton.tintColor = Style.color(forKey: .printingText)
        
        searchOptionsView.firstOptionLabel.text = "Show as"
        searchOptionsView.secondOptionLabel.text = "Sort by"
    }
    
    func bindViewModel() {
        // Perform searh when search bar text changes.
        searchField.rx.text
            .filter { $0 != nil && $0!.count > 0 }
            .map { $0! }
            .distinctUntilChanged()
            .debounce(RxTimeInterval(0.5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(viewModel.onSearch.inputs)
            .disposed(by: disposeBag)
        
        // Reload table when change in cards array is detected.
        let cards = viewModel.cards.asObservable().observeOn(MainScheduler.instance)
        
        cards
            .subscribe(onNext: { cards in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        cards
            .subscribe(onNext: { cards in
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        cards
            .map{ $0.count != 0 }
            .skip(1)
            .asDriver(onErrorJustReturn: true)
            .drive(self.noItemsLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
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
        
        // Request next page when loading cell in collection view becomes visible.
        collectionView.rx.willDisplayCell
            .filter { cell, indexPath in
                return type(of: cell) == LoadingCollectionCell.self
            }.subscribe(onNext: { (_) in
                self.viewModel.onNextPage.execute(())
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        // Open card details when user select an item.
        collectionView.rx.itemSelected
            .filter { [unowned self] indexPath in
                return indexPath.row != self.viewModel.cards.value.count
            }.map {
                return self.viewModel.cards.value[$0.row]
            }.subscribe(viewModel.showAction.inputs)
            .disposed(by: disposeBag)
        
        // Loading indicator.
        viewModel.loading.asObservable().distinctUntilChanged().map{ !$0 }.asDriver(onErrorJustReturn: false).drive(loadingView.rx.isHidden).disposed(by: disposeBag)
        viewModel.loading.asObservable().distinctUntilChanged().asDriver(onErrorJustReturn: false).drive(activityLabel.rx.isAnimating).disposed(by: disposeBag)
        
        // Search params reverse binding.
        viewModel.searchText.asObservable().bind(to: searchField.rx.text).disposed(by: disposeBag)
        viewModel.sortOrder.asObservable().subscribe(onNext: {
            self.searchOptionsViewController.setSecondOption($0)
        }).disposed(by: disposeBag)
        
        // Connect view mode setting.
        Settings.shared.viewMode.asObservable().subscribe(onNext: { [weak self] viewMode in
            guard let strongSelf = self else {
                return
            }
            
            switch viewMode {
            case .cards:
                strongSelf.tableView.dataSource = self
                strongSelf.tableView.isHidden = false
                strongSelf.collectionView.dataSource = nil
                strongSelf.collectionView.isHidden = true
                
                strongSelf.tableView.reloadData()
            case .images:
                strongSelf.tableView.dataSource = nil
                strongSelf.tableView.isHidden = true
                strongSelf.collectionView.dataSource = self
                strongSelf.collectionView.isHidden = false
                
                strongSelf.collectionView.reloadData()
            }
            
            strongSelf.searchOptionsViewController.setFirstOption(viewMode)
        }).disposed(by: disposeBag)
        
        // Connect UX to view mode settings
        searchOptionsViewController.firstOptionSelected = Action { displayMode in
            Settings.shared.viewMode.value = displayMode
            return Observable.just(())
        }
        
        // Connect UX to view mode settings
        searchOptionsViewController.secondOptionSelected = Action { sortOrder in
            self.viewModel.onSortOrderChange.execute(sortOrder)
        }
        
        menuButton.rx.tap.subscribe(onNext: {
            self.popover = PopoverMenuView(items: ["All sets"])
            self.popover.show(from: self.menuButton, itemSelected: self.viewModel.onMenuItemSelected)
        }).disposed(by: disposeBag)
    }
    
    fileprivate var maxSettingsHeaderHeight: CGFloat = 0
    fileprivate var settingsHeaderConstraint: NSLayoutConstraint!
    fileprivate var previousScrollOffset: CGFloat = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (settingsHeaderConstraint == nil) {
            maxSettingsHeaderHeight = searchOptionsView.frame.size.height
            settingsHeaderConstraint = NSLayoutConstraint(item: searchOptionsView, attribute: .bottom, relatedBy: .equal, toItem: searchBarContainer, attribute: .bottom, multiplier: 1.0, constant: maxSettingsHeaderHeight)
            view.addConstraint(settingsHeaderConstraint)
        }
        
        searchOptionsConstraint.isActive = false
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Scrolling / Options header

extension CardSearchViewController: UITableViewDelegate, UICollectionViewDelegate {
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

// MARK: - Data source

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

extension CardSearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == 0 else {
            return 0
        }
        
        // Add 'loading' cell if view model indicates that there's more cards to load.
        return viewModel.cards.value.count + (viewModel.hasMore.value ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Loading cell
        if indexPath.row == viewModel.cards.value.count {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCollectionCell
            return loadingCell
        }
        
        // Card search result cell.
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardSearchCell", for: indexPath) as! CardSearchCollectionCell
        let card = viewModel.cards.value[indexPath.row]
        cardCell.configure(for: card)
        
        return cardCell
    }
}

extension CardSearchViewController: UICollectionViewDelegateFlowLayout {
    static let spacing: CGFloat = 10.0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfRows = 2
        
        // Allow 3+ row layout on big screens
        if traitCollection.horizontalSizeClass == .regular {
            numberOfRows = 3
        }
        
        // Width of a card = Screen width - margins - spacing between cards
        let availableWidth = (view.frame.size.width - (CardSearchViewController.spacing * CGFloat(2 + numberOfRows - 1))) / CGFloat(numberOfRows)
        let height = availableWidth / Constants.widthToHeightRatio
        
        return CGSize(width: availableWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CardSearchViewController.spacing,
                            left: CardSearchViewController.spacing,
                            bottom: CardSearchViewController.spacing,
                            right: CardSearchViewController.spacing)
    }
}

// MARK: - Keyboard handling

extension CardSearchViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        var safeAreaInset: CGFloat = 0.0
        if #available(iOS 11, *) {
            safeAreaInset = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        }
        
        UIView.animate(withDuration: duration) {
            for constraint in self.bottomConstraints {
                constraint.constant = safeAreaInset - rect.size.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        
        UIView.animate(withDuration: duration) {
            for constraint in self.bottomConstraints {
                constraint.constant = 0
            }
        }
    }
}

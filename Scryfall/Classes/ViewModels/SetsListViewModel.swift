//
//  SetsListViewModel.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/28/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa
import NSObject_Rx

class SetsListViewModel {
    
    struct SetListItem {
        let iconUri: URL?
        let name: String
        let setUri: URL
        let releaseDate: Date?
        let cards: Int
        let level: Int
        let block: String?
        let code: String
        let type: CardSetType
    }
    
    let scryfallService: ScryfallServiceType
    let sceneCoordinator: SceneCoordinatorType
    weak var callback: Action<[URLQueryItem], Void>?
    
    let sortOrder = Variable<SetSortOrder>(.releaseDate)
    let setType = Variable<CardSetType>(.any)
    let sets = Variable<[SetListItem]>([])
    let refreshSubject = PublishSubject<Bool>()
    
    private let bag = DisposeBag()
    
    init(service: ScryfallServiceType, coordinator: SceneCoordinatorType, callback: Action<[URLQueryItem], Void>) {
        scryfallService = service
        sceneCoordinator = coordinator
        self.callback = callback
        
        let setsObservable = refreshSubject.asObservable().flatMap {
            CardSetCache.instance.sets(force: $0)
        }
        let combinedObservable = Observable.combineLatest(sortOrder.asObservable(), setType.asObservable(), setsObservable)
        combinedObservable.map { (order: SetSortOrder, type: CardSetType, sets: [CardSet]) -> [SetListItem] in
                let filteredItems = (type == .any) ? sets : sets.filter {
                    return $0.setType == type
                }
                
                var sortFunction: ((CardSet, CardSet) -> Bool)!
                
                switch order {
                case .name:
                    sortFunction = { return $0.name < $1.name }
                case .cards:
                    sortFunction = { return $0.cardCount > $1.cardCount }
                case .blockOrGroup:
                    sortFunction = {
                        if ($0.block == nil && $1.block != nil) {
                            return false
                        }
                        
                        if ($0.block != nil && $1.block == nil) {
                            return true
                        }
                        
                        if let block1 = $0.block, let block2 = $1.block {
                            if (block1 == block2) {
                                return $0.name < $1.name
                            }
                            
                            return block1 < block2
                        }
                        
                        if ($0.block == nil && $1.block == nil) {
                            return sets.index(of: $0)! < sets.index(of: $1)!
                        }
                        
                        return false
                    }
                case .releaseDate:
                    sortFunction = {
                        if ($0.code == "pxtc" || $1.code == "pxtc") {
                            print("\($0.code) - \($1.code)")
                            print("hey")
                        }
                        
                        if ($0.code == $1.parentSetCode) {
                            return true
                        } else if ($1.code == $0.parentSetCode) {
                            return false
                        }
                        
                        if let parent1 = $0.parentSetCode, let parent2 = $1.parentSetCode {
                            if (parent1 == parent2) {
                                return $0.name < $1.name
                            }
                            
                            let parentSet1 = sets[parent1]!
                            let parentSet2 = sets[parent2]!
                            
                            if let date1 = parentSet1.releasedAt, let date2 = parentSet2.releasedAt {
                                return date1 > date2
                            }
                        }
                        
                        if let parent1 = $0.parentSetCode, let parentSet1 = sets[parent1], let releaseDate1 = parentSet1.releasedAt {
                            if let releaseDate2 = $1.releasedAt, releaseDate1 != releaseDate2 {
                                return releaseDate1 > releaseDate2
                            } else {
                                return sets.index(of: parentSet1)! < sets.index(of: $1)!
                            }
                        }
                        
                        if let parent2 = $1.parentSetCode, let parentSet2 = sets[parent2], let releaseDate2 = parentSet2.releasedAt {
                            if let releaseDate1 = $0.releasedAt, releaseDate1 != releaseDate2 {
                                return releaseDate1 > releaseDate2
                            } else {
                                return sets.index(of: $0)! < sets.index(of: parentSet2)!
                            }
                        }
                        
                        if let releaseDate1 = $0.releasedAt, let releaseDate2 = $1.releasedAt {
                            return releaseDate1 > releaseDate2
                        }
                        
                        return sets.index(of: $0)! < sets.index(of: $1)!
                    }
                }
                
                let sortedItems = filteredItems.sorted(by: sortFunction)
                
                return sortedItems.map { set in
                    return SetListItem(iconUri: set.iconURI,
                                       name: set.name,
                                       setUri: set.searchURI!,
                                       releaseDate: set.releasedAt,
                                       cards: set.cardCount,
                                       level: ((order == .releaseDate && set.parentSetCode != nil) ? 1 : 0),
                                       block: set.block,
                                       code: set.code,
                                       type: set.setType)
                }
            }
            .bind(to: sets)
            .disposed(by: bag)
        
        self.callback?.executionObservables.share().take(1).subscribe(onNext: { _ in
            coordinator.pop()
        }).disposed(by: bag)
    }
    
    lazy var onBack: CocoaAction = { [unowned self] in
        return CocoaAction { [unowned self] in
            return self.sceneCoordinator.pop()
        }
    }()
    
    lazy var onSet: Action<SetListItem, Void> = { [unowned self] in
        return Action { [unowned self] item in
            return self.callback(withQueryString: "set:\(item.code)") ?? Observable.just(())
        }
    }()
}

extension SetsListViewModel {
    private func callback(withQueryString string: String) -> Observable<Void>? {
        let queryItem = URLQueryItem(name: "q", value: string)
        return callback?.execute([queryItem])
    }
}

extension Array where Element: CardSet {
    subscript(index: String?) -> CardSet? {
        guard let index = index else {
            return nil
        }
        
        return self.filter { $0.code == index }.first
    }
}

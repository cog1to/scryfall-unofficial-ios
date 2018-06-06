//
//  CardDetailsViewModel.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa
import NSObject_Rx

class CardDetailsViewModel: NSObject {
    private var disposeBag = DisposeBag()    
    private let printsVariable = Variable<[Card]>([])
    private let languagesVariable = Variable<[Card]>([])
    private let rulingsVariable = Variable<[CardRuling]>([])
    
    let service: ScryfallServiceType
    let coordinator: SceneCoordinatorType
    let onCancel: CocoaAction
    let callback: Action<[URLQueryItem], Void>?
    let cardVariable: Variable<Card>
    
    var card: Driver<Card> {
        return cardVariable.asDriver()
    }
    
    var prints: Driver<[Card]> {
        return printsVariable.asDriver()
    }

    var languages: Driver<[Card]> {
        return languagesVariable.asDriver()
    }
    
    var rulings: Driver<[CardRuling]> {
        return rulingsVariable.asDriver()
    }
    
    lazy var onPrintingSelected: Action<Card, Void> = { [unowned self] in
        return Action { [unowned self] card in
            self.cardVariable.value = card
            return .just(())
        }
    }()
    
    lazy var onAllPrint: CocoaAction = { [unowned self] in
        return CocoaAction { [unowned self] in
            if let callback = self.callback,
                let printsUrl = self.cardVariable.value.printSearchUri,
                let components = URLComponents(url: printsUrl, resolvingAgainstBaseURL: false),
                let queryItems = components.queryItems {

                return callback.execute(queryItems)
            }
            return .just(())
        }
    }()
    
    lazy var onArtist: CocoaAction = { [unowned self] in
        return CocoaAction { [unowned self] in
            return self.cardVariable.asObservable().map({
                return $0.artist
            }).filter { $0 != nil }.map { $0! }.map ({
                let token = ArtistToken(value: $0)
                let queryString = try! token.string()
                return [URLQueryItem(name: "q", value: queryString)]
            }).flatMap { [unowned self] in
                return self.callback?.execute($0) ?? .just(())
            }
        }
    }()
    
    lazy var onWatermark: CocoaAction = { [unowned self] in
        return CocoaAction { [unowned self] in
            return self.cardVariable.asObservable().map({
                return $0.watermark
            }).filter { $0 != nil }.map { $0! }.map ({
                let token = WatermarkToken(value: $0)
                let queryString = try! token.string()
                return [URLQueryItem(name: "q", value: queryString)]
            }).flatMap { [unowned self] in
                return self.callback?.execute($0) ?? .just(())
            }
        }
    }()
    
    lazy var onSet: CocoaAction = { [unowned self] in
        return CocoaAction { [unowned self] in
            return self.cardVariable.asObservable().map({
                return [URLQueryItem(name: "q", value: "set:\($0.setCode)")]
            }).flatMap { [unowned self] in
                return self.callback?.execute($0) ?? .just(())
            }
        }
    }()
    
    lazy var onLanguage: Action<Card, Void> = { [unowned self] in
        return Action { [unowned self] card in
            self.cardVariable.value = card
            return .just(())
        }
    }()
    
    lazy var onReserved: CocoaAction = { [unowned self] in
        return CocoaAction { [unowned self] in
            return self.cardVariable.asObservable().map({_ in
                let token = TraitToken(value: .inReservedList)
                let queryString = try! token.string()
                return [URLQueryItem(name: "q", value: queryString)]
            }).flatMap { [unowned self] in
                return self.callback?.execute($0) ?? .just(())
            }
        }
    }()
    
    init(card: Card, service: ScryfallServiceType, coordinator: SceneCoordinatorType, callback: Action<[URLQueryItem], Void>? = nil) {
        self.service = service
        self.coordinator = coordinator
        self.callback = callback
        
        onCancel = CocoaAction {
            return coordinator.pop()
        }
        
        cardVariable = Variable<Card>(card)
        
        super.init()
        
        cardVariable.asObservable()
            .map { card -> CombinedToken in
                var queryTokens = [QueryToken]()
                queryTokens.append(NameToken(value: .plain(card.name), exact: true, negative: false))
                queryTokens.append(UniqueToken(value: .prints))
                
                return CombinedToken(value: queryTokens)
            }
            .map { token -> String in
                return try token.string()
            }
            .distinctUntilChanged()
            .flatMap { [unowned self] in
                return self.service.search(query: $0, sort: .set, direction: .auto)
            }
            .map { cardList -> [Card] in
                return cardList.data
            }
            .bind(to: printsVariable)
            .disposed(by: disposeBag)
        
        let setObservable = cardVariable.asObservable().flatMap {
            CardSetCache.instance.set(forCode: $0.setCode)
        }
        
        setObservable
            .map { [unowned self] set -> CombinedToken in
                var queryTokens = [QueryToken]()
                queryTokens.append(NameToken(value: .plain(self.cardVariable.value.name), exact: true, negative: false))
                queryTokens.append(UniqueToken(value: .prints))
                queryTokens.append(SetToken(value: set))
                queryTokens.append(LanguageToken(value: .any))
                
                return CombinedToken(value: queryTokens)
            }
            .map { token -> String in
                return try token.string()
            }
            .distinctUntilChanged()
            .flatMap { [unowned self] token in
                return self.service.search(query: token)
            }
            .map { return $0.data }
            .bind(to: languagesVariable)
            .disposed(by: disposeBag)
        
        cardVariable.asObservable()
            .take(1)
            .flatMap { return service.rulings(card: $0, force: false) }
            .map { return $0.data }
            .bind(to: rulingsVariable)
            .disposed(by: disposeBag)
        
        callback?.executionObservables.take(1).subscribe(onNext: { _ in
            coordinator.pop()
        }).disposed(by: rx.disposeBag)
    }
}

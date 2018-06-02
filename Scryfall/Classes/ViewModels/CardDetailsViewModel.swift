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
    private let cardVariable: Variable<Card>
    private let printsVariable = Variable<[Card]>([])
    
    let service: ScryfallServiceType
    let coordinator: SceneCoordinatorType
    let onCancel: CocoaAction
    let callback: Action<[URLQueryItem], Void>?
    
    var card: Driver<Card> {
        return cardVariable.asDriver()
    }
    
    var prints: Driver<([Card], Card)> {
        return Observable.combineLatest(printsVariable.asObservable(), cardVariable.asObservable())
            .asDriver(onErrorJustReturn: ([], cardVariable.value))
    }

    lazy var onPrintingSelected: Action<Card, Void> = { [unowned self] in
        return Action { [unowned self] card in
            self.cardVariable.value = card
            return Observable.just(())
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
            return Observable.just(())
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
                return self.callback?.execute($0) ?? Observable.just(())
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
                return self.callback?.execute($0) ?? Observable.just(())
            }
        }
    }()
    
    lazy var onSet: CocoaAction = { [unowned self] in
        return CocoaAction { [unowned self] in
            return self.cardVariable.asObservable().map({
                return [URLQueryItem(name: "q", value: "set:\($0.setCode)")]
            }).flatMap { [unowned self] in
                return self.callback?.execute($0) ?? Observable.just(())
            }
        }
    }()
    
    lazy var onReserved: CocoaAction = { [unowned self] in
        return CocoaAction { [unowned self] in
            return self.cardVariable.asObservable().map({_ in
                let token = TraitToken(value: .inReservedList)
                let queryString = try! token.string()
                return [URLQueryItem(name: "q", value: queryString)]
            }).flatMap { [unowned self] in
                return self.callback?.execute($0) ?? Observable.just(())
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
            .do(onNext: { [unowned self] _ in
                self.disposeBag = DisposeBag()
            })
            .map {
                return $0.printSearchUri
            }
            .filter { $0 != nil }.map { $0! }
            .map { url -> [URLQueryItem]? in
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                return components?.queryItems
            }
            .filter { $0 != nil }.map { $0! }
            .flatMap { [unowned self] in
                return self.service.search(params: $0)
            }
            .map { cardList -> [Card] in
                return cardList.data
            }
            .bind(to: printsVariable)
            .disposed(by: disposeBag)
        
        callback?.executionObservables.take(1).subscribe(onNext: { _ in
            coordinator.pop()
        }).disposed(by: rx.disposeBag)
    }
}

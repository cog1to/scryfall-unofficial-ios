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

    lazy var onPrintingSelected: Action<Card, Void> = { this in
        return Action { card in
            this.cardVariable.value = card
            return Observable.just(())
        }
    }(self)
    
    lazy var onAllPrint: CocoaAction = { this in
        return CocoaAction {
            if let callback = this.callback,
                let printsUrl = this.cardVariable.value.printSearchUri,
                let components = URLComponents(url: printsUrl, resolvingAgainstBaseURL: false),
                let queryItems = components.queryItems {
                
                callback.execute(queryItems)
            }
            return Observable.just(())
        }
    }(self)
    
    lazy var onArtist: CocoaAction = { this in
        return CocoaAction {
            if let artist = this.cardVariable.value.artist {
                this.callback(withToken: ArtistToken(value: artist))
            }
            return Observable.just(())
        }
    }(self)
    
    lazy var onWatermark: CocoaAction = { this in
        return CocoaAction {
            if let watermark = this.cardVariable.value.watermark {
               this.callback(withToken: WatermarkToken(value: watermark))
            }
            return Observable.just(())
        }
    }(self)
    
    lazy var onSet: CocoaAction = { this in
        return CocoaAction {
            this.callback(withQueryString: "set:\(this.cardVariable.value.setCode)")
            return Observable.just(())
        }
    }(self)
    
    lazy var onReserved: CocoaAction = { this in
        return CocoaAction {
            this.callback(withToken: TraitToken(value: .inReservedList))
            return Observable.just(())
        }
    }(self)
    
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
            .do(onNext: { _ in
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
    
    private func callback(withToken token: QueryToken) {
        let queryString = try! token.string()
        callback(withQueryString: queryString)
    }
    
    private func callback(withQueryString string: String) {
        let queryItem = URLQueryItem(name: "q", value: string)
        callback?.execute([queryItem])
    }
}

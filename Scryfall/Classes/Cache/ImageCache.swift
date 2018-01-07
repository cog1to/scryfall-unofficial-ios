//
//  ImageCache.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/7/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ImageDownloader {
    private let imageCache = NSCache<NSString, UIImage>()
    
    private func set(_ image: UIImage, for url: URL) {
        imageCache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func cachedImage(for url: URL) -> UIImage? {
        return imageCache.object(forKey: url.absoluteString as NSString)
    }
    
    func image(for url: URL) -> Observable<UIImage?> {
        if let cachedImage = cachedImage(for: url) {
            return Observable.just(cachedImage)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url)).map(UIImage.init(data:))
    }
}

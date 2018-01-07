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

/**
 * Image downloader that supports caching.
 */
class ImageDownloader {
    
    /// Image cache.
    private let imageCache = NSCache<NSString, UIImage>()
    
    /**
     * Saves image for given URL in cache.
     *
     * - parameter image: Image to save
     * - parameter url: Associated URL
     */
    private func set(_ image: UIImage, for url: URL) {
        imageCache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    /**
     * Searches and returns saved image for given URL.
     *
     * - parameter url: Associated URL
     * - returns: Image associated with given URL or nil if such image isn't found
     */
    private func cachedImage(for url: URL) -> UIImage? {
        return imageCache.object(forKey: url.absoluteString as NSString)
    }
    
    /**
     * Returns an image downloaded from given URL.
     *
     * - parameter url: Image source URL
     * - returns: An observable that will emit an image downloaded from specified URL
     */
    func image(for url: URL) -> Observable<UIImage?> {
        if let cachedImage = cachedImage(for: url) {
            return Observable.just(cachedImage)
        }
        
        // Download an image, save it into cache, and pass along to the subscriber.
        return URLSession.shared.rx.data(request: URLRequest(url: url)).map(UIImage.init(data:)).do(onNext: { image in
                if let image = image {
                    self.set(image, for: url)
                }
            })
    }
}

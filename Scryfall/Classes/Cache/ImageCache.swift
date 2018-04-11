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
    
    /// Cache directory.
    private let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("cards", isDirectory: false)
    
    /**
     * Removes all files from cache directory.
     */
    private func purge() {
        do {
            if FileManager.default.fileExists(atPath: cacheDir.path, isDirectory: nil) {
                try FileManager.default.removeItem(at: cacheDir)
            }
        } catch {
            print("failed to clear cache: \(error)")
        }
    }
    
    /**
     * Saves image for given URL in cache.
     *
     * - parameter image: Image to save
     * - parameter url: Associated URL
     */
    private func set(_ image: NSData, for url: URL) {
        func save(components: [String], currentPath: URL) {
            let url = currentPath.appendingPathComponent(components.first!, isDirectory: false)
            if (components.count == 1) {
                FileManager.default.createFile(atPath: url.path, contents: image as Data, attributes: nil)
            } else {
                try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                save(components: Array<String>(components.suffix(from: 1)), currentPath: url)
            }
        }
        
        save(components: url.pathComponents, currentPath: cacheDir)
    }
    
    /**
     * Searches and returns saved image for given URL.
     *
     * - parameter url: Associated URL
     * - returns: Image associated with given URL or nil if such image isn't found
     */
    private func cachedImage(for url: URL) -> NSData? {
        do {
            let fileUrl = cacheDir.appendingPathComponent(url.path, isDirectory: false)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                let data = try Data(contentsOf: fileUrl)
                return data as NSData
            }
        } catch {
            print("failed to load cached image for \(url)")
        }
        
        return nil
    }
    
    /**
     * Returns an image downloaded from given URL.
     *
     * - parameter url: Image source URL
     * - returns: An observable that will emit an image downloaded from specified URL
     */
    func image(for url: URL) -> Observable<UIImage?> {
        return data(for: url).map {
            if let data = $0 {
                return UIImage(data: data)
            } else {
                return nil
            }
        }
    }
    
    /**
     * Returns a data downloaded from given URL.
     *
     * - parameter url: Data source URL
     * - returns: An observable that will emit a data downloaded from specified URL
     */
    func data(for url: URL) -> Observable<Data?> {
        if let cachedImage = cachedImage(for: url) {
            return Observable.just(cachedImage as Data)
        }
        
        // Download an image, save it into cache, and pass along to the subscriber.
        return URLSession.shared.rx.data(request: URLRequest(url: url)).do(onNext: { image in
            self.set(image as NSData, for: url)
        }).map { return $0 as Data }
    }
}

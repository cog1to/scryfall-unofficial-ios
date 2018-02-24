//
//  AppDelegate.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/5/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        style()
        
        let service = Scryfall()
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        let searchViewModel = CardSearchViewModel(service: service, coordinator: sceneCoordinator)
        let firstScene = Scene.search(searchViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    private func style() {
        UIApplication.shared.statusBarStyle = .lightContent
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = Style.color(forKey: .tint)
        UINavigationBar.appearance().tintColor = Style.color(forKey: .printingText)
        UINavigationBar.appearance().barTintColor = Style.color(forKey: .navigationTint)
        UISearchBar.appearance().tintColor = Style.color(forKey: .printingText)
        UITableView.appearance().separatorColor = Style.color(forKey: .gray)
        UIButton.appearance().tintColor = Style.color(forKey: .tint)
        UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = Style.color(forKey: .printingText)
    }
}


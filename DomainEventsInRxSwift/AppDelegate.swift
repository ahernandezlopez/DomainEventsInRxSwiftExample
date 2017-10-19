//
//  AppDelegate.swift
//  DomainEventsInRxSwift
//
//  Created by Albert Hernández López on 19/10/2017.
//  Copyright © 2017 Albert Hernández López. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let repository: ListingRepository = LocalListingRepository()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = TabBarController(repository: repository)
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

//
//  AppDelegate.swift
//  8-Ball
//
//  Created by Pasha Moroz on 9/4/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let dataService = DataService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        dataService.saveContext()
    }
}


//
//  AppDelegate.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    )
        -> Bool
    {
        let controller = TabBarController(controllers: [
            AnalyticViewController(),
            CitiesViewController(),
            SearchViewController()
        ])
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}


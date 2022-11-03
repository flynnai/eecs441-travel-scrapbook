//
//  AppDelegate.swift
//  swiftChatter
//
//  Created by Yuer Gao on 9/1/22.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // Override point for customization after application launch.
            
         window = UIWindow()
         if let window = window {
             window.rootViewController = UINavigationController(rootViewController: MainVC())
             window.makeKeyAndVisible()
         }
        GMSServices.provideAPIKey("AIzaSyB4S1WKEMIEt7S125oLZohrNuoqc2l_t5A")
         return true
     }

}


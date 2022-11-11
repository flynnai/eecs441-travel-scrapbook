//
//  AppDelegate.swift
//  travelscrapbookapp
//
//  Created by Aidan on 10/31/22.
//
// "AIzaSyAD3GbQN_R7ZWa-z4ApopR8DOjzJg9RL3M"
import UIKit
import GoogleMaps
import FirebaseCore

//1
let googleApiKey = "AIzaSyAD3GbQN_R7ZWa-z4ApopR8DOjzJg9RL3M"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //2
    GMSServices.provideAPIKey(googleApiKey)
      FirebaseApp.configure()
    return true
  }
}

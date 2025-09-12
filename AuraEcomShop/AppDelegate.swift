//
//  AppDelegate.swift
//  AuraEcomShop
//
//  Created by Harsh on 11/09/25.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        setDefaultFont()
        return true
    }
    func setDefaultFont() {
        // Apply Inter-Regular globally to all UILabels, UIButtons, UITextFields
        if let customFont = UIFont(name: "RobotoSlab-Regular", size: 16) {
            UILabel.appearance().font = customFont
        }
        if let customFont = UIFont(name: "RobotoSlab-Bold", size: 16) {
            UIButton.appearance().titleLabel?.font = customFont
        }
        if let customFont = UIFont(name: "RobotoSlab-Medium", size: 16) {
            UITextField.appearance().font = customFont
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


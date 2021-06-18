//
//  AppDelegate.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 16/06/2021.
//

import UIKit
import AlamofireEasyLogger
import IQKeyboardManagerSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let alamofireLogger = FancyAppAlamofireLogger(prettyPrint: true) {
        print($0)
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.makeKeyAndVisible()
        self.configureKeyboard()
        return true
    }
    
    private
    func configureKeyboard() {
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.resignFirstResponder()
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }


}


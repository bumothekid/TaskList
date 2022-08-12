//
//  AppDelegate.swift
//  TaskList
//
//  Created by David Riegel on 23.06.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        if UserDefaults.standard.array(forKey: "tasks") == nil {
//            let firstTask: [Dictionary<String, Any>] = [["title": "Your first task", "description": "Create your first task in the top right corner", "done": false, "date": "red"], ["title": "Your second first yes yeah task", "description": "How are you really today please tell me please yes mhm yeah same", "done": false, "color": "gray"]]
//            UserDefaults.standard.set(firstTask, forKey: "tasks")
//        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.rootViewController = UINavigationController(rootViewController: HomeController())
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
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


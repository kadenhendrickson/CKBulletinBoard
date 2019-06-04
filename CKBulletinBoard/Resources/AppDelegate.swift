//
//  AppDelegate.swift
//  CKBulletinBoard
//
//  Created by Kaden Hendrickson on 6/3/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let messageNotification = Notification.Name("MessageNotification")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (userResponse, error) in
            if let error = error {
                print("😝 There was an error in \(#function) : \(error) : \(error.localizedDescription) 😝")
                return
            }
            if userResponse {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        MessageController.shared.subscribeToNotifications { (error) in
            if let error = error {
                print("😝 There was an error in \(#function) : \(error) : \(error.localizedDescription) 😝")
                return
            }
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MessageController.shared.fetchMessages { (success) in
            if success {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: AppDelegate.messageNotification, object: self)
                }
            }
        }
    }
}


//
//  AppDelegate.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import Firebase
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return false }
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        DropDown.startListeningToKeyboard()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.registForNotifications(application)
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
        //device id BA161404-6BEE-47D9-B952-DACAE6337C02
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func registForNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {granted, _ in
                print("-----------Granted: \(granted)")
            })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        InstanceID.instanceID().instanceID { (result, error) in
          /*if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }*/
        }
        
        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        UserDefaults.standard.setFcmToken(token: fcmToken)
        if UserDefaults.standard.isNeedNotifications() {
            Network.shared.sendFcmTokenToAPI(token: fcmToken)
        } else {
            Network.shared.sendFcmTokenToAPI()
        }
    }
    

    
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: RootViewController {
        return self.window!.rootViewController as! RootViewController
    }
}

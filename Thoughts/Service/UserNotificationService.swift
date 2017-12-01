//
//  UserNotificationService.swift
//  Thoughts
//
//  Created by Dan Lindsay on 2017-12-01.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationService: NSObject {
    
    private override init() {}
    static let shared = UserNotificationService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "no UserNotification auth error")
            guard granted else { return }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
}

extension UserNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Notification did receive")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("user notification will present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        
        completionHandler(options)
        
    }
}

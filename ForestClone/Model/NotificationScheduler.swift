//
//  NotificationScheduler.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationScheduler {

    var id: String = ""

    let center = UNUserNotificationCenter.current()

    func createSuccessNotification(with seconds: Seconds) {

        // 1. Request authorization
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in

            if error != nil {
                print(error!)
            }

            if granted {

            } else {

            }

        }

        // 2. Create a notification content
        let content = UNMutableNotificationContent()

        content.title = "Notification Title"
        content.body = "This is the content"

        // 3. Transform the Seconds into TimeInterval and create a new Date()
        let timeInterval = TimeInterval(seconds)

        let date = Date().addingTimeInterval(timeInterval)

        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // 4. Always generate a new UUID for a new notification
        id = UUID().uuidString

        // 5. Create a Notification Request that will trigger after our focus session has finished.
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        center.add(request) { error in
            if error != nil {
                print(error!)
            }
        }

    }

    func cancelExistingNotification() {
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
}

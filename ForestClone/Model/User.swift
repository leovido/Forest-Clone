//
//  User.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

typealias UserId = String

struct User: Codable, FirebaseUserRepresentable {
    let userId: UserId
    let displayName: String
    let email: String
    let coins: Coin
    let achievements: [AchievementId]
    let currentSession: FocusSessionId?
    var completedSessions: [FocusSessionId]
}

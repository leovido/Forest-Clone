//
//  FirebaseUserRepresentable.swift
//  ForestClone
//
//  Created by Christian Leovido on 30/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

protocol FirebaseUserRepresentable {
    var userId: UserId { get }
    var displayName: String { get }
    var email: String { get }
    var coins: Coin { get }
    var achievements: [AchievementId] { get }
    var currentSession: FocusSessionId? { get }
    var completedSessions: [FocusSessionId] { get }
}

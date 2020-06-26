//
//  User.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let coins: [Coin]
    let achievements: [Achievement]
    let currentSession: FocusSession?
    var completedSessions: [FocusSession]
}

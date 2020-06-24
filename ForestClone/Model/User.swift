//
//  User.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let coins: [Coin]
    let boost: Bool
    let achievements: [Achievement]
    let completedSessions: [FocusSession]
}

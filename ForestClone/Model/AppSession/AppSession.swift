//
//  AppSession.swift
//  ForestClone
//
//  Created by Christian Leovido on 26/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

enum AppSession {

    static var user: FirebaseUserRepresentable = User(userId: "9f136642-110d-4302-bac2-e58443730584",
                                                      displayName: "Christian",
                                                      email: "test@test.com",
                                                      coins: 1000,
                                                      achievements: [],
                                                      currentSession: nil,
                                                      completedSessions: [])

}

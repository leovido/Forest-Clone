//
//  FocusSession.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

typealias Seconds = Int
typealias FocusSessionId = String

struct FocusSession: Codable {

    enum FocusSesionStatus: String, Codable {
        case idle
        case started
        case completed
        case cancelled
    }

    var id: FocusSessionId = UUID().uuidString
    var treeId: TreeId = ""
    var date: Date = Date()

    var tag: TagSession = TagSession(name: "work", color: "blue")
    var status: FocusSesionStatus
    var time: Seconds = 600

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case time
        case date
        case treeId
    }

}

// Decodable: JSON -> FocusSession
// Encodable: FocusSession -> JSON

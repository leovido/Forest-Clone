//
//  TreeSpecimen.swift
//  ForestClone
//
//  Created by Christian Leovido on 19/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

typealias Minutes = Int
typealias TreeId = String

struct TreeSpecimen: Codable {
    let id: TreeId
    let name: String
    let description: String
    let cost: Int
    var image: String
    let states: [TreeStates] = []
}

struct TreeStates: Codable {
    let time: Minutes
    let image: String
}

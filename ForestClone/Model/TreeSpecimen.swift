//
//  TreeSpecimen.swift
//  ForestClone
//
//  Created by Christian Leovido on 19/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

typealias Minutes = Int

struct TreeSpecimen: Decodable {
    let name: String
    let description: String
    let cost: Int
    var image: String
    let states: [TreeStates]
}

struct TreeStates: Decodable {
    let time: Minutes
    let image: String
}

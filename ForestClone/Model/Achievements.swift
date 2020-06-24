//
//  Achievements.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

struct Achievement: Decodable {
    let name: String
    let description: String
    let image: String
    let cost: Int
}

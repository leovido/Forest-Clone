//
//  Phrases.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

enum PhraseType {
    case `default`
    case success
    case failure
}

var phrases: [PhraseType: [String]] = [
    .default: [
        "Don't look at me",
        "Stop phubbing!",
        "Go back to your work!",
        "Plant a tree and get your things done.",
        "Stay focused!"
    ],
    .success: [

    ],
    .failure: [
    ]
]

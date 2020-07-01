//
//  FirebaseStorageManager.swift
//  ForestClone
//
//  Created by Christian Leovido on 30/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

// swiftlint:disable type_name

protocol Storage {

    associatedtype T
    associatedtype U

    var sessionStorage: T { get }
    var userStorage: U { get }
}

final class FirebaseStorageManager<T: NetworkingRequestable, U: NetworkingRequestable>: Storage {

    let sessionStorage: T
    let userStorage: U

    init(sessionStorage: T, userStorage: U) {
        self.sessionStorage = sessionStorage
        self.userStorage = userStorage
    }
}

// swiftlint:enable type_name

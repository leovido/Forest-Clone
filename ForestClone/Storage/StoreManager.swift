//
//  StoreManager.swift
//  ForestClone
//
//  Created by Christian Leovido on 01/07/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

protocol StoringManager {
    static func storage<T: NetworkingRequestable>(model: Codable) -> T
}

enum MockStorageManager: StoringManager {
    static func storage<T: NetworkingRequestable>(model: Codable) -> T {
        if T.Model.self == FocusSession.self {
            return FirebaseStorage<FocusSession>(referenceName: "focusSession") as! T
        } else {
            return FirebaseStorage<User>(referenceName: "appUser") as! T
        }
    }
}

enum StorageManager: StoringManager {
    static func storage<T: NetworkingRequestable>(model: Codable) -> T {
        if T.Model.self == FocusSession.self {
            return FirebaseStorage<FocusSession>(referenceName: "focusSession") as! T
        } else {
            return FirebaseStorage<User>(referenceName: "appUser") as! T
        }
    }
}

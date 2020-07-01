//
//  MockFirebaseStorage.swift
//  ForestClone
//
//  Created by Christian Leovido on 30/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

class MockFirebaseStorage<T: Codable>: NetworkingRequestable {

    typealias Model = T
    typealias Service = Void

    let referenceName: String
    let modelReference: Service

    /// Create an initialiser with a custom `referenceName`
    /// for any custom model that you want to access in Firebase.
    init(referenceName: String) {
        self.referenceName = referenceName
        self.modelReference = ()
    }

    // 1. C - Create
    func create(entry: Model, completion: @escaping (Bool) -> Void) {

    }

    // 2. R - Read
    func read(id: String, completion: @escaping (Model) -> Void) {

    }

    // 3. U - Update
    func update(id: String, data: [String: Any], completion: @escaping (Model) -> Void) {

    }

    // 4. D - Delete
    func delete(id: String, completion: @escaping (Bool) -> Void) {

    }

}

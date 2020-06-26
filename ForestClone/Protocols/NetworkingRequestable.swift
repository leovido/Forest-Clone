//
//  NetworkingRequestable.swift
//  ForestClone
//
//  Created by Christian Leovido on 25/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import FirebaseDatabase

/// This protocols adhere to `CRUD`. The four basic functions of persistent storage.
/// C - Create
/// R - Read
/// U - Update
/// D - Delete
protocol NetworkingRequestable {

    // The Model allows you to store any Swift object in a database.
    associatedtype Model

    var referenceName: String { get }
    var modelReference: DatabaseReference { get }

    func create(entry: Model, completion: @escaping (Bool) -> Void)
    func read(id: String, completion: @escaping (Model) -> Void)
    func update(id: String, data: [String: Any], completion: @escaping (Model) -> Void)
    func delete(id: String, completion: @escaping (Bool) -> Void)

}

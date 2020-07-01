//
//  FirebaseUserStorage.swift
//  ForestClone
//
//  Created by Christian Leovido on 25/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import FirebaseDatabase

// The T type refers to any Swift object that conforms to Codable.
class FirebaseStorage<T: Codable>: NetworkingRequestable {

    typealias Model = T
    typealias Service = DatabaseReference

    let referenceName: String
    let databaseReference: DatabaseReference
    let modelReference: DatabaseReference

    /// Create an initialiser with a custom `referenceName`
    /// for any custom model that you want to access in Firebase.
    init(referenceName: String) {
        self.referenceName = referenceName
        self.databaseReference = Database.database().reference()
        self.modelReference = self.databaseReference.child(referenceName)
    }

    // 1. C - Create
    func create(entry: Model, completion: @escaping (Bool) -> Void) {

        do {

            // 2. Encode our entry. It has to conform to Codable
            let data = try JSONEncoder().encode(entry)

            guard let json = try JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as? [String: Any] else {
                completion(false)
                return
            }

            // 3. Get the id to store it as a key in the database
            guard let id = json["id"] as? String else {
                completion(false)
                return
            }

            modelReference.child(id).updateChildValues(json)

            completion(true)

        } catch let error {
            print(error)
            completion(false)
        }

    }

    // 2. R - Read
    func read(id: String, completion: @escaping (Model) -> Void) {

        modelReference
            .child(id)
            .observeSingleEvent(of: .value, with: { snapshot in

                guard let model = snapshot.value as? Model else {
                    return
                }

                completion(model)

            })

    }

    // 3. U - Update
    func update(id: String, data: [String: Any], completion: @escaping (Model) -> Void) {

        modelReference
            .child(id)
            .updateChildValues(data) { error, _ in

                if let error = error {
                    print(error)
                } else {
                    print("Entry with id: \(id) has been successfully updated!")
                }
        }

    }

    // 4. D - Delete
    func delete(id: String, completion: @escaping (Bool) -> Void) {

        modelReference
            .child(id)
            .removeValue { error, _ in

                if let error = error {
                    print(error.localizedDescription)
                }

                print("Successfully deleted: \(id)")

        }

    }

}

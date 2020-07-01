//
//  FirebaseStorage.swift
//  ForestClone
//
//  Created by Christian Leovido on 24/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import FirebaseDatabase

/// Example of a concrete FirebaseStorage implementation that will only use FocusSession.
/// The other `GenericFirebaseStorage` on the other hand, handles any Swift object that conforms to Codable.
class FirebaseFocusSessionStorage: NetworkingRequestable {

    typealias Model = FocusSession

    let referenceName: String = "focusSession"
    let databaseReference: DatabaseReference
    let modelReference: DatabaseReference

    init() {
        self.databaseReference = Database.database().reference()
        self.modelReference = databaseReference.child(referenceName)
    }

    // 1. Create
    func create(entry: FocusSession, completion: (Bool) -> Void) {

        do {
            let data = try JSONEncoder().encode(entry)
            guard let json = try JSONSerialization
                .jsonObject(with: data,
                            options: .allowFragments) as? [String: Any] else {
                return
            }

            modelReference.childByAutoId().updateChildValues(json)

            completion(true)

        } catch let error {
            print(error)
            completion(false)
        }

    }

    // 2. Read
    func read(id: String, completion: @escaping (FocusSession) -> Void) {

    }

    // 3. Update
    func update(id: String, data: [String: Any], completion: @escaping (FocusSession) -> Void) {

    }

    // 4. Delete
    func delete(id: String, completion: (Bool) -> Void) {

    }
}

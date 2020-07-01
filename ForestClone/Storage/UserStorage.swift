//
//  UserStorage.swift
//  ForestClone
//
//  Created by Christian Leovido on 30/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import Firebase

final class UserStorage: NetworkingService, FirebaseInterface {

    typealias Model = User
    typealias Service = DatabaseReference

    let referenceName: String = "user"
    var modelReference: DatabaseReference

    init() {
        self.modelReference = DatabaseReference().child(referenceName)
    }

    func create(data: [String: Any], completion: @escaping (Result<Bool, Error>) -> Void) {

        guard let id = data["userId"] as? String else {
            fatalError("JSON needs a userId")
        }

        modelReference.child(id).updateChildValues(data) { error, _ in

            if let error = error {
                completion(Result.failure(error))
            } else {
                completion(Result.success(true))
            }
        }
    }

    func read(id: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {

        modelReference.child(id).observeSingleEvent(of: .value, with: { snapshot in

            guard let value = snapshot.value as? [String: Any] else {
                return
            }

            completion(Result.success(value))

        }, withCancel: { error in
            print(error.localizedDescription)
        })

    }

    func readAll(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {

        modelReference.observeSingleEvent(of: .value, with: { snapshot in

            guard let values = snapshot.value as? [[String: Any]] else {
                return
            }

            completion(Result.success(values))

        }) { error in
            completion(Result.failure(error))
        }

    }

    func update(id: String,
                data: [String: Any],
                completion: @escaping (Result<[String: Any], Error>) -> Void) {

        modelReference.child(id).updateChildValues(data) { error, _ in
            if let error = error {
                completion(Result.failure(error))
            } else {

                guard let value = self.modelReference.value(forKey: id) as? [String: Any] else {
                    return
                }

                completion(Result.success(value))
            }
        }
    }

    func delete(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        modelReference.child(id).removeValue()
    }

}

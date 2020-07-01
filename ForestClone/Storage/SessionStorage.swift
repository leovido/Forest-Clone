//
//  SessionStorage.swift
//  ForestClone
//
//  Created by Christian Leovido on 30/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import Firebase

final class SessionStorage: NetworkingService, FirebaseInterface {

    typealias Model = FocusSession
    typealias Service = DatabaseReference

    let referenceName: String = "focusSession"
    var modelReference: DatabaseReference

    init() {
        self.modelReference = Database.database().reference().child(referenceName)
    }

    func create(data: [String: Any], completion: @escaping (Result<Bool, Error>) -> Void) {

        guard let id = data["focusSessionId"] as? String else {
            fatalError("JSON needs a focusSessionId")
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

        guard let value = modelReference.value(forKey: id) as? [String: Any] else {
            return
        }

        completion(Result.success(value))

    }

    func readAll(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {

        modelReference.observe(.value, with: { snap in
            guard let value = snap.value as? [String: Any] else {
                return
            }

            let values = value.compactMap({ $0.value as? [String: Any] })

            completion(Result.success(values))

        }) { error in
            print(error)
        }
    }

    func update(id: String, data: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {

        modelReference.child(id).updateChildValues(data) { error, _ in
            if let error = error {
                completion(Result.failure(error))
            } else {

                self.modelReference
                    .child(id)
                    .observeSingleEvent(of: .value, with: { snapshot in

                    guard let json = snapshot.value as? [String: Any] else {
                        return
                    }

                    completion(Result.success(json))

                })

            }
        }
    }

    func delete(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        modelReference.child(id).removeValue()
    }

}

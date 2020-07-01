//
//  FirebaseAuthManager.swift
//  ForestClone
//
//  Created by Christian Leovido on 30/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

protocol AuthenticationRepresentable {

    var semaphore: DispatchSemaphore { get }

    func signup(email: String, password: String) -> Result<AuthDataResult, Error>
    func signin(email: String, password: String, completion: @escaping () -> Void)
    func signout() throws

}

final class FirebaseAuthManager<T: NetworkingService> {

    let storage: T
    let semaphore = DispatchSemaphore(value: 0)

    init(storage: T) {
        self.storage = storage
    }

    func setUserListener() {
        _ = Auth.auth().addStateDidChangeListener { (_, user) in

            guard let user = user else {
                return
            }

            self.storage.read(id: user.uid) { _ in
//                AppSession.user = userModel
            }
        }
    }

    func signout() throws {
        try Auth.auth().signOut()
    }

    func signup(email: String, password: String) -> Result<AuthDataResult, Error> {

        var result: Result<AuthDataResult, Error>!

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

            if let error = error {
                result = Result.failure(error)
                self.semaphore.signal()
            }

            guard let authResult = authResult else {
                return
            }

            result = Result.success(authResult)
            self.semaphore.signal()

        }

        _ = semaphore.wait(wallTimeout: .distantFuture)

        return result
    }

    func signin(email: String, password: String, completion: @escaping () -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            }

            guard authResult != nil else {
                return
            }

            completion()
        }

    }
}

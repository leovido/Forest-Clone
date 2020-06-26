//
//  Home+Extension+Database.swift
//  ForestClone
//
//  Created by Christian Leovido on 26/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import CodableFirebase

extension HomeViewController {

    func createFirebaseEntry() {
        self.firebaseFocusSessionStorage.create(entry: self.session) { success in
            if success {
                print("Successfully create a new entry in Firebase")
            } else {
                print("Something happened and it wasn't stored in Firebase")
            }
        }
    }

    func fetchLatestSession(completion: @escaping (Bool) -> Void) {

        firebaseFocusSessionStorage.modelReference
            .observeSingleEvent(of: .value, with: { snapshot in

            guard let value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }

            // transform the dictionary to get an Array of values.
            let values = value.compactMap({ $0.value })

            do {
                let models = try FirebaseDecoder()
                    .decode([FocusSession].self, from: values)
                    .sorted(by: { $0.date < $1.date })

                guard let latestActiveSession = models.last else {
                    return
                }

                self.session = latestActiveSession

                completion(true)

            } catch let error {
                print(error)

                completion(false)

            }

        })

    }

    @objc func updateSession(notification: Notification) {

        guard let sessionInfo = notification.userInfo else {
            return
        }

        guard let focusSessionId = sessionInfo["focusSessionId"] as? String else {
            return
        }

        firebaseFocusSessionStorage.update(id: focusSessionId, data: ["status": FocusSession.FocusSesionStatus.completed.rawValue]) { focusSession in

            self.currentUser.completedSessions.append(focusSession)

            self.updateUserStorage()

        }
    }

    private func updateUserStorage() {
        do {
            let data = try JSONEncoder().encode(self.currentUser)

            guard let jsonUser = try JSONSerialization
                .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return
            }

            self.firebaseUserStorage.update(id: self.currentUser.id,
                                            data: jsonUser) { _ in

                                                print("user updated")
            }

        } catch let error {
            print(error)
        }
    }
}

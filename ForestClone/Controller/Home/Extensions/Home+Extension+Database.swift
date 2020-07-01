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

    func createFirebaseEntry() throws {
        viewModel.service.create(data: try session.encodeToJSON()) { result in

            switch result {
                case .success:
                print("Successfully create a new entry in Firebase")

                case .failure(let error):
                    print("Something happened and it wasn't stored in Firebase: \(error.localizedDescription)")
            }
        }
    }

    func fetchLatestSession(completion: @escaping (Bool) -> Void) {

        viewModel.service.readAll { result in

            switch result {
                case .success(let values):

                do {

                    let models = try FirebaseDecoder()
                        .decode([FocusSession].self, from: values)
                        .filter({ $0.status == .started })
                        .sorted(by: { $0.date < $1.date })

                    guard let latestActiveSession = models.last else {
                        return
                    }

                    // Check if the latest session has finished by comparing the Date
                    let expectedDateFinished = latestActiveSession.date.addingTimeInterval(TimeInterval(latestActiveSession.time))

                    if expectedDateFinished > Date() {
                        self.session = latestActiveSession
                        self.session.focusSessionId = latestActiveSession.focusSessionId
                        completion(true)
                    } else {
                        self.viewModel.service
                            .update(id: self.session.focusSessionId,
                                    data: ["status": "completed"]) { updatedSession in

                            // update user sessions here...

                            completion(true)

                        }
                    }

                } catch let error {
                    print(error)

                    completion(false)

                }

                case .failure:
                completion(false)
            }
        }
    }

    func updateUserStorage() {
        do {

            guard let user = self.currentUser as? User else {
                return
            }

            let data = try JSONEncoder().encode(user)

            guard let jsonUser = try JSONSerialization
                .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return
            }

            self.firebaseUserStorage.update(id: self.currentUser.userId,
                                            data: jsonUser) { _ in

                                                print("user updated")
            }

        } catch let error {
            print(error)
        }
    }
}

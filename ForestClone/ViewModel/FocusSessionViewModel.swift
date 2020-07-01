//
//  FocusSessionViewModel.swift
//  ForestClone
//
//  Created by Christian Leovido on 30/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import Firebase

struct FocusSessionViewModel {

    let service: NetworkingService

    init(service: NetworkingService = SessionStorage()) {
        self.service = service
    }

    func fetchData(completion: @escaping ([FocusSession]) -> Void) {

        service.readAll { result in

            switch result {
            case .success(let json):

                do {

                    let data          = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let focusSessions = try JSONDecoder().decode([FocusSession].self, from: data)

                    completion(focusSessions)

                } catch let error {
                    print(error.localizedDescription)
                }

            case .failure(let error):
                print(error.localizedDescription)
            }

        }

    }

}

//
//  NetworkingService.swift
//  ForestClone
//
//  Created by Christian Leovido on 01/07/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

protocol NetworkingService {

    func create(data: [String: Any], completion: @escaping (Result<Bool, Error>) -> Void)
    func read(id: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
    func readAll(completion: @escaping (Result<[[String: Any]], Error>) -> Void)
    func update(id: String, data: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void)
    func delete(id: String, completion: @escaping (Result<Bool, Error>) -> Void)

}

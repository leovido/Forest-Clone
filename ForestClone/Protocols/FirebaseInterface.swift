//
//  FirebaseInterface.swift
//  ForestClone
//
//  Created by Christian Leovido on 01/07/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

protocol FirebaseInterface {

    // The Model allows you to store any Swift object in a database.
    associatedtype Model
    associatedtype Service

    var referenceName: String { get }
    var modelReference: Service { get }

}

//
//  MenuSliderDelegate.swift
//  ForestClone
//
//  Created by Christian Leovido on 27/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

protocol MenuSliderDelegate: class {
    func performSegue(with name: String)
    func configureView(isSliderPresented: Bool)
}

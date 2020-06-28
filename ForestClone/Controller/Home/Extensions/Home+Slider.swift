//
//  Home+Slider.swift
//  ForestClone
//
//  Created by Christian Leovido on 28/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit

extension HomeViewController: MenuSliderDelegate {
    func performSegue(with name: String) {
        performSegue(withIdentifier: name, sender: self)
    }
}

//
//  TreeSpecimenManager.swift
//  ForestClone
//
//  Created by Christian Leovido on 26/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import UIKit

struct TreeSpecimenManager {
    let availableTrees: [TreeId] = []
    let selectedTree: TreeSpecimen = TreeSpecimen(id: "", name: "tree", description: "", cost: 0, image: "tree")


    func updateTreeImage(with seconds: Seconds) -> UIImage {

        let minutes = seconds / 60

        if minutes <= 55 {

            let imageTree = selectedTree.image + "-1"

            return UIImage(named: imageTree) ?? UIImage(named: "tree-1")!

        } else if minutes <= 90 {

            let imageTree = selectedTree.image + "-2"

            return UIImage(named: imageTree) ?? UIImage(named: "tree-1")!

        } else if minutes < 120 {

            let imageTree = selectedTree.image + "-3"

            return UIImage(named: imageTree) ?? UIImage(named: "tree-1")!

        } else if minutes == 120 {

            let imageTree = selectedTree.image + "-4"

            return UIImage(named: imageTree) ?? UIImage(named: "tree-1")!

        } else {

            let imageTree = selectedTree.image + "-5"

            return UIImage(named: imageTree) ?? UIImage(named: "tree-1")!
        }

    }

}

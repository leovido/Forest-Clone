//
//  ForestAlertCustom.swift
//  ForestClone
//
//  Created by Christian Leovido on 29/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import SCLAlertView

protocol AlertPresentable {
    func presentSuccessAlert()
    func presentFailureAlert()
    func presentItems()
}

extension SCLAlertView: AlertPresentable {}

extension AlertPresentable where Self: SCLAlertView {
    func presentSuccessAlert() {
        showSuccess("You've Got", subTitle: "This tree")
    }

    func presentFailureAlert() {
        showError("It'll be better next time!", subTitle: "")
    }

    func presentItems() {
        showSuccess("You've Got", subTitle: "This tree", circleIconImage: UIImage(systemName: "person"))

    }
}

final class CustomAlertPresenter {
    let presenter: AlertPresentable = SCLAlertView()
}

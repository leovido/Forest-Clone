//
//  Home+Slider.swift
//  ForestClone
//
//  Created by Christian Leovido on 28/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import SideMenu

extension HomeViewController: MenuSliderDelegate {
    func performSegue(with name: String) {
        performSegue(withIdentifier: name, sender: self)
    }

    func configureView(isSliderPresented: Bool) {

        if isSliderPresented {

            view.viewWithTag(1000)?.removeFromSuperview()

        } else {
            let overlayView = UIView(frame: self.view.frame)
            overlayView.tag = 1000
            overlayView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)
            overlayView.alpha = 0

            UIView.animate(withDuration: 0.25, animations: {
                overlayView.alpha = 1.0
            })

            self.view.addSubview(overlayView)
        }

    }

    @objc func menuSidebarConfiguration() {

        guard let menu = storyboard!.instantiateViewController(
            withIdentifier: "SideMenuNavigationController"
            ) as? SideMenuNavigationController else {
                fatalError("SideMenuNavigationController not implemented")
        }

        configureView(isSliderPresented: false)

        menu.presentationStyle = .menuDissolveIn
        menu.menuWidth = 200
        menu.blurEffectStyle = .dark

        guard let menuViewController = menu.viewControllers.first as? MenuTableViewController else {
            return
        }

        present(menu, animated: true) {
            menuViewController.homeDelegate = self
        }
    }
}

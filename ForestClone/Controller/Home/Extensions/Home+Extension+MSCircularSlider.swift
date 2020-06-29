//
//  Home+Extension+MSCircularSlider.swift
//  ForestClone
//
//  Created by Christian Leovido on 26/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import MSCircularSlider

extension HomeViewController: MSCircularSliderDelegate {

    func configureSlider() {
        // 1. Instantiate the slider
        slider = MSCircularSlider(frame: sliderView.frame)
        slider.currentValue = 20

        // 2. The minimum value is 0
        slider.minimumValue = 0
        slider.maximumValue = 120
        slider.maximumRevolutions = 0
        slider.handleEnlargementPoints = 10
        slider.handleColor = ColorScheme.timerFilled
        slider.filledColor = ColorScheme.timerFilled
        slider.unfilledColor = ColorScheme.timerUnfilled
        slider.lineWidth = 15

        slider.delegate = self
        view.addSubview(slider)
    }

    func circularSlider(_ slider: MSCircularSlider, valueChangedTo value: Double, fromUser: Bool) {

        if value < 10 {
            timerValue = 600
            timerLabel.text = "10:00"
        } else {

            if Int(value) % 5 == 0 {

                timerLabel.text = displayTime(value: value)
                timerValue = Int(value) * 60
                session.time = timerValue

                currentTreeImage.image = treeSpecimenManager.updateTreeImage(with: timerValue)


            }
        }
    }

}

//
//  Home+Timer.swift
//  ForestClone
//
//  Created by Christian Leovido on 28/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation

extension HomeViewController {

    func updateTimerState() {

         // 1. Calculate the time elapsed from the existing session if it's already started and not completed.

        if self.session.status == .started {
            let timeElapsed = Date().timeIntervalSince(self.session.date)
            self.timerValue = Int(timeElapsed)

            self.timer = self.processTimer()
        } else {
            self.timerLabel.text = self.timeFormatted(time: self.timerValue)
        }

    }

    func timeFormatted(time: Seconds) -> String {

        let minutes: Int = time / 60
        let seconds: Int = time % 60

        return String(format: "%02i:%02i", minutes, seconds)
    }

    func processTimer() -> Timer {

        // 1. Return a new Timer with custom logic
        return Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in

            // 2. When it reaches 0, we show the slider again and invalidate the Timer.
            if self.timerValue == 0 {

                // 3. TODO: Present an alert with a reward

                self.timerLabel.text = self.timeFormatted(time: self.timerValue)
                self.customAlertPresenter.presenter.presentSuccessAlert()
                self.timer.invalidate()

            } else {

                // 5. Update the timerLabel.text
                self.timerValue -= 1
                self.timerLabel.text = self.timeFormatted(time: self.timerValue)

                // 6. Update phrase every 15 seconds

                if self.timerValue % 15 == 0 {
                    self.phraseLabel.text = phrases[.default]!.randomElement()!
                }
            }

        }

    }

    func displayTime(value: Double) -> String {
        Int(value).description + ":00"
    }

}

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

        let timeElapsed = Date().timeIntervalSince(session.date.addingTimeInterval(TimeInterval(session.time)))

        if timeElapsed < 0 {
            viewModel.service.update(id: session.focusSessionId, data: ["status": "completed"]) { result in
                switch result {
                case .success(let json):
                    print(json)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            if self.session.status == .started {

                timerValue = Int(timeElapsed)

                timer = processTimer {
                    self.updateTimer()
                }

            } else {
                timerLabel.text = timeFormatted(time: timerValue)
            }
        }

    }

    func timeFormatted(time: Seconds) -> String {

        let minutes: Int = time / 60
        let seconds: Int = time % 60

        return String(format: "%02i:%02i", minutes, seconds)
    }

    func processTimer(with completion: @escaping () -> Void) -> Timer {

        return Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            completion()
        }

    }

    func updateTimer() {

        if timerValue == 0 {

            timerLabel.text = timeFormatted(time: timerValue)
            customAlertPresenter.presenter.presentSuccessAlert()
            timer?.invalidate()

        } else {

            // Update the timerLabel
            timerValue -= 1
            timerLabel.text = timeFormatted(time: timerValue)

            // Update phrase every 15 seconds
            if timerValue % 15 == 0 {
                phraseLabel.text = phrases[.default]!.randomElement()!
            }
        }

    }

    func displayTime(value: Double) -> String {
        Int(value).description + ":00"
    }

}

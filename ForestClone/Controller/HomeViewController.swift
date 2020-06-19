//
//  ViewController.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import MSCircularSlider
import SideMenu

class HomeViewController: UIViewController {

    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var currentTreeImage: UIImageView!

    @IBOutlet weak var menuButton: UIButton!
    @IBAction func menuButton(_ sender: Any) {

        let menu = storyboard!.instantiateViewController(
            withIdentifier: "SideMenuNavigationController"
        ) as! SideMenuNavigationController

        menu.presentationStyle = .menuDissolveIn
        menu.menuWidth = 200
        menu.blurEffectStyle = .dark
        
        present(menu, animated: true, completion: nil)

    }


    @IBOutlet weak var plantButton: UIButton!

    var notificationScheduler: NotificationScheduler! = NotificationScheduler()

    weak var timer: Timer!

    var slider: MSCircularSlider!
    var timerValue: Int! = 20

    var session = FocusSession()

    @IBAction func plantButton(_ sender: Any) {

        if !session.sessionStarted {

            self.phraseLabel.text = phrases[.default]!.randomElement()!

            self.timer = processTimer()

            self.notificationScheduler.createSuccessNotification(with: self.session.time)

            self.session.sessionStarted = true
            self.plantButton.setTitle("Give Up", for: .normal)

        } else {

            self.presentAlert(type: .failure)
            self.timer.invalidate()
            self.notificationScheduler.cancelExistingNotification()

            self.slider?.alpha = 1
            self.timerLabel.text = timeFormatted(time: self.session.time)
            self.session.sessionStarted = false
            self.plantButton.setTitle("Plant", for: .normal)

        }

    }

    deinit {
        timer.invalidate()
        timer = nil
        notificationScheduler = nil

        slider = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSlider()

    }

    func timeFormatted(time: Seconds) -> String {
        let minutes: Int = time / 60
        let seconds: Int = time % 60

        return String(format: "%02i:%02i", minutes, seconds)
    }

    func processTimer() -> Timer {

        // 1. Hide the slider
        slider?.alpha = 0

        // 2. Return a new Timer with custom logic
        return Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in

            // 3. When it reaches 0, we show the slider again and invalidate the Timer.
            if self.timerValue == 0 {

                // 4. TODO: Present an alert with a reward

                // 5. Show the slider
                self.slider?.alpha = 1
                self.timer.invalidate()
            }

            // 3.1. Update the timerLabel.text
            self.timerValue -= 1
            self.timerLabel.text = self.timeFormatted(time: self.timerValue)

            // 3.2. Update phrase every 15 seconds

            if self.timerValue % 15 == 0 {
                self.phraseLabel.text = phrases[.default]!.randomElement()!
            }
        }

    }

    func displayTime(value: Double) -> String {
        Int(value).description + ":00"
    }

    func circularSlider(_ slider: MSCircularSlider, valueChangedTo value: Double, fromUser: Bool) {

        if value < 10 {
            self.timerValue = 600
            self.timerLabel.text = "10:00"
        } else {

            if Int(value) % 5 == 0 {

                self.timerLabel.text = displayTime(value: value)
                self.timerValue = Int(value) * 60
                self.session.time = self.timerValue

                updateTreeImage(with: self.timerValue)

            }
        }
    }

    func updateTreeImage(with seconds: Seconds) {

        let minutes = seconds / 60

        if minutes <= 55 {

            let imageTree = self.session.tree.name + "-1"

            self.session.tree.image = imageTree
            self.currentTreeImage.image = UIImage(named: imageTree)

        } else if minutes <= 90 {

            let imageTree = self.session.tree.name + "-2"

            self.session.tree.image = imageTree
            self.currentTreeImage.image = UIImage(named: imageTree)

        } else if minutes < 120 {

            let imageTree = self.session.tree.name + "-3"

            self.session.tree.image = imageTree
            self.currentTreeImage.image = UIImage(named: imageTree)

        } else if minutes == 120 {

            let imageTree = self.session.tree.name + "-4"

            self.session.tree.image = imageTree
            self.currentTreeImage.image = UIImage(named: imageTree)

        } else {

            let imageTree = self.session.tree.name + "-1"

            self.session.tree.image = imageTree
            self.currentTreeImage.image = UIImage(named: imageTree)
        }

    }

    func presentAlert(type: ForestAlert) {

        var alert: UIAlertController!

        if type == .failure {
            alert = UIAlertController(title: "It'll be better next time!",
                                          message: "",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil))
        } else {
            alert = UIAlertController(title: "You've Got",
                                          message: "",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil))
        }


        self.present(alert, animated: true, completion: nil)
    }

}

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

}

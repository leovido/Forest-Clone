//
//  ViewController.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import UIKit
import MSCircularSlider
import SideMenu
import CodableFirebase

class HomeViewController: UIViewController {

    // - MARK: IBOutlets
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var currentTreeImage: UIImageView!

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var plantButton: UIButton!

    // - MARK: IBActions
    @IBAction func menuButton(_ sender: Any) {
        menuSidebarConfiguration()
    }

    let notificationScheduler: NotificationScheduler = NotificationScheduler()

    weak var timer: Timer!

    var slider: MSCircularSlider!
    var timerValue: Int! = 600

    var currentUser = AppSession.user
    var session = FocusSession(status: .idle)
    let treeSpecimenManager = TreeSpecimenManager()

    // - MARK: Firebase Database Storage
    let firebaseFocusSessionStorage: FirebaseStorage = {
        FirebaseStorage<FocusSession>(referenceName: "focusSession")
    }()
    let firebaseUserStorage: FirebaseStorage = {
        FirebaseStorage<User>(referenceName: "appUser")
    }()

    @IBAction func plantButton(_ sender: Any) {

        if session.status != .started {

            phraseLabel.text = generateRandomPhrase()
            timer = processTimer()

            notificationScheduler.createSuccessNotification(with: 5,
                                                            and: session.id)

            session.date = Date()
            session.status = .started
            plantButton.setTitle("Give Up", for: .normal)

            createFirebaseEntry()

        } else {

            presentAlert(type: .failure)
            timer?.invalidate()
            notificationScheduler.cancelExistingNotification(id: session.id)

            slider?.alpha = 1
            timerLabel.text = timeFormatted(time: session.time)
            session.status = .cancelled
            plantButton.setTitle("Plant", for: .normal)

        }

    }

    deinit {
        timer.invalidate()
        timer = nil

        slider = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchLatestSession { success in

            if success {
                self.updateTimerState()
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSlider()
        setupNotificationCenter()
        configureTapForTreeSelection()

    }

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

    @objc func treeManager() {

    }

    func configureTapForTreeSelection() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(treeManager))

        currentTreeImage.isUserInteractionEnabled = true
        currentTreeImage.addGestureRecognizer(tapGestureRecognizer)
    }

    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSession),
                                               name: Notification.Name("sessionFinished"),
                                               object: nil)
    }

    func generateRandomPhrase() -> String {

        guard let allPhrases = phrases[.default] else {
            return ""
        }

        guard let randomPhrase = allPhrases.randomElement() else {
            return ""
        }

        return randomPhrase
    }

    private func menuSidebarConfiguration() {
        let menu = storyboard!.instantiateViewController(
            withIdentifier: "SideMenuNavigationController"
            ) as! SideMenuNavigationController

        menu.presentationStyle = .menuDissolveIn
        menu.menuWidth = 200
        menu.blurEffectStyle = .dark

        present(menu, animated: true, completion: nil)
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
                self.timerLabel.text = self.timeFormatted(time: self.timerValue)

                self.timer.invalidate()

            } else {

                // 3.1. Update the timerLabel.text
                self.timerValue -= 1
                self.timerLabel.text = self.timeFormatted(time: self.timerValue)

                // 3.2. Update phrase every 15 seconds

                if self.timerValue % 15 == 0 {
                    self.phraseLabel.text = phrases[.default]!.randomElement()!
                }
            }

        }

    }

    func displayTime(value: Double) -> String {
        Int(value).description + ":00"
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

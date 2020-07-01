//
//  ViewController.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import UIKit
import Firebase
import MSCircularSlider
import SideMenu
import CodableFirebase

class HomeViewController: UIViewController {

    // - MARK: IBOutlets
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var currentTreeImage: UIImageView!

    @IBOutlet weak var plantButton: UIButton!

    @IBOutlet weak var giveUpButton: UIButton!
    @IBAction func giveUpButton(_ sender: Any) {

        customAlertPresenter.presenter.presentFailureAlert()
        timer?.invalidate()
        notificationScheduler.cancelExistingNotification(id: session.focusSessionId)

        viewModel.service.update(id: session.focusSessionId, data: ["status": "cancelled"]) { updatedSession in
            print(updatedSession)
        }

        timerLabel.text = timeFormatted(time: session.time)
        session.status = .cancelled

    }

    // - MARK: IBActions
    @IBAction func menuButton(_ sender: Any) {
        menuSidebarConfiguration()
    }

    let notificationScheduler: NotificationScheduler = NotificationScheduler()
    let customAlertPresenter: CustomAlertPresenter = CustomAlertPresenter()

    weak var timer: Timer!

    var slider: MSCircularSlider!
    var timerValue: Int! = 600

    var currentUser = AppSession.user
    var session = FocusSession(status: .idle) {
        didSet {
            if session.status == .started {
                plantButton.isHidden = true
                giveUpButton.isHidden = false
                slider.alpha = 0
            } else {
                plantButton.isHidden = false
                giveUpButton.isHidden = true
                slider?.alpha = 1
            }
        }
    }
    let treeSpecimenManager = TreeSpecimenManager()

    // - MARK: Firebase Database Storage
    let viewModel: FocusSessionViewModel = FocusSessionViewModel()
    let firebaseUserStorage = UserStorage()

    let firebaseAuthManager = FirebaseAuthManager(storage: UserStorage())

    @IBAction func plantButton(_ sender: Any) {

        phraseLabel.text = generateRandomPhrase(phrases: phrases, type: .default)

        session.date = Date().addingTimeInterval(TimeInterval(session.time))
        timerValue = session.time

        timer = processTimer {
            self.updateTimer()
        }

        _ = notificationScheduler
            .createSuccessNotification(with: session.time, and: session.focusSessionId)
            .map({ success in

                if success {
                    self.session.date = Date()
                    self.session.status = .started

                    try! self.createFirebaseEntry()
                }

            })

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

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(menuSidebarConfiguration))

        firebaseAuthManager.setUserListener()
        firebaseAuthManager.signin(email: "test@test.com", password: "pass123") {

        }

    }

    @objc func updateSession(notification: Notification) {

        guard let sessionInfo = notification.userInfo else {
            return
        }

        guard let focusSessionId = sessionInfo["focusSessionId"] as? String else {
            return
        }

        viewModel.service.update(id: focusSessionId, data: ["status": FocusSession.FocusSesionStatus.completed.rawValue]) { focusSession in
            self.updateUserStorage()
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

    @objc func treeManager() {
        customAlertPresenter.presenter.presentItems()
    }

    func configureTapForTreeSelection() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(treeManager))

        slider.isUserInteractionEnabled = true
        slider.addGestureRecognizer(tapGestureRecognizer)
    }

    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSession),
                                               name: Notification.Name("sessionFinished"),
                                               object: nil)
    }

    func generateRandomPhrase(phrases: [PhraseType: [String]], type: PhraseType) -> String? {
        phrases[type]?.randomElement()
    }

}

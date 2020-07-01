//
//  ForestCloneTests.swift
//  ForestCloneTests
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
import SwiftRandom
@testable import ForestClone

class HomeViewTests: XCTestCase {

    var homeViewController: HomeViewController!

    override func setUpWithError() throws {

        homeViewController = sutNavigationSetup()

        homeViewController.viewWillAppear(false)
        homeViewController.viewDidLoad()

    }

    override func tearDownWithError() throws {
        homeViewController = nil
    }

    func testTimer() throws {

        let timer = homeViewController.processTimer {

        }

        homeViewController.timer = timer

        XCTAssertEqual(timer.timeInterval, 1)

    }

    func testSlider() throws {

        homeViewController.configureSlider()

        let slider = homeViewController.slider

        XCTAssertEqual(slider?.minimumValue, 0)
        XCTAssertEqual(slider?.maximumValue, 120)
        XCTAssertEqual(slider?.maximumRevolutions, 0)
        XCTAssertEqual(slider?.handleEnlargementPoints, 10)
        XCTAssertEqual(slider?.handleColor, ColorScheme.timerFilled)
        XCTAssertEqual(slider?.filledColor, ColorScheme.timerFilled)
        XCTAssertEqual(slider?.unfilledColor, ColorScheme.timerUnfilled)
        XCTAssertEqual(slider?.lineWidth, 15)

    }

    func testTimerLabel() throws {

        let randomSeconds = Seconds.random(1...1200)
        let formattedTime = homeViewController.timeFormatted(time: randomSeconds)

        let timeComponents = formattedTime.components(separatedBy: ":")

        let minutes = timeComponents[0]
        let seconds = timeComponents[1]

        let expectedMinutes = randomSeconds / 60
        let expectedSeconds = randomSeconds % 60

        homeViewController.timerLabel.text = formattedTime

        XCTAssertEqual(homeViewController.timerLabel.text, formattedTime)

        XCTAssertEqual(minutes, String(format: "%02i", expectedMinutes))
        XCTAssertEqual(seconds, String(format: "%02i", expectedSeconds))

    }

    func testGestureRecognizer() throws {

        homeViewController.configureSlider()
        homeViewController.configureTapForTreeSelection()

        XCTAssertNotNil(homeViewController.slider.gestureRecognizers?.first)

        homeViewController.treeManager()

    }

    func testGenerateRandomPhrase() throws {

        let mockPhrases = [PhraseType.default: [Randoms.randomFakeConversation(),
                                                Randoms.randomFakeConversation(),
                                                Randoms.randomFakeConversation(),
                                                Randoms.randomFakeConversation(),
                                                Randoms.randomFakeConversation()]]

        let randomPhrase = homeViewController.generateRandomPhrase(phrases: mockPhrases, type: .default)
        homeViewController.phraseLabel.text = randomPhrase

        XCTAssertEqual(homeViewController.phraseLabel.text, randomPhrase)

    }

    func testPlantButton() {

        homeViewController.plantButton.sendActions(for: .touchUpInside)

    }

    func sutNavigationSetup<T: UIViewController>() -> T {

        var homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController<FirebaseStorage<FocusSession>, FirebaseStorage<User>>

        let navigationController = UINavigationController()

        UIApplication.shared.keyWindow!.rootViewController = navigationController
        navigationController.pushViewController(homeViewController, animated: false)

        homeViewController = navigationController.topViewController as! HomeViewController<FirebaseStorage<FocusSession>, FirebaseStorage<User>>
        homeViewController.loadView()

        return homeViewController as! T
    }
}

//
//  ForestViewController.swift
//  ForestClone
//
//  Created by Christian Leovido on 26/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import Charts
import SceneKit
import SwiftRandom

enum DateDataType: String {
    case day
    case week
    case month
    case year
}

protocol ChartDelegate: class {
    func updateBarChartView(dateDataType: DateDataType)
}

class ForestViewController: UIViewController {

    weak var barChartDelegate: ChartDelegate?

    // 1. This is too long and needs refactoring. We can use a function to automatically generate dummy data.
    // See `randomFocusSessionData`

    /*
    let completedSessions: [FocusSession] = [
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date.randomWithinDaysBeforeToday(200))),
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date.randomWithinDaysBeforeToday(200))),
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date.randomWithinDaysBeforeToday(200))),
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date.randomWithinDaysBeforeToday(200))),
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date.randomWithinDaysBeforeToday(200)))
    ]
     */

    var completedSessions: [FocusSession] {
        randomFocusSessionData(numberOfEntries: 30)
    }

    @IBOutlet weak var dateSegmentedControl: UISegmentedControl!
    @IBAction func dateSegmentedControl(_ sender: Any) {

        switch dateSegmentedControl.selectedSegmentIndex {
        case 0:
            barChartDelegate?.updateBarChartView(dateDataType: .day)
        case 1:
            barChartDelegate?.updateBarChartView(dateDataType: .week)
        case 2:
            barChartDelegate?.updateBarChartView(dateDataType: .month)
        case 3:
            barChartDelegate?.updateBarChartView(dateDataType: .year)
        default:
            break
        }

    }

    @IBOutlet weak var forestTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.parent?.title = "Overview"

        forestTableView.delegate = self
        forestTableView.dataSource = self

        forestTableView.backgroundColor = ColorScheme.secondaryGreen

        view.backgroundColor = ColorScheme.secondaryGreen

    }

}

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

enum DateDataType: String {
    case day
    case week
    case month
    case year
}

protocol BarChartDelegate: class {
    func updateBarChartView(dateDataType: DateDataType)
}

class ForestViewController: UIViewController {

    weak var barChartDelegate: BarChartDelegate?

    let completedSessions: [FocusSession] = [
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date())),
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date())),
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date())),
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date())),
        FocusSession(treeId: "", status: .completed, time: Int.random(in: 600...7200), date: Date(timeInterval: TimeInterval.random(in: 3600...1000000), since: Date()))
    ]

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

        forestTableView.delegate = self
        forestTableView.dataSource = self

        forestTableView.backgroundColor = ColorScheme.secondaryGreen
        
        view.backgroundColor = ColorScheme.secondaryGreen

    }

}

extension ForestViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ForestCanvasCell.identifier, for: indexPath) as? ForestCanvasCell else {
                return UITableViewCell()
            }

            return cell
            
        }

        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BarChartCell.identifier, for: indexPath) as? BarChartCell else {
                return UITableViewCell()
            }

            barChartDelegate = cell
            cell.configureCell(completedSessions: completedSessions)

            return cell
            
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return 280
        } else if indexPath.row == 1 {
            return 300
        } else {
            return 10
        }
    }


}

extension ForestViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

}

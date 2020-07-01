//
//  TreesOverviewViewController.swift
//  ForestClone
//
//  Created by Christian Leovido on 01/07/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit

class TreesOverviewViewController: UITableViewController {

//    let data: [Int: [FocusSession]] = [
//        0: randomFocusSessionData(numberOfEntries: 3),
//        1: randomFocusSessionData(numberOfEntries: 9),
//        2: randomFocusSessionData(numberOfEntries: 2),
//        3: randomFocusSessionData(numberOfEntries: 5)
//    ]

    var data: [Int: [FocusSession]] = [:]

    let viewModel: FocusSessionViewModel = FocusSessionViewModel()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.fetchData { sessions in
            self.data = self.groupSessionsToData(sessions: sessions)
            self.tableView.reloadData()
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

    }

    func groupSessionsToData(sessions: [FocusSession]) -> [Int: [FocusSession]] {

        var newData = [Int: [FocusSession]]()

        let grouped = Dictionary(grouping: sessions) {
            $0.date.formatDate(with: "EEE / dd")
        }

        var count = 0
        for (_, value) in grouped {
            newData[count] = value
            count += 1
        }

        return newData

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TreeOverviewCell.identifier,
            for: indexPath
        ) as? TreeOverviewCell else {
            fatalError("TreeOverviewCell not implemented")
        }

        guard let sectionData = data[indexPath.section] else {
            return UITableViewCell()
        }

        cell.configureCell(session: sectionData[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.textColor = .white
            headerView.textLabel?.backgroundColor = .blue
            headerView.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }

    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard let sectionData = data[section] else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE / MMM dd"

        let title = dateFormatter.string(from: sectionData.first!.date)

        return title

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }

}

private func randomFocusSessionData(numberOfEntries: Int) -> [FocusSession] {

    let todayData = Array(0..<10)
        .map({ _ in
            FocusSession(userId: AppSession.user.userId,
                         treeId: "",
                         date: Date(timeInterval: TimeInterval.random(in: 3600...1000000),
                                    since: Date.randomWithinDaysBeforeToday(0)),
                         status: .completed,
                         time: Int.random(in: 600...7200)
            )
        })

    let monthData = Array(0..<10)
        .map({ _ in
            FocusSession(userId: AppSession.user.userId,
                         treeId: "",
                         date: Date(timeInterval: TimeInterval.random(in: 3600...1000000),
                                    since: Date.randomWithinDaysBeforeToday(20)),
                         status: .completed,
                         time: Int.random(in: 600...7200)
            )
        })

    let randomDates = Array(0..<numberOfEntries)
        .map({ _ in
            FocusSession(userId: AppSession.user.userId,
                         treeId: "",
                         date: Date(timeInterval: TimeInterval.random(in: 3600...1000000),
                                    since: Date.randomWithinDaysBeforeToday(200)),
                         status: .completed,
                         time: Int.random(in: 600...7200))
        })

    let historyData = todayData + monthData + randomDates

    return historyData

}

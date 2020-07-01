//
//  Forest+TableView+Delegate+DataSource.swift
//  ForestClone
//
//  Created by Christian Leovido on 28/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit

extension ForestViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
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

        } else if indexPath.row == 2 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: PieChartCell.identifier, for: indexPath) as? PieChartCell else {
                return UITableViewCell()
            }

            cell.configureCell(completedSessions: completedSessions)

            return cell

        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "TreesOverviewViewController") as? TreesOverviewViewController else {
            return
        }

        if indexPath.row == 0 {
            present(vc, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return 280
        } else if indexPath.row == 1 {
            return 300
        } else if indexPath.row == 2 {
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

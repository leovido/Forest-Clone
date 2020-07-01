//
//  TreeOverviewCell.swift
//  ForestClone
//
//  Created by Christian Leovido on 01/07/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit

class TreeOverviewCell: UITableViewCell {

    static let identifier = "TreeOverviewCell"

    @IBOutlet weak var treeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!

    @IBOutlet weak var deleteEntryButton: UIButton!
    @IBAction func deleteEntryButton(_ sender: Any) {

        // 1. Present alert to delete record

    }

    func configureCell(session: FocusSession) {

        let sessionDateStarted = session.date
        let sessionDateEnd = session.date.addingTimeInterval(TimeInterval(session.time))

        timeLabel.text = sessionDateStarted.formatDate(with: "HH:mm") + " - " + sessionDateEnd.formatDate(with: "HH:mm")
        timeSpentLabel.text = (session.time / 60).description + " " + session.tag.name
        treeImage.image = UIImage(named: "tree-1")

    }

}


extension Date {

    func formatDate(with format: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.string(from: self)

    }

}

//
//  Forest+Extensions+RandomData.swift
//  ForestClone
//
//  Created by Christian Leovido on 28/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import Foundation
import SwiftRandom

extension ForestViewController {

    func randomFocusSessionData(numberOfEntries: Int) -> [FocusSession] {

        let todayData = Array(0..<10)
            .map({ _ in
                FocusSession(treeId: "",
                             date: Date(timeInterval: TimeInterval.random(in: 3600...1000000),
                                        since: Date.randomWithinDaysBeforeToday(0)),
                             status: .completed,
                             time: Int.random(in: 600...7200)
                )
            })

        let monthData = Array(0..<10)
            .map({ _ in
                FocusSession(treeId: "",
                             date: Date(timeInterval: TimeInterval.random(in: 3600...1000000),
                                        since: Date.randomWithinDaysBeforeToday(20)),
                             status: .completed,
                             time: Int.random(in: 600...7200)
                )
            })

        let randomDates = Array(0..<numberOfEntries)
            .map({ _ in
                FocusSession(treeId: "",
                             date: Date(timeInterval: TimeInterval.random(in: 3600...1000000),
                                        since: Date.randomWithinDaysBeforeToday(200)),
                             status: .completed,
                             time: Int.random(in: 600...7200))
            })

        let historyData = todayData + monthData + randomDates

        return historyData

    }
}

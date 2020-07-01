//
//  XYMarkerView.swift
//  ForestClone
//
//  Created by Christian Leovido on 26/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import Charts

class XYMarkerView: BalloonMarker {
    var xAxisValueFormatter: IAxisValueFormatter
    fileprivate var yFormatter = NumberFormatter()

    init(color: UIColor,
         font: UIFont,
         textColor: UIColor,
         insets: UIEdgeInsets,
         xAxisValueFormatter: IAxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let timeFormatted = formatValueToTime(entry: entry)
        setLabel(timeFormatted)
    }

    func formatValueToTime(entry: ChartDataEntry) -> String {

        let time = Int(entry.y)

        let hours: Int = time / 60
        let minutes: Int = time % 60

        if hours == 0 {
            return String(format: "%2iM", minutes)
        } else {
            return String(format: "%2iH %2iM", hours, minutes)
        }

    }

}

//
//  PieChartCell.swift
//  ForestClone
//
//  Created by Christian Leovido on 27/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import Charts

extension PieChartCell: ChartDelegate {
}

class PieChartCell: UITableViewCell {

    static let identifier = "PieChartCell"

    private var pieChartView: PieChartView!
    private var dataLabels = [String]()

    private var completedSessions: [FocusSession] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        configureBarChart()
        configureBarChartLayout()

        addSubview(pieChartView)

        backgroundColor = ColorScheme.secondaryGreen

    }

    func configureCell(completedSessions: [FocusSession]) {
        self.completedSessions = completedSessions
    }

    private func configureBarChart() {
        updateBarChartView(dateDataType: .day)
    }

    private func configureBarChartLayout() {

    }

    func generateDataSet(dateDataType: DateDataType, date: Date) -> Int {

        switch dateDataType {
        case .day:
            return 24
        case .month:
            return date.getDaysInMonth()
        case .week:
            return 7
        case .year:
            return 12
        }

    }

    func extractDateComponents(dateDateType: DateDataType, date: Date) -> (DateComponents, DateComponents) {

        let calendar = Calendar.current

        switch dateDateType {
        case .day:
            let currentDate = calendar.dateComponents([.day, .month, .year], from: Date())
            let sessionDate = calendar.dateComponents([.day, .month, .year], from: date)

            return (currentDate, sessionDate)
        case .week:
            let currentDate = calendar.dateComponents([.weekOfYear, .month, .year], from: Date())
            let sessionDate = calendar.dateComponents([.weekOfYear, .month, .year], from: date)

            return (currentDate, sessionDate)
        case .month:
            let currentDate = calendar.dateComponents([.month, .year], from: Date())
            let sessionDate = calendar.dateComponents([.month, .year], from: date)

            return (currentDate, sessionDate)
        case .year:
            let currentDate = calendar.dateComponents([.year], from: Date())
            let sessionDate = calendar.dateComponents([.year], from: date)

            return (currentDate, sessionDate)
        }
    }

    func getComponent(dateDataType: DateDataType, date: Date) -> Int {

        let calendar = Calendar.current

        switch dateDataType {
        case .day:
            return calendar.component(.hour, from: date)
        case .week:
            return calendar.component(.weekday, from: date)
        case .month:
            return calendar.component(.day, from: date)
        case .year:
            return calendar.component(.month, from: date)
        }

    }

    func compareDates(dateDataType: DateDataType, date: Date) -> Bool {

        let (currentDate, sessionDate) = extractDateComponents(dateDateType: dateDataType, date: date)

        return currentDate == sessionDate

    }

    func updateBarChartView(dateDataType: DateDataType) {

        let chartDataSet = PieChartDataSet(
            entries: [ChartDataEntry(x: 0, y: 10),
                      ChartDataEntry(x: 10, y: 40),
                      ChartDataEntry(x: 20, y: 80)],
            label: ""
        )

        chartDataSet.colors = ChartColorTemplates.vordiplom()

        let chartData = PieChartData(dataSet: chartDataSet)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        chartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        chartData.setValueFont(.systemFont(ofSize: 11, weight: .light))
        chartData.setValueTextColor(.black)

        let chart = PieChartView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 300))
        chart.backgroundColor = .clear
        chart.data = chartData

        pieChartView = chart

        for view in self.subviews {
            view.removeFromSuperview()
        }

        addSubview(pieChartView)

    }

}

extension PieChartCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}

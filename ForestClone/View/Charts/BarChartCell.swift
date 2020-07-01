//
//  BarChartCell.swift
//  ForestClone
//
//  Created by Christian Leovido on 26/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import Charts

extension BarChartCell: ChartDelegate {}

class BarChartCell: UITableViewCell {

    static let identifier = "BarChartCell"

    private var barChartView: BarChartView!
    private var dataLabels = [String]()

    private var completedSessions: [FocusSession] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        configureBarChart()
        configureBarChartLayout(dateDataType: .day)

        addSubview(barChartView)

        backgroundColor = ColorScheme.secondaryGreen

    }

    func configureCell(completedSessions: [FocusSession]) {
        self.completedSessions = completedSessions
    }

    private func configureBarChart() {
        updateBarChartView(dateDataType: .day)
    }

    private func configureBarChartLayout(dateDataType: DateDataType) {

        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.drawAxisLineEnabled = false
        xAxis.labelTextColor = .white
        xAxis.granularity = 1

        switch dateDataType {
            case .day, .month:
            xAxis.labelCount = 5
            case .week:
            xAxis.labelCount = 7
            case .year:
            xAxis.labelCount = 12
        }

        xAxis.valueFormatter = self

        let rightAxis = barChartView.rightAxis
        rightAxis.drawLabelsEnabled = false

        let leftAxis = barChartView.leftAxis
        leftAxis.labelTextColor = .white

        barChartView.doubleTapToZoomEnabled = false
        barChartView.animate(xAxisDuration: 1, yAxisDuration: 1)

        let marker = XYMarkerView(color: UIColor.gray,
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 0, bottom: 10, right: 0),
                                  xAxisValueFormatter: barChartView.xAxis.valueFormatter!)
        marker.chartView = barChartView
        marker.minimumSize = CGSize(width: 40, height: 40)
        barChartView.marker = marker

    }

    func generateDataSet(dateDataType: DateDataType, date: Date) -> [String] {

        switch dateDataType {
        case .day:
            return Array(0...23).map({ $0.description })
        case .month:
            return Array(1...date.getDaysInMonth()).map({ $0.description })
        case .week:
            return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        case .year:
            return Array(1...12).map({ $0.description })
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

    func setDataCount(dateDataType: DateDataType) -> [BarChartDataEntry] {

        var dataEntries: [BarChartDataEntry] = []

        let filteredSessionsByDateDataType = completedSessions
            .filter {
                compareDates(dateDataType: dateDataType, date: $0.date)
            }
            .map {
                return (dateComponent: getComponent(dateDataType: dateDataType, date: $0.date),
                        time: $0.time)
        }

        dataLabels = generateDataSet(dateDataType: dateDataType, date: Date())

        var timeCount = [Int]()

        for i in 0..<dataLabels.count {

            if let val = filteredSessionsByDateDataType.first(where: { $0.dateComponent == i }) {
                timeCount.append(val.time)
            } else {
                timeCount.append(0)
            }
        }

        for i in 0..<timeCount.count {

            let dataEntry = BarChartDataEntry(x: Double(i),
                                              y: Double(timeCount[i]))

            dataEntries.append(dataEntry)
        }

        return dataEntries

    }

    func updateBarChartView(dateDataType: DateDataType) {

        // 1. Create the entries, in this case, sessions logged from Firebase
        let dataEntries = setDataCount(dateDataType: dateDataType)

        // 2. Create a data set. This is the number of days, weeks, months, years displayed in the X Axis.
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors = [UIColor(red: 0.58, green: 0.81, blue: 0.07, alpha: 1.00)]
        chartDataSet.highlightColor = .white

        // 3. Create the chart data with the data set above.
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.85

        let chart = BarChartView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 300))
        chart.backgroundColor = .clear
        chart.data = chartData
        chart.legend.enabled = false

        barChartView = chart

        for view in self.subviews {
            view.removeFromSuperview()
        }

        addSubview(barChartView)

        configureBarChartLayout(dateDataType: dateDataType)

    }

}

extension BarChartCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}

extension Date {

    func getDaysInMonth() -> Int {

        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self),
                                            month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        return numDays
    }

    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }

}

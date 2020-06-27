//
//  PieChartCell.swift
//  ForestClone
//
//  Created by Christian Leovido on 27/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import Charts

extension PieChartCell: BarChartDelegate {}

class PieChartCell: UITableViewCell {

    static let identifier = "PieChartCell"

    var barChartView: BarChartView!
    var dataLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var completedSessions: [FocusSession]!

    override func awakeFromNib() {
        super.awakeFromNib()

        configureBarChart()
        configureBarChartLayout()

        addSubview(barChartView)

        backgroundColor = ColorScheme.secondaryGreen

    }

    func configureCell() {

    }

    private func configureBarChart() {
        updateBarChartView(dateDataType: .day)
    }

    private func configureBarChartLayout() {

        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.drawAxisLineEnabled = false
        xAxis.labelTextColor = .white
        xAxis.labelCount = 7
        xAxis.granularity = 1

        xAxis.valueFormatter = self

        let rightAxis = barChartView.rightAxis
        rightAxis.drawLabelsEnabled = false

        let leftAxis = barChartView.leftAxis
        leftAxis.labelTextColor = .white

        barChartView.doubleTapToZoomEnabled = false
        barChartView.animate(xAxisDuration: 1, yAxisDuration: 1)

        let l = barChartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4

        let marker = XYMarkerView(color: UIColor.gray,
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 0, bottom: 10, right: 0),
                                  xAxisValueFormatter: barChartView.xAxis.valueFormatter!)
        marker.chartView = barChartView
        marker.minimumSize = CGSize(width: 40, height: 40)
        barChartView.marker = marker

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

        var dataEntries: [BarChartDataEntry] = []

        let filteredSessionsByDateDataType = completedSessions
            .filter {
                compareDates(dateDataType: dateDataType, date: $0.date)
            }
            .map {
                return (dateComponent: getComponent(dateDataType: dateDataType, date: $0.date),
                        time: $0.time)
        }

        let xAxisValues = generateDataSet(dateDataType: dateDataType, date: Date())

        dataLabels = Array([0...xAxisValues].map({ $0.description }))

        var visitorCounts = [Int]()

        for i in 0..<xAxisValues {

            if let val = filteredSessionsByDateDataType.first(where: { $0.dateComponent == i }) {
                visitorCounts.append(val.time)
            } else {
                visitorCounts.append(0)
            }
        }


        for i in 0..<visitorCounts.count {

            let dataEntry = BarChartDataEntry(x: Double(i),
                                              y: Double(visitorCounts[i]))

            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.colors = [UIColor(red: 0.58, green: 0.81, blue: 0.07, alpha: 1.00)]
        chartDataSet.highlightColor = .white

        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.85

        let chart = BarChartView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 300))
        chart.backgroundColor = .clear
        chart.data = chartData


        barChartView = chart

        for view in self.subviews {
            view.removeFromSuperview()
        }

        addSubview(barChartView)

    }

}

extension PieChartCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}

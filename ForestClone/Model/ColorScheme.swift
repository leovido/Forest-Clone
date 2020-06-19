//
//  ColorScheme.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit

enum ColorScheme {
    static let mainGreen = UIColor(red: 0.31, green: 0.64, blue: 0.53, alpha: 1.00)
    static let timerUnfilled = UIColor(red: 0.73, green: 0.76, blue: 0.44, alpha: 1.00)
    static let timerFilled = UIColor(red: 0.55, green: 0.76, blue: 0.19, alpha: 1.00)

    static let secondaryGreen = UIColor(red: 0.22, green: 0.50, blue: 0.41, alpha: 1.00)
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

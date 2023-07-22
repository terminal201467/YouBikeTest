//
//  UIColor.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/22.
//

import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        var cleanedHex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cleanedHex.hasPrefix("#") {
            cleanedHex.remove(at: cleanedHex.startIndex)
        }

        if cleanedHex.count != 6 {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

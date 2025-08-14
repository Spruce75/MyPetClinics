//
//  UIColor+Extensions.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.6.2025.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    static let searchBarBackgroundColor = UIColor(hex: 0x767680, alpha: 0.12)
    static let searchBarBackgroundColorDark = UIColor(hex: 0x767680, alpha: 0.24)

    
    static let gradient = [
        UIColor(hex: 0xFD4C49),
        UIColor(hex: 0x33CF69),
        UIColor(hex: 0x007BFA)
    ]
}

extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format: "#%06x", rgb)
    }
}

extension UIColor {
    static let dynamicLabelColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor.black
                default:
                    return UIColor.white
                }
            }
        } else {
            return UIColor.white
        }
    }()
}

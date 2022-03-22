//
//  UIColor+RGBA.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/7/17.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(uiColor: UIColor(rgb))
    }
}

#elseif canImport(AppKit)
import AppKit
typealias UIColor = NSColor
extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(nsColor: UIColor(rgb))
    }
}
#endif

public extension UIColor {
    struct RGB: Hashable, Codable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }

    internal convenience init(_ rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }

    var rgb: RGB {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }
}

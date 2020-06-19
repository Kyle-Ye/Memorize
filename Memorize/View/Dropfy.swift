//
//  Dropfy.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct Dropfy: AnimatableModifier {
    var height: CGFloat
    var opacity: Double

    var animatableData: AnimatablePair<CGFloat, Double> {
        get {
            AnimatablePair(height, opacity)
        }
        set {
            height = newValue.first
            opacity = newValue.second
        }
    }

    init(showAnimation: Bool) {
        height = showAnimation ? 180 : 0
        opacity = showAnimation ? 0 : 1
    }

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .transformEffect(CGAffineTransform(translationX: 0, y: height))
    }
}

extension View {
    func dropfy(showAnimation: Bool) -> some View {
        modifier(Dropfy(showAnimation: showAnimation))
    }
}

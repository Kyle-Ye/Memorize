//
//  Cardify.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/18.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var faceUpColor: Color
    var rotation: Double
    var isFaceUp: Bool {
        rotation < 90
    }

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    init(isFaceUp: Bool, faceUpColor: Color) {
        rotation = isFaceUp ? 0 : 180
        self.faceUpColor = faceUpColor
    }

    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                    .fill(faceUpColor)
                RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                    .stroke(lineWidth: edgeLineWidth)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }

    private let cornerRadius: CGFloat = 20
    private let edgeLineWidth: CGFloat = 6
}

extension View {
    func cardify(isFaceUp: Bool, faceUpColor: Color) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, faceUpColor: faceUpColor))
    }
}

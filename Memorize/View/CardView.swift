//
//  CardView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }

    func body(for size: CGSize) -> some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                    .stroke(lineWidth: edgeLineWidth)
                Text(self.card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius)
                }
            }
        }
        .font(.system(size: fontSize(for: size)))
        .foregroundColor(Color.orange)
    }

    // MARK: - Drawing Constants

    let cornerRadius: CGFloat = 10
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    let aspectRatio: CGFloat = 2.0 / 3.0
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.width) * fontScaleFactor
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                CardView(card: MemoryGame<String>.Card(id: 3, isFaceUp: true, content: "🐶"))
                CardView(card: MemoryGame<String>.Card(id: 3, isFaceUp: false, content: "🐷"))
            }
            HStack {
                CardView(card: MemoryGame<String>.Card(id: 3, isFaceUp: false, content: "🐶"))
                CardView(card: MemoryGame<String>.Card(id: 3, isFaceUp: true, content: "🐷"))
            }
        }
    }
}

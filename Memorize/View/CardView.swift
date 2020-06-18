//
//  CardView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var viewModel: EmojiMemoryGame

    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(20 - 90), clockwise: true)
                    .padding(5)
                    .opacity(0.2)
                Text(self.card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .font(.system(size: fontSize(for: size)))
            .foregroundColor(viewModel.theme.cardFaceDownColor)
            .transition(.scale)
        }
    }

    // MARK: - Drawing Constants

    private let cornerRadius: CGFloat = 20
    private let edgeLineWidth: CGFloat = 6
    private let fontScaleFactor: CGFloat = 0.7
    private let aspectRatio: CGFloat = 2.0 / 3.0
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.width) * fontScaleFactor
    }
}

struct CardView_Previews: PreviewProvider {
    static let world = EmojiMemoryGame()
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
        .environmentObject(world)
    }
}

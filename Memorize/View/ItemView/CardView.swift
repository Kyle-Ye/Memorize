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
            body(for: geometry.size)
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }

    @State private var animatedBonusRemaining: Double = 0

    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90), clockwise: true)
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockwise: true)
                    }
                }
                .padding(5)
                .opacity(0.2)
                .transition(.identity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp, faceUpColor: Color(viewModel.theme.cardFaceUpColor))
            .font(.system(size: fontSize(for: size)))
            .foregroundColor(Color(viewModel.theme.cardFaceDownColor))
            .transition(.scale)
        }
    }

    // MARK: - Drawing Constants

    private let fontScaleFactor: CGFloat = 0.7
    private let aspectRatio: CGFloat = 2.0 / 3.0
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.width) * fontScaleFactor
    }
}

struct CardView_Previews: PreviewProvider {
    static let world = EmojiMemoryGame(theme: EmojiMemoryThemeStore().themes.randomElement()!)
    static var previews: some View {
        VStack {
            HStack {
                CardView(card: MemoryGame<String>.Card(id: 3, content: "🐶", isFaceUp: true))
                CardView(card: MemoryGame<String>.Card(id: 3, content: "🐷", isFaceUp: false))
            }
            HStack {
                CardView(card: MemoryGame<String>.Card(id: 3, content: "🐶", isFaceUp: false))
                CardView(card: MemoryGame<String>.Card(id: 3, content: "🐷", isFaceUp: true))
            }
        }
        .environmentObject(world)
    }
}

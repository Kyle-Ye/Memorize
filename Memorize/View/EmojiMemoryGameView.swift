//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

// View
import SwiftUI

struct EmojiMemoryGameView: View {
    @EnvironmentObject var viewModel: EmojiMemoryGame
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Button("New Game") {
                    self.viewModel.newGame()
                }.font(.system(size: self.fontSize(for: geometry.size, fontScaleFactor: self.newGameFontFactor)))

                Grid(self.viewModel.cards) { card in
                    CardView(card: card).onTapGesture {
                        self.viewModel.choose(card: card)
                    }

                    .padding(5)
                }
                .padding()
                HStack {
                    Text("score: \(self.viewModel.score)")
                        .font(.system(size: self.fontSize(for: geometry.size, fontScaleFactor: self.scoreFontFactor)))
                        .padding(.leading)
                    Spacer()
                    Text("Theme: \(self.viewModel.theme.name)")
                        .font(.system(size: self.fontSize(for: geometry.size, fontScaleFactor: self.themeFontFactor)))
                        .padding(.trailing)
                }
            }
        }
    }

    // MARK: - Drawing Constants

    let newGameFontFactor: CGFloat = 0.05
    let scoreFontFactor: CGFloat = 0.05
    let themeFontFactor: CGFloat = 0.04
    func fontSize(for size: CGSize, fontScaleFactor: CGFloat) -> CGFloat {
        min(size.width, size.width) * fontScaleFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static let world = EmojiMemoryGame()
    static var previews: some View {
        Group {
            EmojiMemoryGameView()
                .environmentObject(world)
                .previewDevice("iPhone Xs")
            EmojiMemoryGameView()
                .environmentObject(world)
                .previewDevice("iPad Pro (12.9-inch)")
        }
    }
}

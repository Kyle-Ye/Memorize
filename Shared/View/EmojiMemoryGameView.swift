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
    @EnvironmentObject var game: EmojiMemoryGame
    @State private var scoreDatas = [scoreData]()
    @State private var showAlert = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Grid(game.cards) { card in
                        CardView(card: card).onTapGesture {
                            withAnimation(.linear(duration: 0.75)) {
                                let old = game.score
                                game.choose(card: card)
                                let new = game.score
                                if new != old {
                                    scoreDatas.append(scoreData(content: new - old, index: game.cards.firstIndex(matching: card)!))
                                }
                                if game.cards.filter({ !$0.isMatched }).isEmpty {
                                    showAlert = true
                                }
                            }
                        }
                        .padding(5)
                    }

                    ForEach(scoreDatas) { scoreData in
                        ScoreView(score: scoreData.content)
                            .position(GridLayout(itemCount: game.cards.count, in: geometry.size).location(ofItemAt: scoreData.index))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    scoreDatas.remove(at: scoreDatas.firstIndex(matching: scoreData)!)
                                }
                            }
                    }
                }
                Text("\("Score".getLocalized()):  \(game.score)")
                    .font(.system(size: fontSize(for: geometry.size, fontScaleFactor: scoreFontFactor)))
                    .foregroundColor(Color(game.theme.cardFaceDownColor))
            }
        }
        #if os(iOS)
        .navigationBarItems(trailing: Button("Reset".getLocalized()) {
            withAnimation(.easeInOut) {
                game.resetGame()
            }
        })
        .navigationBarTitle(game.theme.name)
        #endif
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Over".getLocalized()), message: Text("\("Your score is".getLocalized()) \(game.score)"),
                  dismissButton: .default(Text("Reset".getLocalized()), action: {
                      game.resetGame()
                  }))
        }
    }

    // MARK: - Drawing Constants

    let scoreFontFactor: CGFloat = 0.05
    func fontSize(for size: CGSize, fontScaleFactor: CGFloat) -> CGFloat {
        min(size.width, size.width) * fontScaleFactor
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static let world = EmojiMemoryGame(theme: EmojiMemoryThemeStore().themes.randomElement()!)
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

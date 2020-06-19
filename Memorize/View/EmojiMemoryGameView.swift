//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

// View
import SwiftUI

struct scoreData: Identifiable {
    var id: Int {
        index
    }

    var content: Int
    var index: Int
}

struct EmojiMemoryGameView: View {
    @EnvironmentObject var game: EmojiMemoryGame
    @State private var scoreDatas = [scoreData]()
    @State private var showAlert = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Grid(self.game.cards) { card in
                        CardView(card: card).onTapGesture {
                            withAnimation(.linear(duration: 0.75)) {
                                let old = self.game.score
                                self.game.choose(card: card)
                                let new = self.game.score
                                if new != old {
                                    self.scoreDatas.append(scoreData(content: new - old, index: self.game.cards.firstIndex(matching: card)!))
                                }
                                if self.game.cards.filter({ !$0.isMatched }).isEmpty {
                                    self.showAlert = true
                                }
                            }
                        }
                        .padding(5)
                    }

                    ForEach(self.scoreDatas) { scoreData in
                        ScoreView(score: scoreData.content)
                            .position(GridLayout(itemCount: self.game.cards.count, in: geometry.size).location(ofItemAt: scoreData.index))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.scoreDatas.remove(at: self.scoreDatas.firstIndex(matching: scoreData)!)
                                }
                            }
                    }
                }
                Text("\("Score".getLocalized()):  \(self.game.score)")
                    .font(.system(size: self.fontSize(for: geometry.size, fontScaleFactor: self.scoreFontFactor)))
                    .foregroundColor(self.game.theme.cardFaceDownColor)
            }
        }
        .navigationBarItems(trailing: Button("Reset game".getLocalized()) {
            withAnimation(.easeInOut) {
                self.game.resetGame()
            }
        })
        .navigationBarTitle(self.game.theme.name)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Over".getLocalized()), message: Text("\("Your score is".getLocalized()) \(self.game.score)"),
                  dismissButton: .default(Text("Reset game".getLocalized()), action: {
                      self.game.resetGame()
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

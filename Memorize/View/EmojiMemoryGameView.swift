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
    @EnvironmentObject var viewModel: EmojiMemoryGame
    @State private var scoreDatas = [scoreData]()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("\("theme".getLocalized()):  \(self.viewModel.theme.name)")
                    .bold()
                    .font(.system(size: self.fontSize(for: geometry.size, fontScaleFactor: self.themeFontFactor)))
                    .padding(Edge.Set.leading)
                    .alignmentGuide(HorizontalAlignment.center, computeValue: { _ in
                        geometry.size.width / 2
                    })

                GeometryReader { geometry in
                    ZStack {
                        Grid(self.viewModel.cards) { card in
                            CardView(card: card).onTapGesture {
                                withAnimation(.linear(duration: 0.75)) {
                                    let old = self.viewModel.score
                                    self.viewModel.choose(card: card)
                                    let new = self.viewModel.score
                                    if new != old {
                                        self.scoreDatas.append(scoreData(content: new - old, index: self.viewModel.cards.firstIndex(matching: card)!))
                                    }
                                }
                            }
                            .padding(5)
                        }
                        .padding()
                        ForEach(self.scoreDatas) { scoreData in
                            ScoreView(score: scoreData.content)
                                .position(GridLayout(itemCount: self.viewModel.cards.count, in: geometry.size).location(ofItemAt: scoreData.index))
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.scoreDatas.remove(at: self.scoreDatas.firstIndex(matching: scoreData)!)
                                    }
                                }
                        }
                    }
                }
                Text("\("score".getLocalized()):  \(self.viewModel.score)")
                    .font(.system(size: self.fontSize(for: geometry.size, fontScaleFactor: self.scoreFontFactor)))
                    .foregroundColor(self.viewModel.theme.cardFaceDownColor)
            }
        }
        .navigationBarItems(trailing: Button(NSLocalizedString("new Game", comment: "To start a new game")) {
            withAnimation(.easeInOut) {
                self.viewModel.newGame()
            }
        })
    }

    // MARK: - Drawing Constants

    let newGameFontFactor: CGFloat = 0.05
    let scoreFontFactor: CGFloat = 0.05
    let themeFontFactor: CGFloat = 0.04
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

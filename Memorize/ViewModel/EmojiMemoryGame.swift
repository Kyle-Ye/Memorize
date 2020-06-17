//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

// ViewModel
import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<Emoji> = createMemoryGame()

    static var themes: [EmojiTheme] = [
        .init(name: "Halloween", contents: ["👻", "🎃", "🕷"], cardFaceDownColor: .orange, cardFaceUpColor: .white),
        .init(name: "Faces", contents: ["😀", "😃", "😄", "😁", "😆"], cardFaceDownColor: .yellow, cardFaceUpColor: .gray),
        .init(name: "Animals", contents: ["🐶","🐱","🐭","🐹","🐰","🙊"],  cardFaceDownColor: .pink, cardFaceUpColor: .blue),
        .init(name: "Fruit", contents: ["🍏", "🍎", "🍐", "🍊", "🍋", "🥭", "🍓", "🍇"], cardFaceDownColor: .blue, cardFaceUpColor: .red)]

    static func createMemoryGame() -> EmojiGame {
        let theme = themes.randomElement()!
        let contents = theme.contents.shuffled()
        return MemoryGame<String>(theme: theme) { pairIndex in
            contents[pairIndex]
        }
    }

    // MARK: - Access to the Model

    var cards: [EmojiCard] {
        model.cards
    }

    var score: Int {
        model.score
    }

    var theme: EmojiTheme {
        model.theme
    }

    // MARK: - Intent(s)

    func choose(card: EmojiCard) {
        objectWillChange.send()
        model.choose(card: card)
    }

    func newGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}

extension EmojiMemoryGame {
    public typealias Emoji = String
    public typealias EmojiGame = MemoryGame<Emoji>
    public typealias EmojiTheme = EmojiGame.Theme
    public typealias EmojiCard = EmojiGame.Card
}

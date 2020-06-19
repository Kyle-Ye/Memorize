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
    @Published private var model: MemoryGame<Emoji>

    init(theme: EmojiTheme? = nil) {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }

    private(set) static var themes: [EmojiTheme] = [
        .init(name: "Halloween".getLocalized(), contents: ["👻", "🎃", "🕷", "☠️", "🙀", "😱"], cardFaceDownColor: .orange, cardFaceUpColor: .white),
        .init(name: "Faces".getLocalized(), contents: ["😀", "😃", "😄", "😁", "😆", "😮", "😶"], cardFaceDownColor: .yellow, cardFaceUpColor: .gray),
        .init(name: "Animals".getLocalized(), contents: ["🐶", "🐱", "🐭", "🐹", "🐰", "🙊", "🐷", "🐔"], cardFaceDownColor: .purple, cardFaceUpColor: .gray),
        .init(name: "Fruits".getLocalized(), contents: ["🍏", "🍎", "🍐", "🍊", "🍋", "🥭", "🍓", "🍇"], cardFaceDownColor: .blue, cardFaceUpColor: .white),
        .init(name: "Balls".getLocalized(), contents: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🪀", "🏓"], cardFaceDownColor: .green, cardFaceUpColor: .white),
        .init(name: "Music".getLocalized(), contents: ["🎹", "🥁", "🎼", "🎷", "🎻", "🪕", "🎤"], cardFaceDownColor: .pink, cardFaceUpColor: .gray)]

    private static func createMemoryGame(theme: EmojiTheme? = nil) -> EmojiGame {
        if let theme = theme {
            let contents = theme.contents.shuffled()
            return MemoryGame<String>(theme: theme) { pairIndex in
                contents[pairIndex]
            }
        } else {
            let theme = themes.randomElement()!
            let contents = theme.contents.shuffled()
            return MemoryGame<String>(theme: theme) { pairIndex in
                contents[pairIndex]
            }
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

    func randomGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }

    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}

extension EmojiMemoryGame {
    public typealias Emoji = String
    public typealias EmojiGame = MemoryGame<Emoji>
    public typealias EmojiTheme = EmojiGame.Theme
    public typealias EmojiCard = EmojiGame.Card
}

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
    @Published private var model: MemoryGame<String> = createMemoryGame()

    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["🥕", "🐶", "🐷", "🐰", "🐸", "🐒", "🐴"].shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2 ... 5)) { pairIndex in
            emojis[pairIndex]
        }
    }

    // MARK: - Access to the Model

    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }

    // MARK: - Intent(s)

    func choose(card: MemoryGame<String>.Card) {
        objectWillChange.send()
        model.choose(card: card)
    }
}

//
//  MemoryGame.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

// Model
import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Hashable, CardContent: Codable {
    private(set) var cards: [Card]
    private(set) var theme: Theme
    private(set) var score = 0
    private var seenCards = Set<Int>()
    private let successScore = 2
    private let failScore = -1
    private let bonusScore = 3

    init(theme: Theme, cardContentFactory: (Int) -> CardContent) {
        self.theme = theme
        cards = [Card]()
        for pairIndex in 0 ..< theme.pairs {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
        cards.shuffle()
    }

    struct Card: Identifiable {
        var id: Int
        var content: CardContent
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }

        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }

        // MARK: - Bonus Time

        var bonusTimeLimit: TimeInterval = 6
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
    }

    struct Theme: Hashable, Codable, Identifiable {
        internal init(name: String, contents: [CardContent], pairs: Int, cardFaceDownColor: UIColor.RGB, cardFaceUpColor: UIColor.RGB) {
            self.name = name
            self.contents = contents
            self.pairs = pairs
            self.cardFaceDownColor = cardFaceDownColor
            self.cardFaceUpColor = cardFaceUpColor
        }

        var id = UUID()
        var name: String
        var contents: [CardContent]
        var pairs: Int
        var cardFaceDownColor: UIColor.RGB
        var cardFaceUpColor: UIColor.RGB
    }
}

extension MemoryGame {
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    var isLastCard: Bool {
        cards.filter {
            !$0.isMatched
        }.isEmpty
    }

    mutating func choose(card: Card) -> Result? {
        print("card chosen: \(card)")
        var result: Result?
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                cards[chosenIndex].isFaceUp = true
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    if cards[chosenIndex].hasEarnedBonus {
                        score += bonusScore
                        result = .bonus
                    } else {
                        score += successScore
                        if result == nil {
                            result = .success
                        }
                    }
                    if cards[potentialMatchIndex].hasEarnedBonus {
                        score += bonusScore
                        result = .bonus
                    } else {
                        score += successScore
                        if result == nil {
                            result = .success
                        }
                    }
                    if isLastCard {
                        indexOfTheOneAndOnlyFaceUpCard = nil
                    }
                } else {
                    if seenCards.contains(potentialMatchIndex) {
                        score += failScore
                        result = .fail
                    }
                    if seenCards.contains(chosenIndex) {
                        score += failScore
                        result = .fail
                    }
                }
                seenCards.insert(chosenIndex)
                seenCards.insert(potentialMatchIndex)
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
        return result
    }
}

extension MemoryGame.Card {
    private var faceUpTime: TimeInterval {
        if let lastFaceUpDate = lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }

    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }

    var bonusRemaining: Double {
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
    }

    var hasEarnedBonus: Bool {
        isMatched && bonusTimeRemaining > 0
    }

    var isConsumingBonusTime: Bool {
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }

    private mutating func startUsingBonusTime() {
        if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }

    private mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        lastFaceUpDate = nil
    }
}

extension MemoryGame.Theme {
    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    init(name: String, contents: [CardContent], pairs: Int, cardFaceDownColor: Color, cardFaceUpColor: Color) {
        self.name = name
        self.contents = contents
        self.pairs = pairs
        self.cardFaceDownColor = UIColor(cardFaceDownColor).rgb
        self.cardFaceUpColor = UIColor(cardFaceUpColor).rgb
    }

    init?(json: Data?) {
        if let json = json, let theme = try? JSONDecoder().decode(MemoryGame.Theme.self, from: json) {
            self = theme
        } else {
            return nil
        }
    }

    mutating func increasePairs() {
        if pairs < contents.count {
            pairs += 1
        } else {
            pairs = contents.count
        }
    }

    mutating func decresePairs() {
        if pairs > 2 {
            pairs -= 1
        } else {
            pairs = 2
        }
    }

    mutating func addContents(_ contents: [CardContent]) {
        self.contents = (self.contents + contents).unique
    }
}

//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

// ViewModel
import AVFoundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<Emoji>

    init(theme: EmojiTheme? = nil) {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }

    private(set) static var themes: [EmojiTheme] = [
        .init(name: "Halloween".getLocalized(), contents: ["👻", "🎃", "🕷", "☠️", "🙀", "😱"], pairs: 4, cardFaceDownColor: .init(red: 0.2, green: 0.3, blue: 0.2, alpha: 1.0), cardFaceUpColor: .init(red: 0.2, green: 0.3, blue: 0.2, alpha: 1.0)),
        .init(name: "Halloween".getLocalized(), contents: ["👻", "🎃", "🕷", "☠️", "🙀", "😱"], pairs: 4, cardFaceDownColor: .orange, cardFaceUpColor: .white),
        .init(name: "Faces".getLocalized(), contents: ["😀", "😃", "😄", "😁", "😆", "😮", "😶"], pairs: 4, cardFaceDownColor: .yellow, cardFaceUpColor: .gray),
        .init(name: "Animals".getLocalized(), contents: ["🐶", "🐱", "🐭", "🐹", "🐰", "🙊", "🐷", "🐔"], pairs: 4, cardFaceDownColor: .purple, cardFaceUpColor: .gray),
        .init(name: "Fruits".getLocalized(), contents: ["🍏", "🍎", "🍐", "🍊", "🍋", "🥭", "🍓", "🍇"], pairs: 4, cardFaceDownColor: .blue, cardFaceUpColor: .white),
        .init(name: "Balls".getLocalized(), contents: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🪀", "🏓"], pairs: 5, cardFaceDownColor: .green, cardFaceUpColor: .white),
        .init(name: "Music".getLocalized(), contents: ["🎹", "🥁", "🎼", "🎷", "🎻", "🪕", "🎤"], pairs: 6, cardFaceDownColor: .pink, cardFaceUpColor: .gray),
    ]

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
        switch model.choose(card: card) {
        case .bonus: EmojiMemoryGame.playBonus()
        case .success: EmojiMemoryGame.playSuccess()
        case .fail: EmojiMemoryGame.playFail()
        case .none: break
        }
    }

    func randomGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }

    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }

    private static var audioPlayer = AVAudioPlayer()

    private static func playSound(soundPath: String?) {
        if let path = soundPath {
            let soundUrl = URL(fileURLWithPath: path)
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                audioPlayer.play()
            } catch {
                print("Audio play error for \(path)")
            }
        }
    }

    private static let bonusSoundPath = Bundle.main.path(forResource: "bonus", ofType: ".wav")
    private static let successSoundPath = Bundle.main.path(forResource: "success", ofType: ".wav")
    private static let failSoundPath = Bundle.main.path(forResource: "fail", ofType: ".wav")
    static func playBonus() {
        playSound(soundPath: bonusSoundPath)
    }

    static func playSuccess() {
        playSound(soundPath: successSoundPath)
    }

    static func playFail() {
        playSound(soundPath: failSoundPath)
    }
}

extension EmojiMemoryGame {
    public typealias Emoji = String
    public typealias EmojiGame = MemoryGame<Emoji>
    public typealias EmojiTheme = EmojiGame.Theme
    public typealias EmojiCard = EmojiGame.Card
}

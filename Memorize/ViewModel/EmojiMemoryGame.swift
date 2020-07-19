//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import AVFoundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<Emoji>

    init(theme: EmojiTheme) {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}

extension EmojiMemoryGame {
    // MARK: - Type Alias

    public typealias Emoji = String
    public typealias EmojiGame = MemoryGame<Emoji>
    public typealias EmojiTheme = EmojiGame.Theme
    public typealias EmojiCard = EmojiGame.Card

    // MARK: - Access to the Model

    var cards: [EmojiCard] { model.cards }
    var score: Int { model.score }
    var theme: EmojiTheme { model.theme }

    // MARK: - Intents

    private static func createMemoryGame(theme: EmojiTheme) -> EmojiGame {
        let contents = theme.contents.shuffled()
        return MemoryGame<String>(theme: theme) { pairIndex in
            contents[pairIndex]
        }
    }

    func choose(card: EmojiCard) {
        objectWillChange.send()
        switch model.choose(card: card) {
        case .bonus: EmojiMemoryGame.playBonus()
        case .success: EmojiMemoryGame.playSuccess()
        case .fail: EmojiMemoryGame.playFail()
        case .none: break
        }
    }

    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }

    // MARK: - Audio Extension

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

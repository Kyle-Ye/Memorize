//
//  EmojiMemoryThemeStore.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/7/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import Combine
import Foundation

class EmojiMemoryThemeStore: ObservableObject {
    typealias Theme = MemoryGame<String>.Theme
    static let identifier = "MemoryGameThemeStore"
    let name: String
    @Published var themes: [Theme]
    private var autosave: AnyCancellable?

    init(named name: String = "Emoji Game") {
        self.name = name
        let key = "\(EmojiMemoryThemeStore.identifier).\(name)"
        themes = Array(fromDataList: UserDefaults.standard.object(forKey: key))
        autosave = $themes.sink { themes in
            UserDefaults.standard.set(themes.jsons, forKey: key)
        }
        getDefault()
    }
}

extension EmojiMemoryThemeStore {
    func getDefault() {
        if themes.count == 0 {
            themes += [
                .init(name: "Halloween".getLocalized(), contents: ["👻", "🎃", "🕷", "☠️", "🙀", "😱"], pairs: 4, cardFaceDownColor: .init(red: 0.2, green: 0.3, blue: 0.2, alpha: 1.0), cardFaceUpColor: .init(red: 0.2, green: 0.3, blue: 0.2, alpha: 1.0)),
                .init(name: "Halloween".getLocalized(), contents: ["👻", "🎃", "🕷", "☠️", "🙀", "😱"], pairs: 4, cardFaceDownColor: .orange, cardFaceUpColor: .white),
                .init(name: "Faces".getLocalized(), contents: ["😀", "😃", "😄", "😁", "😆", "😮", "😶"], pairs: 4, cardFaceDownColor: .yellow, cardFaceUpColor: .gray),
                .init(name: "Animals".getLocalized(), contents: ["🐶", "🐱", "🐭", "🐹", "🐰", "🙊", "🐷", "🐔"], pairs: 4, cardFaceDownColor: .purple, cardFaceUpColor: .gray),
                .init(name: "Fruits".getLocalized(), contents: ["🍏", "🍎", "🍐", "🍊", "🍋", "🥭", "🍓", "🍇"], pairs: 4, cardFaceDownColor: .blue, cardFaceUpColor: .white),
                .init(name: "Balls".getLocalized(), contents: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🪀", "🏓"], pairs: 5, cardFaceDownColor: .green, cardFaceUpColor: .white),
                .init(name: "Music".getLocalized(), contents: ["🎹", "🥁", "🎼", "🎷", "🎻", "🪕", "🎤"], pairs: 6, cardFaceDownColor: .pink, cardFaceUpColor: .gray),
            ]
        }
    }

    func applyThemeChange(_ theme: Theme) {
        if let index = themes.firstIndex(matching: theme) {
            themes[index] = theme
        } else {
            themes.append(theme)
        }
    }

    var defaultTheme: Theme {
        Theme(name: "", contents: [], pairs: 2, cardFaceDownColor: .purple, cardFaceUpColor: .purple)
    }
}

extension Array where Element == MemoryGame<String>.Theme {
    typealias Theme = MemoryGame<String>.Theme
    var jsons: [Data?] {
        var jsons = [Data?]()
        for theme in self {
            jsons.append(theme.json)
        }
        return jsons
    }

    init(fromDataList plist: Any?) {
        self.init()
        if let plist = plist as? [Data?] {
            for data in plist {
                if let theme = Theme(json: data) {
                    append(theme)
                }
            }
        }
    }
}

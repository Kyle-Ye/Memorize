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
    static let identifier = "MemoryGameThemeStore"
    let name: String
    @Published var themes: [MemoryGame<String>.Theme]
    private var autosave: AnyCancellable?

    init(named name: String = "Emoji Game") {
        self.name = name
        let key = "\(EmojiMemoryThemeStore.identifier).\(name)"
        themes = Array(fromDataList: UserDefaults.standard.object(forKey: key))
        autosave = $themes.sink { themes in
            UserDefaults.standard.set(themes.jsons, forKey: key)
        }
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

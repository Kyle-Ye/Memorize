
//
//  NewThemeView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct ThemeEditor: View {
    @EnvironmentObject var store: EmojiMemoryThemeStore
    @State var themeName: String = ""
    @State var emojis: String = ""
    var theme: EmojiMemoryGame.EmojiTheme?

    @State private var index = 0

    var body: some View {
        Form {
            Section {
                TextField("Theme Name", text: $themeName)
            }
            Section(header: Text("Add Emoji")) {
                TextField("Emoji", text: $emojis)
            }
            Section(header: Text("Emojis")) {
                Grid(store.themes[index].contents, id: \.self) { emoji in
                    Text(emoji)
                }
            }
            Section(header: Text("Card Count")) {
                Stepper("\(store.themes[index].pairs) Pairs") {
                    store.themes[index].pairs += 1
                } onDecrement: {
                    store.themes[index].pairs -= 1
                }
            }
            Section(header: Text("Color")) {
                Text("TODO")
            }
        }
        .onAppear {
            if let theme = theme {
                index = store.themes.firstIndex(of: theme)!
            } else {
                index = store.themes.count
                store.themes.append(.init(name: "", contents: [], pairs: 0, cardFaceDownColor: .gray, cardFaceUpColor: .gray))
            }
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor()
            .environmentObject(EmojiMemoryThemeStore())
    }
}

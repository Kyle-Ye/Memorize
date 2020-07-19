//
//  ThemeView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/18.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
    @EnvironmentObject var store: EmojiMemoryThemeStore
    @State var editingTheme: Bool = false
    var theme: MemoryGame<String>.Theme
    var isEditing: Bool = false

    var description: String {
        if theme.contents.count == theme.pairs {
            return "All of"
        } else {
            return "\(theme.pairs) pairs from"
        }
    }

    var body: some View {
        HStack {
            if isEditing {
                Image(systemName: "pencil.circle.fill").imageScale(.large).foregroundColor(Color(theme.cardFaceDownColor))
                    .onTapGesture {
                        editingTheme = true
                    }
                    .popover(isPresented: $editingTheme) {
                        ThemeEditor(theme: theme)
                            .environmentObject(store)
                    }
            }
            VStack(alignment: .leading) {
                Text(theme.name)
                    .bold()
                    .font(.title)
                    .foregroundColor(isEditing ? .primary : Color(theme.cardFaceDownColor))
                Text("\(description) \(theme.contents.joined())")
                    .lineLimit(1)
            }
        }
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: EmojiMemoryGame.themes.randomElement()!, isEditing: true)
    }
}

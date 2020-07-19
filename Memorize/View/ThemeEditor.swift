
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
    @Environment(\.presentationMode) private var presentationMode

    @State var addEmojis = ""
    @State var theme: EmojiMemoryGame.EmojiTheme = .init(name: "", contents: [], pairs: 0, cardFaceDownColor: .gray, cardFaceUpColor: .gray)

    @State private var index = 0

    var body: some View {
        Form {
            Section {
                TextField("Theme Name", text: $theme.name)
            }
            Section(header: Text("Add Emoji")) {
                HStack {
                    TextField("Emoji", text: $addEmojis)
                    Button("Add") {
                    }
                }
            }
            Section(header: Text("Emojis")) {
                Grid(theme.contents, id: \.self) { emoji in
                    Text(emoji)
                }
            }
            Section(header: Text("Card Count")) {
                Stepper("\(theme.pairs) Pairs") {
                    theme.increasePairs()
                } onDecrement: {
                    theme.decresePairs()
                }
            }
            Section {
                Grid(ThemeEditor.colorSet, id: \.self) { color in
                    ColorCardChooser(color: color, choose: UIColor(color).rgb == theme.cardFaceDownColor)
                        .onTapGesture {
                            theme.cardFaceDownColor = UIColor(color).rgb
                        }
                }
                .frame(height: height)
            }

            Section {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                    store.applyThemeChange(theme)
                }
            }
        }
    }

    var height: CGFloat {
        CGFloat((ThemeEditor.colorSet.count - 1) / 6) * 120 + 120
    }
}

extension ThemeEditor {
    static var colorSet: [Color] = [.purple, .red, .blue, .black, .white, .green, .yellow, .gray, .pink, .orange]
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor()
            .environmentObject(EmojiMemoryThemeStore())
    }
}

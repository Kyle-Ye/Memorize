
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
        VStack(spacing: 0) {
            ZStack {
                Text(theme.name)
                    .font(.headline)
                    .padding()
                HStack {
                    Spacer()
                    Button(action: {
                        store.applyThemeChange(theme)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done").padding()
                    })
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Theme Name", text: $theme.name)
                }
                Section(header: Text("Add Emoji")) {
                    HStack {
                        TextField("Emoji", text: $addEmojis)
                        Button("Add") {
                            theme.addContents(addEmojis.map { String($0) })
                            addEmojis = ""
                        }
                    }
                }
                Section(header: Text("Emojis")) {
                    Grid(theme.contents, id: \.self) { emoji in
                        Text(emoji).font(.system(size: fontSize))
                            .onTapGesture {
                                theme.contents.remove(at: theme.contents.firstIndex(of: emoji)!)
                                theme.pairs = min(theme.pairs, theme.contents.count)
                            }
                    }
                    .frame(height: emojisHeight)
                }
                Section(header: Text("Card Count")) {
                    Stepper(
                        "\(theme.pairs) Pairs",
                        onIncrement: { theme.increasePairs() },
                        onDecrement: { theme.decresePairs() }
                    )
                }
                Section {
                    Grid(ThemeEditor.colorSet, id: \.self) { color in
                        ColorCardChooser(color: color, choose: UIColor(color).rgb == theme.cardFaceDownColor)
                            .onTapGesture {
                                theme.cardFaceDownColor = UIColor(color).rgb
                            }
                    }
                    .frame(height: colorHeight)
                }
            }
        }
    }

    // MARK: - Drawing Constants

    let fontSize: CGFloat = 40
    var emojisHeight: CGFloat {
        CGFloat((ThemeEditor.colorSet.count - 1) / 6) * 70 + 70
    }

    var colorHeight: CGFloat {
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

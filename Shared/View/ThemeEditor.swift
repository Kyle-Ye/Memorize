
//
//  NewThemeView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct ThemeEditor: View {
    typealias Theme = EmojiMemoryGame.EmojiTheme
    @EnvironmentObject var store: EmojiMemoryThemeStore
    @Environment(\.presentationMode) private var presentationMode

    @State var theme: Theme = .init(name: "", contents: [], pairs: 0, cardFaceDownColor: .gray, cardFaceUpColor: .gray)

    var validation: Bool {
        !theme.name.isEmpty && theme.contents.count >= 2 && theme.pairs > 1
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text(theme.name)
                    .font(.headline)
                    .padding()
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    Spacer()
                    Button("Done") {
                        store.applyThemeChange(theme)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .disabled(!validation)
                }
            }
            Divider()
            Form {
                ThemeNameSection(theme: $theme)
                EmojisSection(theme: $theme)
                CardCountSection(theme: $theme)
                FaceDownColorChooserSection(theme: $theme)
                FaceUpColorChooserSection(theme: $theme)
            }
        }
    }

    // MARK: - Sub Sections

    struct ThemeNameSection: View {
        @Binding var theme: Theme
        var body: some View {
            Section(header: ThemeNameHint(name: theme.name)) {
                HStack {
                    TextField("Theme Name", text: $theme.name)
                    Spacer()
                }
            }
        }

        struct ThemeNameHint: View {
            var name: String
            var message: String {
                "Theme name cannot be empty"
            }

            var body: some View {
                HStack {
                    Text("Theme Name").bold().font(.headline)
                    if name.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                }
                .textCase(nil)
            }
        }
    }

    struct EmojisSection: View {
        @Binding var theme: Theme
        @State var addEmojis = ""

        var body: some View {
            Section(header: EmojiHint(emojisCount: theme.contents.count)) {
                HStack {
                    TextField("Add Emojis", text: $addEmojis)
                    Button("Add") {
                        theme.addContents(addEmojis.map { String($0) })
                        addEmojis = ""
                    }
                }
                Grid(theme.contents, id: \.self) { emoji in
                    Text(emoji).font(.system(size: fontSize))
                        .onTapGesture {
                            theme.contents.remove(at: theme.contents.firstIndex(of: emoji)!)
                            theme.pairs = min(theme.pairs, theme.contents.count)
                        }
                }
                .frame(height: emojisHeight)
            }
        }

        private let fontSize: CGFloat = 40
        private var emojisHeight: CGFloat {
            CGFloat((ThemeEditor.colorSet.count - 1) / 6) * 70 + 70
        }

        struct EmojiHint: View {
            var emojisCount: Int
            var message1: String {
                "Should have at least 2 emojis!"
            }

            var body: some View {
                HStack {
                    Text("Emojis").bold().font(.headline)
                    if emojisCount < 2 {
                        Text(message1)
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                    Spacer()
                    if emojisCount >= 2 {
                        Text("tap emoji to exclude")
                    }
                }
                .textCase(nil)
            }
        }
    }

    struct CardCountSection: View {
        @Binding var theme: Theme
        var body: some View {
            Section(header: CardCountHint(emojisCount: theme.contents.count, pairs: theme.pairs)) {
                HStack {
                    Stepper(
                        "\(theme.pairs) Pairs",
                        onIncrement: { theme.increasePairs() },
                        onDecrement: { theme.decresePairs() }
                    )
                }
            }
        }

        struct CardCountHint: View {
            var emojisCount: Int
            var pairs: Int
            var message1: String {
                "Should at 2 ~ \(emojisCount)(Emojis.count)"
            }

            var message2: String {
                "Add more emojis first!"
            }

            var body: some View {
                HStack {
                    Text("Card Count").bold().font(.headline)
                    if emojisCount >= 2 {
                        if pairs < 2 {
                            Text(message1)
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Spacer()
                            Text("range 2 ~ \(emojisCount)")
                        }
                    } else {
                        Text(message2)
                            .foregroundColor(.red)
                    }
                }
                .textCase(nil)
            }
        }
    }

    struct FaceDownColorChooserSection: View {
        @Binding var theme: Theme
        var body: some View {
            Section(header: HStack {
                Text("Face Down Color").bold().font(.headline).textCase(nil)
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(theme.cardFaceDownColor))
                    .imageScale(.large)
            }) {
                ColorChooserSection(themeColor: $theme.cardFaceDownColor)
            }
        }
    }

    struct FaceUpColorChooserSection: View {
        @Binding var theme: Theme
        @State private var content = ""
        var body: some View {
            Section(header: HStack {
                Text("Face Up Color").bold().font(.headline).textCase(nil)
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(theme.cardFaceUpColor))
                    .imageScale(.large)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(theme.contents, id: \.self) { emoji in
                            Text(emoji)
                                .onTapGesture {
                                    content = emoji
                                }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .onAppear {
                    content = theme.contents.first ?? ""
                }
            }) {
                ColorChooserSection(themeColor: $theme.cardFaceUpColor, strokeColor: theme.cardFaceDownColor, content: content)
            }
        }
    }

    struct ColorChooserSection: View {
        @Binding var themeColor: UIColor.RGB
        var strokeColor: UIColor.RGB?
        var content: String = "🎃"
        var body: some View {
            Section {
                Grid(ThemeEditor.colorSet, id: \.self) { color in
                    ZStack {
                        ColorCardChooser(color: color, choose: UIColor(color).rgb == themeColor, strokeColor: strokeColor == nil ? color : Color(strokeColor!))
                            .onTapGesture {
                                themeColor = UIColor(color).rgb
                            }
                        if strokeColor != nil {
                            Text(content)
                        }
                    }
                }
                .frame(height: colorHeight)
            }
        }

        // MARK: - Drawing Constants

        var colorHeight: CGFloat {
            CGFloat((ThemeEditor.colorSet.count - 1) / 6) * 120 + 120
        }
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

//
//  ThemeView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/18.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
    var theme: MemoryGame<String>.Theme
    var body: some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .bold()
                .font(.title)
                .foregroundColor(Color(theme.cardFaceDownColor))
            Text(theme.contents.joined())
        }
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: EmojiMemoryGame.themes.randomElement()!)
    }
}

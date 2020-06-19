//
//  ContentView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/18.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddTheme = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(EmojiMemoryGame.themes, id: \.name) { theme in
                        NavigationLink(destination: EmojiMemoryGameView()
                            .environmentObject(EmojiMemoryGame(theme: theme))
                        ) {
                            ThemeView(theme: theme)
                        }
                    }
                }
                RoundButton(isOn: $showingAddTheme)
                    .padding()
            }
            .navigationBarTitle("Themes".getLocalized())
        }
        .sheet(isPresented: $showingAddTheme) {
            NewThemeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EmojiMemoryGame())
    }
}

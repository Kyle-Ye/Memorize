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
    @State private var isRandomGame = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(EmojiMemoryGame.themes, id: \.self) { theme in
                        NavigationLink(destination: EmojiMemoryGameView()
                            .environmentObject(EmojiMemoryGame(theme: theme))
                            .onAppear {
                                print("json = \(theme.json?.utf8 ?? "nil")")
                            }
                        ) {
                            ThemeView(theme: theme)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(
                    Group {
                        if isRandomGame {
                            NavigationLink(destination: EmojiMemoryGameView().environmentObject(EmojiMemoryGame()), isActive: $isRandomGame, label: {
                                EmptyView()
                            })
                        }
                })
                RoundButton(isOn: $showingAddTheme)
                    .padding()
            }
            .navigationBarTitle("Themes".getLocalized())
            .navigationBarItems(trailing: Button("Random".getLocalized()) {
                isRandomGame = true
            })
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

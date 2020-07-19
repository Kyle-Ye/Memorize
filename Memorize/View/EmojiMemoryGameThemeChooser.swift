//
//  ContentView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/18.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameThemeChooser: View {
    @EnvironmentObject var store: EmojiMemoryThemeStore
    @State private var showingAddTheme = false
    @State private var isRandomGame = false
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes, id: \.self) { theme in
                    NavigationLink(destination: EmojiMemoryGameView()
                        .navigationBarTitleDisplayMode(.inline)
                        .environmentObject(EmojiMemoryGame(theme: theme))
                        .onAppear {
                            print("json = \(theme.json?.utf8 ?? "nil")")
                        }
                    ) {
                        ThemeView(theme: theme, isEditing: editMode.isEditing)
                    }
                }
                .onDelete { _ in
//                    indexSet.map { store.documents[$0] }.forEach { document in
//                        store.removeDocument(document)
//                    }
                }
                Button("Random".getLocalized()) {
                    isRandomGame = true
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
            .navigationBarTitle("Themes".getLocalized())
            .navigationBarItems(
                leading: Button(
                    action: {
//                        store.addDocument()
                    }, label: {
                        Image(systemName: "plus").imageScale(.large)
                    }
                ),
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $showingAddTheme) {
                NewThemeView()
            }
        }
    }
}

struct EmojiMemoryGameThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameThemeChooser()
            .environmentObject(EmojiMemoryGame())
    }
}

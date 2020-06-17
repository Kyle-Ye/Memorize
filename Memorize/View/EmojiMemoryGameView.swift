//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

// View
import SwiftUI

struct EmojiMemoryGameView: View {
    @EnvironmentObject var viewModel: EmojiMemoryGame
    var body: some View {
        VStack {
            Button("New Game") {
                self.viewModel.newGame()
            }

            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }

                .padding(5)
            }
            .padding()
            HStack {
                Text("score: \(self.viewModel.score)")
                Text("Theme: \(self.viewModel.theme.name)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let world = EmojiMemoryGame()
    static var previews: some View {
        Group {
            EmojiMemoryGameView()
                .environmentObject(world)
                .environment(\.colorScheme, .dark)
                .previewDevice("iPhone Xs")
            EmojiMemoryGameView()
                .environmentObject(world)
                .environment(\.colorScheme, .dark)
                .previewDevice("iPad Pro (12.9-inch)")
        }
    }
}

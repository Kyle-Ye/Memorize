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
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        Grid(viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                self.viewModel.choose(card: card)
            }
            .padding(5)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
                .environment(\.colorScheme, .dark)
                .previewDevice("iPhone Xs")
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
                .environment(\.colorScheme, .dark)
                .previewDevice("iPad Pro (12.9-inch)")
        }
    }
}

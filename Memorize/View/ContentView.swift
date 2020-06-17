//
//  ContentView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/16.
//  Copyright © 2020 KyleYe. All rights reserved.
//

// View
import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    var body: some View {
        HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
                .aspectRatio(2.0 / 3.0, contentMode: .fit)
            }
        }.padding()
            .foregroundColor(Color.orange)
            .font(self.viewModel.cards.count / 2 == 5 ? .title : .largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: EmojiMemoryGame())
                .environment(\.colorScheme, .dark)
                .previewDevice("iPhone Xs")
            ContentView(viewModel: EmojiMemoryGame())
                .environment(\.colorScheme, .dark)
                .previewDevice("iPad Pro (12.9-inch)")
        }
    }
}

//
//  ColorCardChooser.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/7/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct ColorCardChooser: View {
    var color: Color
    var choose: Bool = true
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .cornerRadius(cornerRadius)
                    .foregroundColor(color)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                Image(systemName: "checkmark.circle")
                    .foregroundColor(color != .white ? .white : .black)
                    .font(.system(size: fontSize(for: geometry.size)))
                    .padding(fontSize(for: geometry.size) * 0.2)
                    .opacity(choose ? 1 : 0)
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .padding(.vertical, 10)
    }

    // MARK: - Drawing Constants

    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 6
    private let fontScaleFactor: CGFloat = 0.4
    private let aspectRatio: CGFloat = 2.0 / 3.0
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.width) * fontScaleFactor
    }
}

struct ColorCardChooser_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                ColorCardChooser(color: .red)
                ColorCardChooser(color: .blue)
                ColorCardChooser(color: .gray)
                ColorCardChooser(color: .red)
                ColorCardChooser(color: .blue)
                ColorCardChooser(color: .gray)
            }
            HStack {
                ColorCardChooser(color: .red)
                ColorCardChooser(color: .blue)
                ColorCardChooser(color: .gray)
            }
            HStack {
                ColorCardChooser(color: .white)
                ColorCardChooser(color: .black)
            }
        }
    }
}

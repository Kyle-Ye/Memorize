//
//  RoundButton.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct RoundButton: View {
    @Binding var isOn: Bool
    var body: some View {
        Button(action: {
            isOn.toggle()
        }, label: {
            Text("+").font(.system(.largeTitle))
                .frame(width: 77, height: 70)
                .foregroundColor(Color.black)
                .padding(.bottom, 7)
        })
            .background(Color.blue)
            .cornerRadius(38.5)
            .padding()
            .shadow(color: Color.black.opacity(0.3),
                    radius: 3,
                    x: 3,
                    y: 3)
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundButton(isOn: .constant(true))
    }
}

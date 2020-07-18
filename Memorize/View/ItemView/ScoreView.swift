//
//  ScoreView.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

struct ScoreView: View {
    var score: Int
    @State var showScoreAnimation = false
    var body: some View {
        Group {
            Text(score.toSignString())
                .font(.largeTitle)
                .bold()
                .transition(.identity)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1)) {
                        showScoreAnimation = true
                    }
                }
                .dropfy(showAnimation: showScoreAnimation, isUp: score > 0)
                .foregroundColor(score.getColor())
        }
    }
}

extension Int {
    func toSignString() -> String {
        if self > 0 {
            return "+\(self)"
        } else {
            return "\(self)"
        }
    }

    func getColor() -> Color {
        if self > 3 {
            return .green
        } else if self > 0 {
            return .pink
        } else if self < 0 {
            return .red
        } else {
            return .secondary
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(score: 5)
    }
}

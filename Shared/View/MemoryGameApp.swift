//
//  MemoryGameApp.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/7/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import SwiftUI

import SwiftUI

@main
struct EnrouteApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameThemeChooser()
                .environmentObject(EmojiMemoryThemeStore())
        }
    }
}

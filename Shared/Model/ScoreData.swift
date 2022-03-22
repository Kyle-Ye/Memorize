//
//  ScoreData.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/7/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import Foundation

struct scoreData: Identifiable {
    var id: Int {
        index
    }
    var content: Int
    var index: Int
}

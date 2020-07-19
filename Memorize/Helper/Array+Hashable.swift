//
//  Array+Hashable.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/7/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var unique: [Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(count)
        return filter {
            uniq.insert($0).inserted
        }
    }
}

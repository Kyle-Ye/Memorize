//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/17.
//  Copyright © 2020 KyleYe. All rights reserved.
//

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in indices {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}

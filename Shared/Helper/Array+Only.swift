//
//  Array+Only.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/17.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first: nil
    }
}

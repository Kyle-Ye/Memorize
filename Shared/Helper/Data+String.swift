//
//  Data+String.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/7/17.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import Foundation

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8) }
}

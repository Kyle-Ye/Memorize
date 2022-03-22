//
//  String+Localizable.swift
//  Memorize
//
//  Created by 叶絮雷 on 2020/6/19.
//  Copyright © 2020 KyleYe. All rights reserved.
//

import Foundation

extension String {
    func getLocalized(comment: String? = nil) -> String {
        NSLocalizedString(self, comment: comment ?? "")
    }
}

//
//  StringExtension.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import Foundation

extension String {
    func toMillions() -> String? {
        guard let number = Double(self) else { return nil }
        if number >= 1_000_000 {
            let millions = number / 1_000_000
            return String(format: "%.1fM", millions)
        } else if number >= 1_000 {
            let thousands = number / 1_000
            return String(format: "%.1fK", thousands)
        } else {
            return self
        }
    }
}

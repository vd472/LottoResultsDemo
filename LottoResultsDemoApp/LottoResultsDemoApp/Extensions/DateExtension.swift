//
//  DateExtension.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import Foundation

extension Date {
    func isoDateFormatter() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "EE., dd.MM.yyyy"
        return formatter.string(from: self)
    }
}

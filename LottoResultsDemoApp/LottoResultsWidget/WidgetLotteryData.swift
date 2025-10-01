//
//  WidgetLotteryData.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 01.10.25.
//

import Foundation

struct WidgetLotteryData: Identifiable {
    let id = UUID()
    let lottery: String
    let displayName: String
    let icon: String
    let lastDrawNumbers: [Int]
    let superNumber: Int?
    let euroNumbers: [Int]?
    let jackpotAmount: String?
    let timeUntilNextDraw: String
    let formattedLastDrawDate: String?
}

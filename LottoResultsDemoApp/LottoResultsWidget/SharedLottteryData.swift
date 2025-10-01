//
//  SharedLottteryData.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 01.10.25.
//

import Foundation

struct SharedLotteryData: Codable {
    let lotteries: [SharedLotteryItem]
    let lastUpdated: Date
}

struct SharedLotteryItem: Codable {
    let lottery: String
    let lastDrawNumbers: [Int]
    let superNumber: Int?
    let euroNumbers: [Int]?
    let jackpotAmount: String?
    let nextDrawDate: Date?
    let lastDrawDate: Date?
}

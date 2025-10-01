//
//  LotteryDataModel.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Foundation
import SwiftData

@Model
class LotteryData {
    @Attribute(.unique) var lottery: String
    var lastDrawIdentifier: String?
    var lastDrawDate: Date?
    var lastDrawNumbers: [Int]
    var superNumber: Int?
    var euroNumbers: [Int]?
    var currency: String?
    var nextDrawDate: Date?
    var jackpotAmount: String?
    var lastUpdated: Date
    
    init(lottery: String, lastDrawIdentifier: String? = nil, lastDrawDate: Date? = nil,
         lastDrawNumbers: [Int] = [], superNumber: Int? = nil, euroNumbers: [Int]? = nil,
         currency: String? = nil, nextDrawDate: Date? = nil, jackpotAmount: String? = nil) {
        self.lottery = lottery
        self.lastDrawIdentifier = lastDrawIdentifier
        self.lastDrawDate = lastDrawDate
        self.lastDrawNumbers = lastDrawNumbers
        self.superNumber = superNumber
        self.euroNumbers = euroNumbers
        self.currency = currency
        self.nextDrawDate = nextDrawDate
        self.jackpotAmount = jackpotAmount
        self.lastUpdated = Date()
    }
    
    convenience init(from response: LotteryResults) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let lastDrawDate = response.lastDraw?.drawDate.flatMap{formatter.date(from: $0)}
        let nextDrawDate = response.nextDraw?.drawDate.flatMap { formatter.date(from: $0)}
        
        let jackpotAmount = response.nextDraw?.jackpot?.jackpots?["WC_1"]?.toMillions()
        
        self.init(
            lottery: response.lottery,
            lastDrawIdentifier: response.lastDraw?.drawIdentifier,
            lastDrawDate: lastDrawDate,
            lastDrawNumbers: response.lastDraw?.drawResult.numbers ?? [],
            superNumber: response.lastDraw?.drawResult.superNumber,
            euroNumbers: response.lastDraw?.drawResult.euroNumbers,
            currency: response.lastDraw?.currency,
            nextDrawDate: nextDrawDate,
            jackpotAmount: jackpotAmount
        )
    }
}



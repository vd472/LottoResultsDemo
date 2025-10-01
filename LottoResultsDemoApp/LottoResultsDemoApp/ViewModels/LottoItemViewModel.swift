//
//  LottoItemViewModel.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import Foundation
import Combine
import SwiftData

class LotteryItemViewModel: ObservableObject {
    let lotteryData: LotteryData
    
    init(lotteryData: LotteryData) {
        self.lotteryData = lotteryData
    }
    
    var lotteryType: LottoTypeProtocol? {
        LotteryTypeFactory.createType(for: lotteryData.lottery)
    }
    
    var displayName: String {
        lotteryType?.displayName ?? lotteryData.lottery
    }
    
    var icon: String {
        lotteryType?.icon ?? "questionmark.circle"
    }
    
    var formattedLastDrawDate: String {
        guard let date = lotteryData.lastDrawDate else { return "N/A" }
        return date.isoDateFormatter()
    }
    
    var formattedNextDrawDate: String {
        guard let date = lotteryData.nextDrawDate else { return "N/A" }
        return date.isoDateFormatter()
    }
    
    var timeUntilNextDraw: String {
        guard let nextDrawDate = lotteryData.nextDrawDate else { return "N/A" }
        
        let now = Date()
        let timeInterval = nextDrawDate.timeIntervalSince(now)
        
        if timeInterval <= 0 {
            return "Draw completed"
        }
        
        let days = Int(timeInterval) / 86400
        let hours = (Int(timeInterval) % 86400) / 3600
        
        if days > 0 {
            return "in \(days) day\(days == 1 ? "" : "s")"
        } else if hours > 0 {
            return "in \(hours) hour\(hours == 1 ? "" : "s")"
        } else {
            return "in less than an hour"
        }
    }
    
    var jackpotAmount: String? {
        guard let amount = lotteryData.jackpotAmount else { return nil }
        return amount
    }
    
    var hasEuroNumbers: Bool {
        lotteryData.euroNumbers?.isEmpty == false
    }
    
    var hasSuperNumber: Bool {
        lotteryData.superNumber != nil
    }
}


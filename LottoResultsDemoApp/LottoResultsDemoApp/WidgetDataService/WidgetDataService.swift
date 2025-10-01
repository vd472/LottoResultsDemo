//
//  WidgetDataService.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 01.10.25.
//

import Foundation
import WidgetKit

class WidgetDataService {
    static let shared = WidgetDataService()
    private let appGroupIdentifier = "group.com.lottoresults.widget"
    
    private init() {}
    
    func updateWidgetData(with lotteries: [LotteryData]) {
        let sharedData = SharedLotteryData(
            lotteries: lotteries.map { lottery in
                return SharedLotteryItem(
                    lottery: lottery.lottery,
                    lastDrawNumbers: lottery.lastDrawNumbers,
                    superNumber: lottery.superNumber,
                    euroNumbers: lottery.euroNumbers,
                    jackpotAmount: lottery.jackpotAmount,
                    nextDrawDate: lottery.nextDrawDate,
                    lastDrawDate: lottery.lastDrawDate
                )
            },
            lastUpdated: Date()
        )
        
        saveSharedData(sharedData)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func saveSharedData(_ data: SharedLotteryData) {
        guard let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else {
            print("Failed to get shared container URL")
            return
        }
        
        let dataURL = sharedURL.appendingPathComponent("lottery_data.json")
        
        do {
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: dataURL)
            print("Successfully saved widget data")
        } catch {
            print("Failed to save widget data: \(error)")
        }
    }
}

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

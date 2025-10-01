//
//  LotteryTimelineProvider.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 01.10.25.
//

import WidgetKit
import SwiftUI
import Foundation

struct LotteryTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> LotteryTimelineEntry {
        LotteryTimelineEntry(
            date: Date(),
            lotteries: []
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (LotteryTimelineEntry) -> ()) {
        let entry = createEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LotteryTimelineEntry>) -> ()) {
        let currentDate = Date()
        let entry = createEntry()
        
        // Update every 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private func createEntry() -> LotteryTimelineEntry {
        let lotteries = loadLotteryData()
        return LotteryTimelineEntry(date: Date(), lotteries: lotteries)
    }
    
    private func loadLotteryData() -> [WidgetLotteryData] {
        // Load data from shared container
        guard let sharedData = loadSharedData(),
              !sharedData.lotteries.isEmpty else {
            return []
        }
        
        return sharedData.lotteries.map { lottery in
            return WidgetLotteryData(
                lottery: lottery.lottery,
                displayName: getDisplayName(for: lottery.lottery),
                icon: getIcon(for: lottery.lottery),
                lastDrawNumbers: lottery.lastDrawNumbers,
                superNumber: lottery.superNumber,
                euroNumbers: lottery.euroNumbers,
                jackpotAmount: lottery.jackpotAmount,
                timeUntilNextDraw: formatTimeUntilNext(lottery.nextDrawDate),
                formattedLastDrawDate: formatLastDrawDate(lottery.lastDrawDate),
            )
        }
    }
    
    private func loadSharedData() -> SharedLotteryData? {
        guard let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.lottoresults.widget") else {
            return nil
        }
        
        let dataURL = sharedURL.appendingPathComponent("lottery_data.json")
        
        guard let data = try? Data(contentsOf: dataURL),
              let sharedData = try? JSONDecoder().decode(SharedLotteryData.self, from: data) else {
            return nil
        }
        
        return sharedData
    }
    
    private func getDisplayName(for lottery: String) -> String {
        switch lottery.lowercased() {
        case "eurojackpot":
            return "Eurojackpot"
        case "6aus49":
            return "Lotto6aus49"
        default:
            return lottery.capitalized
        }
    }
    
    private func getIcon(for lottery: String) -> String {
        switch lottery.lowercased() {
        case "eurojackpot":
            return "eurosign"
        case "6aus49":
            return "eurosign.gauge.chart.lefthalf.righthalf"
        default:
            return "ticket.fill"
        }
    }
    
    private func getBackgroundGradient(for lottery: String) -> [Color] {
        switch lottery.lowercased() {
        case "eurojackpot":
            return [.yellow]
        case "6aus49":
            return [.yellow]
        default:
            return [.gray]
        }
    }
    
    private func formatTimeUntilNext(_ nextDrawDate: Date?) -> String {
        guard let nextDraw = nextDrawDate else {
            return "Unknown"
        }
        
        let now = Date()
        let timeInterval = nextDraw.timeIntervalSince(now)
        
        if timeInterval <= 0 {
            return "Now"
        }
        
        let days = Int(timeInterval / 86400)
        let hours = Int((timeInterval.truncatingRemainder(dividingBy: 86400)) / 3600)
        let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if days > 0 {
            return "\(days)d \(hours)h"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formatLastDrawDate(_ lastDrawDate: Date?) -> String {
        guard let date = lastDrawDate else {
            return "Unknown"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct LotteryTimelineEntry: TimelineEntry {
    let date: Date
    let lotteries: [WidgetLotteryData]
}

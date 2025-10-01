//
//  LotteryWidget.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 01.10.25.
//

import WidgetKit
import SwiftUI

struct LotteryWidget: Widget {
    let kind: String = "LotteryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LotteryTimelineProvider()) { entry in
            LotteryWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Lottery Results")
        .description("Lottery Results")
        .supportedFamilies([.systemLarge])
    }
}

struct LotteryWidgetEntryView: View {
    var entry: LotteryTimelineEntry

    var body: some View {
        LargeWidgetView(entry: entry)
    }
}

struct LargeWidgetView: View {
    let entry: LotteryTimelineEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                ForEach(entry.lotteries, id: \.lottery) { lottery in
                    WidgetLotteryCardView(lottery: lottery, size: .large)
                }
        }
        .padding()
    }
}

#Preview(as: .systemLarge) {
    LotteryWidget()
} timeline: {
    LotteryTimelineEntry(
        date: Date(),
        lotteries: []
    )
}

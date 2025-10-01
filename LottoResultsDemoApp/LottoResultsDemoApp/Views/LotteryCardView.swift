//
//  LotteryCardView.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import SwiftUI

struct LotteryCardView: View {
    let lotteryData: LotteryData
    let size: CardSize
    let showBackground: Bool
    
    init(lotteryData: LotteryData, size: CardSize = .medium, showBackground: Bool = true) {
        self.lotteryData = lotteryData
        self.size = size
        self.showBackground = showBackground
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            headerView
            dateView
            numbersView
            Spacer()
            footerView
        }
        .padding(padding)
        .background(backgroundView)
        .frame(height: cardHeight)
    }
    
    private var headerView: some View {
        HStack {
            Image(systemName: lotteryData.lotteryType?.icon ?? "questionmark.circle")
                .foregroundColor(.blue)
                .font(iconFont)
            
            Text(lotteryData.lotteryType?.displayName ?? lotteryData.lottery)
                .font(titleFont)
                .foregroundColor(.primary)
                .fontWeight(.bold)
            
            Spacer()
            
            if let jackpot = lotteryData.jackpotAmount {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Jackpot")
                        .font(captionFont)
                        .foregroundColor(.secondary)
                    Text(jackpot)
                        .font(captionFont)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    private var dateView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let lastDrawDate = lotteryData.lastDrawDate {
                Text("Last Draw: \(lastDrawDate.isoDateFormatter())")
                    .font(subtitleFont)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var numbersView: some View {
        HStack(spacing: numberSpacing) {
            if !lotteryData.lastDrawNumbers.isEmpty {
                HStack(spacing: numberSpacing) {
                    ForEach(lotteryData.lastDrawNumbers, id: \.self) { number in
                        NumberBallView(number: number, isMain: true, size: ballSize)
                    }
                }
            }
            
            if lotteryData.superNumber != nil || lotteryData.euroNumbers != nil {
                HStack(spacing: numberSpacing) {
                    if let superNumber = lotteryData.superNumber {
                        NumberBallView(number: superNumber, isMain: false, isSuperNumber: true, size: ballSize)
                    }
                    
                    if let euroNumbers = lotteryData.euroNumbers {
                        ForEach(euroNumbers, id: \.self) { number in
                            NumberBallView(number: number, isMain: false, isEuroNumber: true, size: ballSize)
                        }
                    }
                }
            }
        }
    }
    
    private var footerView: some View {
        HStack {
            Text("Next Draw:")
                .foregroundColor(.secondary)
                .font(subtitleFont)
            
            Spacer()
            
            Text(timeUntilNextDraw)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .foregroundColor(.primary)
                .font(subtitleFont.bold())
        }
    }
    
    private var backgroundView: some View {
        Group {
            if showBackground {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                    )
                    .shadow(radius: shadowRadius, x: 0, y: shadowOffset)
            } else {
                Color.clear
            }
        }
    }
    
    private var timeUntilNextDraw: String {
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
    
    private var spacing: CGFloat {
        switch size {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }
    
    private var padding: CGFloat {
        switch size {
        case .small: return 12
        case .medium: return 16
        case .large: return 20
        }
    }
    
    private var cardHeight: CGFloat {
        switch size {
        case .small: return 120
        case .medium: return 180
        case .large: return 220
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return 12
        case .medium: return 16
        case .large: return 20
        }
    }
    
    private var shadowRadius: CGFloat {
        switch size {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
    
    private var shadowOffset: CGFloat {
        switch size {
        case .small: return 2
        case .medium: return 3
        case .large: return 4
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small: return .title3
        case .medium: return .title2
        case .large: return .title
        }
    }
    
    private var titleFont: Font {
        switch size {
        case .small: return .subheadline
        case .medium: return .headline
        case .large: return .title2
        }
    }
    
    private var subtitleFont: Font {
        switch size {
        case .small: return .caption
        case .medium: return .subheadline
        case .large: return .headline
        }
    }
    
    private var captionFont: Font {
        switch size {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .subheadline
        }
    }
    
    private var numberSpacing: CGFloat {
        switch size {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
    
    private var ballSize: NumberBallView.BallSize {
        switch size {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        }
    }
}

enum CardSize {
    case small
    case medium
    case large
}

struct NumberBallView: View {
    let number: Int
    let isMain: Bool
    let isSuperNumber: Bool
    let isEuroNumber: Bool
    let size: BallSize
    
    enum BallSize {
        case small, medium, large
        
        var diameter: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 28
            case .large: return 36
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 14
            case .large: return 16
            }
        }
    }
    
    init(number: Int, isMain: Bool, isSuperNumber: Bool = false, isEuroNumber: Bool = false, size: BallSize = .medium) {
        self.number = number
        self.isMain = isMain
        self.isSuperNumber = isSuperNumber
        self.isEuroNumber = isEuroNumber
        self.size = size
    }
    
    var body: some View {
        Circle()
            .fill(ballColor)
            .frame(width: size.diameter, height: size.diameter)
            .overlay(
                Text("\(number)")
                    .foregroundColor(.white)
                    .font(.system(size: size.fontSize, weight: .bold))
            )
            .overlay(
                Circle()
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
    }
    
    private var ballColor: Color {
        if isSuperNumber {
            return .red
        } else if isEuroNumber {
            return .yellow
        } else if isMain {
            return .blue
        } else {
            return .gray
        }
    }
    
    private var borderColor: Color {
        if isSuperNumber || isEuroNumber {
            return .white
        } else {
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        (isSuperNumber || isEuroNumber) ? 1.5 : 0
    }
}

extension LotteryData {
    var lotteryType: LottoTypeProtocol? {
        LotteryTypeFactory.createType(for: self.lottery)
    }
}


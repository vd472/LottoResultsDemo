//
//  WidgetLotteryCardView.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 01.10.25.
//

import SwiftUI

// MARK: - Widget Lottery Card View
struct WidgetLotteryCardView: View {
    let lottery: WidgetLotteryData
    let size: WidgetCardSize
    
    init(lottery: WidgetLotteryData, size: WidgetCardSize = .medium) {
        self.lottery = lottery
        self.size = size
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
            Image(systemName: lottery.icon)
                .foregroundColor(.blue)
                .font(iconFont)
            
            Text(lottery.displayName)
                .font(titleFont)
                .foregroundColor(.primary)
                .fontWeight(.bold)
            
            Spacer()
            
            if let jackpot = lottery.jackpotAmount {
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
    
    private var numbersView: some View {
        HStack(spacing: numberSpacing) {
            if !lottery.lastDrawNumbers.isEmpty {
                HStack(spacing: numberSpacing) {
                    ForEach(lottery.lastDrawNumbers, id: \.self) { number in
                        WidgetNumberBallView(number: number, isMain: true, size: ballSize)
                    }
                }
            }
        
            if lottery.superNumber != nil || lottery.euroNumbers != nil {
                HStack(spacing: numberSpacing) {
                    if let superNumber = lottery.superNumber {
                        WidgetNumberBallView(number: superNumber, isMain: false, isSuperNumber: true, size: ballSize)
                    }
                    
                    if let euroNumbers = lottery.euroNumbers {
                        ForEach(euroNumbers, id: \.self) { number in
                            WidgetNumberBallView(number: number, isMain: false, isEuroNumber: true, size: ballSize)
                        }
                    }
                }
            }
        }
    }

    private var dateView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Last Draw: \(String(describing:lottery.formattedLastDrawDate!))")
                .font(subtitleFont)
                .foregroundColor(.secondary)
        }
    }
    
    private var footerView: some View {
        HStack {
            Text("Next Draw: \(lottery.timeUntilNextDraw)")
                .font(subtitleFont)
                .foregroundColor(.secondary)
        }
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(.systemGray4), lineWidth: 0.5)
            )
    }
    
    private var spacing: CGFloat {
        switch size {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
    
    private var padding: CGFloat {
        switch size {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        }
    }
    
    private var cardHeight: CGFloat {
        switch size {
        case .small: return 80
        case .medium: return 100
        case .large: return 120
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small: return .caption
        case .medium: return .caption
        case .large: return .caption
        }
    }
    
    private var titleFont: Font {
        switch size {
        case .small: return .caption
        case .medium: return .caption
        case .large: return .caption
        }
    }
    
    private var subtitleFont: Font {
        switch size {
        case .small: return .caption2
        case .medium: return .caption2
        case .large: return .caption2
        }
    }
    
    private var captionFont: Font {
        switch size {
        case .small: return .caption2
        case .medium: return .caption2
        case .large: return .caption2
        }
    }
    
    private var numberSpacing: CGFloat {
        switch size {
        case .small: return 2
        case .medium: return 3
        case .large: return 4
        }
    }
    
    private var ballSize: WidgetNumberBallView.BallSize {
        switch size {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        }
    }
}

enum WidgetCardSize {
    case small
    case medium
    case large
}

struct WidgetNumberBallView: View {
    let number: Int
    let isMain: Bool
    let isSuperNumber: Bool
    let isEuroNumber: Bool
    let size: BallSize
    
    enum BallSize {
        case small, medium, large
        
        var diameter: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 20
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            case .large: return 10
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

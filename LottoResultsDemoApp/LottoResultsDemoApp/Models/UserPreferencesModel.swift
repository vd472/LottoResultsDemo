//
//  UserPreferencesModel.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Foundation
import SwiftData

@Model
class UserPreferences {
    @Attribute(.unique) var id: String = "user_preferences"
    var selectedLotteryTypes: [String]
    var refreshInterval: TimeInterval
    var lastUpdated: Date
    
    init(selectedLotteryTypes: [String] = [], refreshInterval: TimeInterval = 300) {
        self.selectedLotteryTypes = selectedLotteryTypes
        self.refreshInterval = refreshInterval
        self.lastUpdated = Date()
    }
    
    var hasSelectedLotteries: Bool {
        return !selectedLotteryTypes.isEmpty
    }
    
    var isLotterySelected: (String) -> Bool {
        return { identifier in
            self.selectedLotteryTypes.contains(identifier)
        }
    }
}

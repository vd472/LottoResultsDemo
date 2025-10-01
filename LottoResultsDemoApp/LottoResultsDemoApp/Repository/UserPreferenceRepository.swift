//
//  UserPreferenceRepository.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Combine
import SwiftData
import Foundation

class UserPreferencesManager: ObservableObject {
    @Published var preferences: UserPreferences
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.preferences = UserPreferences()
        if let existing = loadPreferences() {
            self.preferences = existing
        } else {
            self.preferences = UserPreferences()
            modelContext.insert(self.preferences)
            savePreferences()
        }
    }

    func selectLottery(_ identifier: String) {
        if !preferences.selectedLotteryTypes.contains(identifier) {
            preferences.selectedLotteryTypes.append(identifier)
            savePreferences()
        }
    }
    
    func deselectLottery(_ identifier: String) {
        preferences.selectedLotteryTypes.removeAll { $0 == identifier }
        savePreferences()
    }
        
    func setSelectedLotteries(_ identifiers: [String]) {
            preferences.selectedLotteryTypes = identifiers
            savePreferences()
    }
    
    private func loadPreferences() -> UserPreferences? {
        let descriptor = FetchDescriptor<UserPreferences>(
            predicate: #Predicate { $0.id == "user_preferences" }
        )
        do {
            let results = try modelContext.fetch(descriptor)
            return results.first
        } catch {
            print("Failed to load preferences: \(error)")
            return nil
        }
    }
    
    private func savePreferences() {
        preferences.lastUpdated = Date()
        do {
            try modelContext.save()
        } catch {
            print("Failed to save preferences: \(error)")
        }
    }
}

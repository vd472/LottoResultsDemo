//
//  LotteryViewModel.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 01.10.25.
//

import Foundation
import Combine
import SwiftData
import WidgetKit

// MARK: - Lottery View Model
@MainActor
class LotteryViewModel: ObservableObject {
    // Single simple state: the current lotteries to display
    @Published var lotteries: [LotteryData] = []
    @Published var errorMessage: String? = nil
    
    private let repository: LotteryRepositoryProtocol
    private let preferencesManager: UserPreferencesManager
    private let widgetDataService = WidgetDataService.shared
    private var refreshTimer: Timer?
    
    init(repository: LotteryRepositoryProtocol, preferencesManager: UserPreferencesManager) {
        self.repository = repository
        self.preferencesManager = preferencesManager
        self.startTimer()
    }
    private func startTimer() {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
                Task { @MainActor in
                    await self?.refreshData()
                }
            }
        }
    
    deinit {
        refreshTimer?.invalidate()
    }
    
    // MARK: - Public Methods
    func loadData() async {
        guard preferencesManager.preferences.hasSelectedLotteries else {
            lotteries = []
            return
        }
        do {
            let selectedIdentifiers = preferencesManager.preferences.selectedLotteryTypes
            lotteries = try await repository.fetchLotteryData(for: selectedIdentifiers)
            // Update widget data
            widgetDataService.updateWidgetData(with: lotteries)
        } catch {
            // On failure, keep existing cached state if available
            do {
                lotteries = try await repository.getCachedLotteryData(for: preferencesManager.preferences.selectedLotteryTypes)
                // Update widget data with cached data
                widgetDataService.updateWidgetData(with: lotteries)
            } catch {
                lotteries = []
                errorMessage = (error as? LocalizedError)?.errorDescription ?? "Failed to load data. Please check your connection."
            }
        }
    }
    
    func refreshData() async {
        guard preferencesManager.preferences.hasSelectedLotteries else { return }
        do {
            let selectedIdentifiers = preferencesManager.preferences.selectedLotteryTypes
            let newData = try await repository.fetchLotteryData(for: selectedIdentifiers)
            lotteries = newData
            // Update widget data
            widgetDataService.updateWidgetData(with: lotteries)
        } catch {
            // keep current lotteries on refresh failure
            if lotteries.isEmpty {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? "Failed to refresh. Please check your connection."
            }
        }
    }
    
    func retry() async { await loadData() }
    
    // MARK: - Lottery Selection Methods
    func onLotterySelectionChanged() async {
        // Reload data when user changes lottery selection
        await loadData()
    }
    
    func addLottery(_ identifier: String) async {
        preferencesManager.selectLottery(identifier)
        await onLotterySelectionChanged()
    }
    
    func removeLottery(_ identifier: String) async {
        preferencesManager.deselectLottery(identifier)
        await onLotterySelectionChanged()
    }
    
    func refreshSingleLottery(_ identifier: String) async {
        do {
            if let lotteryData = try await repository.fetchSingleLotteryData(for: identifier) {
                if let index = lotteries.firstIndex(where: { $0.lottery == identifier }) {
                    lotteries[index] = lotteryData
                } else {
                    lotteries.append(lotteryData)
                }
                // Update widget data
                widgetDataService.updateWidgetData(with: lotteries)
            }
        } catch {
            if lotteries.isEmpty {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? "Failed to refresh. Please check your connection."
            }
        }
    }
}

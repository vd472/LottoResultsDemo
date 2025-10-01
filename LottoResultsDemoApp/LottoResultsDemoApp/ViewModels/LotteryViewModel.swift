//
//  LotteryViewModel.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 01.10.25.
//

import Foundation
import Combine
import SwiftData


@MainActor
class LotteryViewModel: ObservableObject {
    @Published var lotteries: [LotteryData] = []
    @Published var errorMessage: String? = nil
    
    private let repository: LotteryRepositoryProtocol
    private let preferencesManager: UserPreferencesManager
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
    
    func loadData() async {
        guard preferencesManager.preferences.hasSelectedLotteries else {
            lotteries = []
            return
        }
        do {
            let selectedIdentifiers = preferencesManager.preferences.selectedLotteryTypes
            lotteries = try await repository.fetchLotteryData(for: selectedIdentifiers)
        } catch {
            do {
                lotteries = try await repository.getCachedLotteryData(for: preferencesManager.preferences.selectedLotteryTypes)
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
        } catch {
            if lotteries.isEmpty {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? "Failed to refresh. Please check your connection."
            }
        }
    }
    
    func onLotterySelectionChanged() async {
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
            }
        } catch {
            if lotteries.isEmpty {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? "Failed to refresh. Please check your connection."
            }
        }
    }
}

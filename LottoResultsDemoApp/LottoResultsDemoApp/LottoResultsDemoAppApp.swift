//
//  LottoResultsDemoAppApp.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import SwiftUI
import SwiftData

@main
struct LottoResultsDemoAppApp: App {
    private let container: ModelContainer
    private let preferencesManager: UserPreferencesManager
    private let repository: LotteryRepositoryProtocol
    @StateObject private var viewModel: LotteryViewModel
    
    init() {
        let schema = Schema([LotteryData.self, UserPreferences.self])
        let container = try! ModelContainer(for: schema)
        let context = container.mainContext
        let preferencesManager = UserPreferencesManager(modelContext: context)
        let repository = LotteryRepositoryFactory.create(modelContext: context)
        let viewModel = LotteryViewModel(repository: repository, preferencesManager: preferencesManager)
        
        self.container = container
        self.preferencesManager = preferencesManager
        self.repository = repository
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel, preferencesManager: preferencesManager)
                .modelContainer(container)
        }
    }
}

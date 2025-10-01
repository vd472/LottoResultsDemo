//
//  ContentView.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var viewModel: LotteryViewModel
    @ObservedObject var preferencesManager: UserPreferencesManager
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.lotteries.isEmpty {
                    emptyState
                } else {
                    listState
                }
            }
            .navigationTitle("Lotteries")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    LotteryFilterButton(preferencesManager: preferencesManager)
                }
            }
            .task { await viewModel.loadData() }
            .onChange(of: preferencesManager.preferences.lastUpdated) { _, _ in
                Task { await viewModel.loadData() }
            }
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .active {
                    Task { await viewModel.refreshData() }
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("No lotteries selected")
                .font(.headline)
            Text("Use the filter to pick lotteries you care about.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            LotteryFilterButton(preferencesManager: preferencesManager)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    private var listState: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.lotteries, id: \.lottery) { data in
                    LotteryCardView(lotteryData: data, size: .medium)
                        .swipeActions(edge: .trailing) {
                            Button("Refresh") {
                                Task { await viewModel.refreshSingleLottery(data.lottery) }
                            }.tint(.blue)
                        }
                }
            }
            .padding(.vertical, 16)
        }
        .refreshable { await viewModel.refreshData() }
    }
}

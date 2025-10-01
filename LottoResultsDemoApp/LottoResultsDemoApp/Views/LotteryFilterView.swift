//
//  FilterView.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import SwiftUI
import SwiftData

struct LotteryFilterView: View {
    @ObservedObject var preferencesManager: UserPreferencesManager
    @Environment(\.dismiss) private var dismiss
    @State private var stagedSelected: Set<String> = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                lotteryTypesList
                actionButtons
            }
            .navigationTitle("Select Lotteries")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        preferencesManager.setSelectedLotteries(Array(stagedSelected))
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                stagedSelected = Set(preferencesManager.preferences.selectedLotteryTypes)
            }
        }
    }
    
    private var lotteryTypesList: some View {
        List {
            Section {
                ForEach(filteredLotteryTypes, id: \.identifier) { lotteryType in
                    LotteryTypeSelectionRow(
                        lotteryType: lotteryType,
                        isSelected: stagedSelected.contains(lotteryType.identifier),
                        onToggle: {
                            if stagedSelected.contains(lotteryType.identifier) {
                                stagedSelected.remove(lotteryType.identifier)
                            } else {
                                stagedSelected.insert(lotteryType.identifier)
                            }
                        }
                    )
                }
            } header: {
                HStack {
                    Text("Available Lotteries")
                    Spacer()
                    Text("\(stagedSelected.count) selected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button("Select All") {
                    let allTypes = LotteryTypeFactory.allTypes().map { $0.identifier }
                    stagedSelected = Set(allTypes)
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
                
                Button("Clear All") {
                    stagedSelected.removeAll()
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
            
            if stagedSelected.isEmpty {
                Text("Select at least one lottery to view results")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
  
    private var filteredLotteryTypes: [LottoTypeProtocol] {
        return LotteryTypeFactory.allTypes()
    }
}

struct LotteryTypeSelectionRow: View {
    let lotteryType: LottoTypeProtocol
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .secondary)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            Image(systemName: lotteryType.icon)
                .foregroundColor(.blue)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lotteryType.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle()
        }
    }
}

struct LotteryFilterButton: View {
    @ObservedObject var preferencesManager: UserPreferencesManager
    @State private var showingFilter = false
    
    var body: some View {
        Button(action: {
            showingFilter = true
        }) {
            HStack(spacing: 6) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text("Filter")
                if preferencesManager.preferences.hasSelectedLotteries {
                    Text("(\(preferencesManager.preferences.selectedLotteryTypes.count))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .sheet(isPresented: $showingFilter) {
            LotteryFilterView(preferencesManager: preferencesManager)
        }
    }
}


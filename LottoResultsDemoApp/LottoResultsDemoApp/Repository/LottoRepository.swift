//
//  LottoRepository.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Foundation
import SwiftData

@MainActor
protocol LotteryRepositoryProtocol {
    func fetchLotteryData(for identifiers: [String]) async throws -> [LotteryData]
    func fetchSingleLotteryData(for identifier: String) async throws -> LotteryData?
    func saveLotteryData(_ data: [LotteryData]) async throws
    func saveSingleLotteryData(_ data: LotteryData) async throws
    func getCachedLotteryData(for identifiers: [String]) async throws -> [LotteryData]
    func clearCache() async throws
    func clearCache(for identifier: String) async throws
}

struct CacheConfiguration {
    let maxAge: TimeInterval
    let maxCacheSize: Int
    
    static let `default` = CacheConfiguration(
        maxAge: 300,
        maxCacheSize: 100
    )
}

class LotteryRepository: LotteryRepositoryProtocol {
    private let apiService: LotteryAPIServiceProtocol
    private let modelContext: ModelContext
    private let cacheConfiguration: CacheConfiguration
    
    init(
        apiService: LotteryAPIServiceProtocol = LotteryAPIService(),
        modelContext: ModelContext,
        cacheConfiguration: CacheConfiguration = .default
    ) {
        self.apiService = apiService
        self.modelContext = modelContext
        self.cacheConfiguration = cacheConfiguration
    }
    
    func fetchLotteryData(for identifiers: [String]) async throws -> [LotteryData] {
        do {
            let responses = try await apiService.fetchMultipleLotteryResults(for: identifiers)
            let lotteryData = responses.map { LotteryData(from: $0) }
            try await saveLotteryData(lotteryData)
            return lotteryData
        } catch {
            print("API failed for identifiers \(identifiers), attempting to use cached data: \(error)")
            return try await getCachedLotteryData(for: identifiers)
        }
    }
    
    func fetchSingleLotteryData(for identifier: String) async throws -> LotteryData? {
        do {
            let response = try await apiService.fetchLotteryResult(for: identifier)
            let lotteryData = LotteryData(from: response)
            try await saveSingleLotteryData(lotteryData)
            return lotteryData
        } catch {
            print("API failed for \(identifier), attempting to use cached data: \(error)")
            let cachedData = try await getCachedLotteryData(for: [identifier])
            return cachedData.first
        }
    }
    
    func saveLotteryData(_ data: [LotteryData]) async throws {
        try await clearCache()
        for lotteryData in data {
            modelContext.insert(lotteryData)
        }
        try modelContext.save()
    }
    
    func saveSingleLotteryData(_ data: LotteryData) async throws {
        try await clearCache(for: data.lottery)
        modelContext.insert(data)
        try modelContext.save()
    }
    
    func getCachedLotteryData(for identifiers: [String]) async throws -> [LotteryData] {
        let descriptor = FetchDescriptor<LotteryData>(
            predicate: #Predicate { data in
                identifiers.contains(data.lottery)
            },
            sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)]
        )
        let cachedData = try modelContext.fetch(descriptor)
        let now = Date()
        let validData = cachedData.filter { data in
            now.timeIntervalSince(data.lastUpdated) < cacheConfiguration.maxAge
        }
        guard !validData.isEmpty else {
            throw ApiErrors.noData
        }
        return validData
    }
    
    func clearCache() async throws {
        let descriptor = FetchDescriptor<LotteryData>()
        let allData = try modelContext.fetch(descriptor)
        for data in allData {
            modelContext.delete(data)
        }
        try modelContext.save()
    }
    
    func clearCache(for identifier: String) async throws {
        let descriptor = FetchDescriptor<LotteryData>(
            predicate: #Predicate { data in
                data.lottery == identifier
            }
        )
        let dataToDelete = try modelContext.fetch(descriptor)
        for data in dataToDelete {
            modelContext.delete(data)
        }
        try modelContext.save()
    }
}



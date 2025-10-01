//
//  LottoAPIService.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Foundation

protocol LotteryAPIServiceProtocol {
    func fetchLotteryResults() async throws -> [LotteryResults]
    func fetchLotteryResult(for identifier: String) async throws -> LotteryResults
    func fetchMultipleLotteryResults(for identifiers: [String]) async throws -> [LotteryResults]
}

class LotteryAPIService: LotteryAPIServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchLotteryResults() async throws -> [LotteryResults] {
        let request = LottoAPIRequest()
        return try await networkService.request(request, responseType: [LotteryResults].self)
    }
    
    func fetchLotteryResult(for identifier: String) async throws -> LotteryResults {
        let request = LottoAPIRequest(lotteryIdentifiers: [identifier])
        let array: [LotteryResults] = try await networkService.request(request, responseType: [LotteryResults].self)
        if let first = array.first { return first }
        throw ApiErrors.noData
    }
    
    func fetchMultipleLotteryResults(for identifiers: [String]) async throws -> [LotteryResults] {
        let request = LottoAPIRequest(lotteryIdentifiers: identifiers)
        return try await networkService.request(request, responseType: [LotteryResults].self)
    }
}

//
//  Untitled.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Foundation
import SwiftData

class LotteryRepositoryFactory {
    static func create(modelContext: ModelContext) -> LotteryRepositoryProtocol {
        return LotteryRepository(modelContext: modelContext)
    }
}

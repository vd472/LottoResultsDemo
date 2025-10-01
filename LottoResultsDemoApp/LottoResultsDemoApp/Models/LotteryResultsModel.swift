//
//  LottoResultsModel.swift
//  LotteryResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

struct LotteryResults: Codable {
    let lottery: String
    let lastDraw: LastDraw?
    let nextDraw: NextDraw?
    // TODO: Add more parameters if required
}

struct LastDraw: Codable {
    let drawIdentifier: String?
    let lottery: String?
    let drawDate: String?
    let drawResult: DrawResult
    let currency: String?
    // TODO: Add more parameters if required
}

struct DrawResult: Codable {
    let numbers: [Int]?
    let superNumber: Int?
    let euroNumbers: [Int]?
}

struct NextDraw: Codable {
    let drawIdentifier: String?
    let lottery: String?
    let drawDate: String?
    let jackpot: Jackpot?
    // TODO: Add more parameters if required
}

struct Jackpot: Codable {
    let drawIdentifier: String?
    let lottery: String?
    let drawDate: String?
    let currency: String?
    let jackpots: [String: String]?
    // TODO: Add more parameters if required
}










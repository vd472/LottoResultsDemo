//
//  Untitled.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Foundation
import SwiftUI

protocol LottoTypeProtocol {
    var identifier: String {get}
    var displayName: String {get}
    var icon: String { get }
    var backgroundGradientColor: [Color] { get }
    var apiData: LotteryResults? { get set }
}

class LotteryTypeFactory {
    static func createType(for identifier: String) -> LottoTypeProtocol? {
        switch identifier {
        case "6aus49":
            return Lotto6aus49()
        case "eurojackpot":
            return Eurojackpot()
        default:
            return nil
        }
    }
    
    static func allTypes() -> [LottoTypeProtocol] {
        return [Lotto6aus49(), Eurojackpot()]
    }
}

struct Eurojackpot: LottoTypeProtocol {
    var identifier: String = "eurojackpot"
    var displayName: String = "Eurojackpot"
    var icon: String = "eurosign"
    var backgroundGradientColor: [Color] = [.yellow]
    var apiData: LotteryResults?
}

struct Lotto6aus49: LottoTypeProtocol {
    var identifier: String = "6aus49"
    var displayName: String = "Lotto6aus49"
    var icon: String = "eurosign.gauge.chart.lefthalf.righthalf"
    var backgroundGradientColor: [Color] = [.yellow]
    var apiData: LotteryResults?
}

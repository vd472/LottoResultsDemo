//
//  NetworkServiceEnvironment.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Foundation

enum NetworkServiceEnvironment {
    case development
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .development:
            return  "https://www.lotto24.de/public/v1/drawinfo/aggregated"
        case .staging:
            return  "https://www.lotto24.de/public/v1/drawinfo/aggregated"
        case .production:
            return  "https://www.lotto24.de/public/v1/drawinfo/aggregated"
        }
    }
}

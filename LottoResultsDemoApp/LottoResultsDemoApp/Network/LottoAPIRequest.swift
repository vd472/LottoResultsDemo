//
//  LottoApiRequest.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 30.09.25.
//

import Foundation

protocol NetworkRequest {
    var url: URL? { get }
    var method: HTTPMethod { get }
    // TODO: add more if needed
}

struct LottoAPIRequest: NetworkRequest {
    let url: URL?
    let method: HTTPMethod = .get
    let baseURL: String = NetworkServiceEnvironment.development.baseURL
    
    init(lotteryIdentifiers: [String]? = nil) {
        if let ids = lotteryIdentifiers, !ids.isEmpty {
            let joined = ids.joined(separator: ",")
            self.url = URL(string: "\(baseURL)/\(joined)")
        } else {
            self.url = URL(string: baseURL)
        }
    }
    // TODO: add more if needed
}

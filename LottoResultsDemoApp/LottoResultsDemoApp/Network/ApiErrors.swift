//
//  ApiErrors.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import Foundation

enum ApiErrors: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(underlyingError: Error)
    case noData
    case requestError(underlyingError: Error)
    // TODO: add more if required

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)."
        case .decodingError(let underlyingError):
            return "Failed to decode the response: \(underlyingError.localizedDescription)"
        case .noData:
            return "No data was returned by the server."
        case .requestError(let underlyingError):
            return "An error occurred during the request: \(underlyingError.localizedDescription)"
        }
    }
}

//
//  NetworkService.swift
//  LottoResultsDemoApp
//
//  Created by vijayesha on 29.09.25.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // TODO: add more if needed
}

protocol NetworkServiceProtocol {
    @MainActor
    func request<T: Codable>(_ request: NetworkRequest, responseType: T.Type) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    init() {}

    func request<T: Codable>(_ request: NetworkRequest, responseType: T.Type) async throws -> T {
        guard let url = request.url else {
            throw ApiErrors.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiErrors.requestError(underlyingError: URLError(.badServerResponse))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw ApiErrors.httpError(statusCode: httpResponse.statusCode)
            }
            guard !data.isEmpty else {
                throw ApiErrors.noData
            }
            let decoder = JSONDecoder()
            return try decoder.decode(responseType, from: data)
        } catch let error as ApiErrors {
            throw error
        } catch {
            throw ApiErrors.requestError(underlyingError: error)
        }
    }
}



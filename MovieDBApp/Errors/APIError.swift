//
//  APIError.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import Foundation


enum APIError: Error {
    case decodingError(Error)
    case errorCode(Int)
    case unknown
}


extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError(let error):
            return "Error decoding: - \(error.localizedDescription)"
        case .errorCode(let code):
            return "Error with code: \(code)"
        case .unknown:
            return "Unknown error"
        }
    }
}

//
//  ApiResponse.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 26/1/23.
//

import Foundation

struct ApiResponse: Decodable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
}

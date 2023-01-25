//
//  MovieDBEndpoint.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import Foundation


private let api_key = "5246ab977f52f9081f9a018203308809"

private var pageSearch: Int = 1

protocol APIBuilderProtocol {
    var baseUrl: URL { get }
    var path: String { get }
    var urlRequest: URLRequest { get }
}


enum MovieDBApi {
    case getPopularMovies(page: Int)
    case getMovieDetails(id: Int)
    case getPopularTvShows(page: Int)
    case getTvShowDetails(id: Int)
}


extension MovieDBApi: APIBuilderProtocol {
    
    var baseUrl: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
            case .getPopularMovies(let page):
                pageSearch = page
                return "movie/popular"
            case .getMovieDetails(let id):
                return "movie/\(id)"
            case .getPopularTvShows(let page):
                pageSearch = page
                return "tv/popular"
            case .getTvShowDetails(let id):
                return "tv/\(id)"
        }
    }
    
    var urlRequest: URLRequest {
        return URLRequest(url: baseUrl.appendingPathComponent(self.path)
                                      .appending(queryItems:
                                                    [
                                                        URLQueryItem(name: "api_key", value: api_key),
                                                        URLQueryItem(name: "page", value: "\(pageSearch)"),
                                                    ])
                        )
    }
    
}


//https://api.themoviedb.org/3/movie/popular?api_key=5246ab977f52f9081f9a018203308809&page=1&language=es

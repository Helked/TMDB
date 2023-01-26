//
//  MovieDBEndpoint.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import Foundation



private var pageSearch: Int = 1
private var titleSearch: String?


protocol APIBuilderProtocol {
    var baseUrl: URL { get }
    var path: String { get }
    var urlRequest: URLRequest { get }
}


enum MovieDBApi {
    case getPopularMovies(page: Int)
    case getMovieDetails(id: Int)
    case searchMovie(title: String, page: Int)
    case getPopularTvShows(page: Int)
    case getTvShowDetails(id: Int)
    case searchTvShow(title: String, page: Int)
}


extension MovieDBApi: APIBuilderProtocol {
    
    var baseUrl: URL {
        return URL(string: API_URL)!
    }
    
    var path: String {
        switch self {
            case .getPopularMovies(let page):
                titleSearch = nil
                pageSearch = page
                return "movie/popular"
            case .getMovieDetails(let id):
                titleSearch = nil
                return "movie/\(id)"
            case .searchMovie(let title, let page):
                pageSearch = page
                titleSearch = title
                return "search/movie"
            case .getPopularTvShows(let page):
                titleSearch = nil
                pageSearch = page
                return "tv/popular"
            case .getTvShowDetails(let id):
                titleSearch = nil
                return "tv/\(id)"
            case .searchTvShow(let title, let page):
                pageSearch = page
                titleSearch = title
                return "search/tv"
        }
    }
    
    var urlRequest: URLRequest {
        
        let path = self.path
        
        var queryItems = [
            URLQueryItem(name: "api_key", value: API_KEY),
            URLQueryItem(name: "page", value: "\(pageSearch)"),
        ]
        
        if(titleSearch != nil){
            queryItems.append(
                URLQueryItem(name: "query", value: titleSearch!)
            )
        }
        
        return URLRequest(url: baseUrl.appendingPathComponent(path).appending(queryItems: queryItems))
        
    }
    
}




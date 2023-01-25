//
//  MovieDBEndpoint.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import Foundation


private let api_key = "5246ab977f52f9081f9a018203308809"

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
    case searchMovie(title: String)
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
                titleSearch = nil
                pageSearch = page
                return "movie/popular"
            case .getMovieDetails(let id):
                titleSearch = nil
                return "movie/\(id)"
            case .searchMovie(let title):
                titleSearch = title
                return "search/movie"
            case .getPopularTvShows(let page):
                titleSearch = nil
                pageSearch = page
                return "tv/popular"
            case .getTvShowDetails(let id):
                titleSearch = nil
                return "tv/\(id)"
        }
    }
    
    var urlRequest: URLRequest {
        
        
        let path = self.path
        
        var queryItems = [
            URLQueryItem(name: "api_key", value: api_key),
            URLQueryItem(name: "page", value: "\(pageSearch)"),
        ]
        
        if(titleSearch != nil){
            print(titleSearch!)
            queryItems.append(
                URLQueryItem(name: "query", value: titleSearch!)
            )
        }
        
        let urlrequest = URLRequest(url: baseUrl.appendingPathComponent(path).appending(queryItems: queryItems))
        
        
        
        
        
        print(urlrequest)
        
        return urlrequest
                
        
    }
    
}




//
//  MovieDBViewModel.swift
//  MovieDBApp
//
//  Created by Rafa Garrido on 24/1/23.
//

import Foundation
import Combine


class MovieDBViewModel: ObservableObject {
    
    private var page: Int = 1
    private var totalPages: Int = 1
    
    private let service: MovieDBService
    
    private(set) var movieList = [Movie]()
    private(set) var genresList = [Genre]()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState = .loading
    
    
    init(service: MovieDBService) {
        self.service = service
    }
    
   
    
    func getPopularMovies() {
        if(self.page == 1){
            self.state = .loading
        }
        
        let cancellable = service
            .request(from: .getPopularMovies(page: page), decodingType: ApiResponse.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.movieList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.movieList.append(contentsOf: response.movies)
                self.totalPages = response.totalPages
            }
        self.cancellables.insert(cancellable)
   
    }
    
    
    func getMovieDetails(movieId: Int) {
        
        self.state = .loading
        let cancellable = service
            .request(from: .getMovieDetails(id: movieId), decodingType: Movie.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.movieList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.movieList.append(response)
            }
        self.cancellables.insert(cancellable)
    }
    
    
    private func searchMovie(by title: String) {
    
        let cancellable = service
            .request(from: .searchMovie(title: title, page: page), decodingType: ApiResponse.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success(content: self.movieList)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.movieList.append(contentsOf: response.movies)
                self.totalPages = response.totalPages
            }
        self.cancellables.insert(cancellable)
    }
    
    func refreshPopularMovies() {
        resetData()
        getPopularMovies()
    }
    
    
    
    func search(by title: String) {
        resetData()
        self.state = .loading
        
        searchMovie(by: title)
    }
    
    
    private func resetData() {
        self.page = 1
        self.totalPages = 1
        self.movieList.removeAll()
    }
    
    
    func loadMoreData(searchString: String?) {
        self.page += 1
        
        if(self.page <= self.totalPages){
            if(searchString == nil || searchString?.count == 0){
                getPopularMovies()
            }else{
                searchMovie(by: searchString!)
            }
            
        }
    }
    
    
    func getReleaseYear(movie: Movie) -> String {
        
        if(movie.release != nil){
            let dateComponents = movie.release!.components(separatedBy: "-")
            return dateComponents[0]
        }
        
        if(movie.firstDate != nil){
            let dateComponents = movie.firstDate!.components(separatedBy: "-")
            return dateComponents[0]
        }
        
        return ""
        
    }
    
    
    func getTitle(movie: Movie) -> String {
        if (movie.title != nil) { return movie.title! }
        if (movie.name != nil) { return movie.name! }
        return "No title"
    }
    
    
    
}


